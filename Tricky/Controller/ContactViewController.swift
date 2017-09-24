 //
 //  ContactViewController.swift
 //  OTPSection
 //
 //  Created by gopalsara on 19/08/17.
 //  Copyright © 2017 gopalsara. All rights reserved.
 //
 
 import UIKit
 import DZNEmptyDataSet

 class ContactViewController: UIViewController , UITableViewDelegate , UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var contactsArray = NSMutableArray()
    var arrSyncContacts = [[String : AnyObject]]()
    {
        didSet{
            self.tblContact.reloadData()
        }
    }
    @IBOutlet weak var imgBg : UIImageView!
    var isFromMenu : Bool = false
    var contactShowFrom : Int = 0
    
    @IBOutlet weak var tblContact : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decorateUI()
        self.doGetContactFromConactBook()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        if (self.contactShowFrom == 1)
        {
            self.navigationController?.navigationBar.barTintColor = color(red: 97, green: 118, blue: 138)
        }else if (self.contactShowFrom == 2)
        {
            self.navigationController?.navigationBar.barTintColor = color(red: 148, green: 108, blue: 139)
        }
        else{
            self.navigationController?.navigationBar.barTintColor = color(red: 148, green: 108, blue: 139)
        }
    }
    
    func decorateUI()
    {
        self.tblContact.emptyDataSetSource = self
        self.tblContact.emptyDataSetDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func doGetContactFromConactBook()
    {
        self.tblContact.tableFooterView = UIView()
        DispatchQueue.global(qos: .background).async
            {
                ContactPickerUtils.sharedContactPicker.getContctFromContactBook(target: self) { (contacts, error) in
                    DispatchQueue.main.async {
                        self.contactsArray = contacts
                        print(self.contactsArray)
                        self.doCallSyncContactsWS()
                    }
                }
        }
        var strTitle = ""
        if (self.contactShowFrom == 1)
        {
            strTitle = "txt_block_users".localized()
            self.imgBg.image = UIImage(named : BLOCK_LIST_BG)
        }else
        {
            strTitle = "txt_contacts".localized()
            self.imgBg.image = UIImage(named : ALL_CONTACTS_BG)
        }
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: strTitle, strBackButtonImage: BACK_BUTTON, selector: #selector(self.goTOBack), color: color(red: 142, green: 110, blue: 137))
    }
    
    func doCallSyncContactsWS()
    {
        var arrayTempContacts = [[String : String]]()
        for model in self.contactsArray
        {
            var dictContactsData = [String : String]()
            let contact: ContactModel
            contact =  model as! ContactModel
            
            for phoneNo in contact.phoneNumbers
            {
                let string = phoneNo.phoneNumber as AnyObject // string starts as "hello[]
                let badchar = CharacterSet(charactersIn: "\"-() ")
                let cleanedstring = string.components(separatedBy: badchar).joined()
                dictContactsData["userNumber"] =  cleanedstring.stringByRemovingWhitespaces as String
                dictContactsData["userName"] = contact.fullName! as String
                print(phoneNo)
                print(dictContactsData)
            }
            arrayTempContacts.append(dictContactsData)
            print(contact)
        }
        let data = ["data" : arrayTempContacts]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let theJSONText = String(data: jsonData,
                                     encoding: .utf8)
            
            let dictData = ["version" : "1.0" , "os" : "2" , "language" : "english","userId":UserManager.sharedUserManager.userId!, "requestData" : theJSONText!] as [String : Any]
            print(dictData)
            WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "SyncContact", parameter: dictData, success: { (obj) in
                if let dictContactsData = obj["responseData"] as? [[String : AnyObject]]
                {
                    self.arrSyncContacts.append(contentsOf: dictContactsData)
                    
                    if (self.contactShowFrom == 1){
                        self.doFilterBlockContactLis()
                    }
                    else if (self.contactShowFrom == 2)
                    {
                        self.doFilterAllContactWhichIsNotBlock()
                    }
                    else if (self.contactShowFrom == 3)
                    {
                        self.doFilterIsOnAppData()
                    }
                    
                }
                print(obj)
            }) { (error) in
                print(error!)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func doFilterIsOnAppData(){
        self.arrSyncContacts = self.arrSyncContacts.filter{ (($0["isOnApp"] as AnyObject)) as! NSNumber == 1 }
    }
    
    func doFilterBlockContactLis() {
        self.arrSyncContacts = self.arrSyncContacts.filter{ (($0["isBlock"] as AnyObject)) as! NSNumber == 1 }
    }
    
    func doFilterAllContactWhichIsNotBlock() {
        self.arrSyncContacts = self.arrSyncContacts.filter{ (($0["isBlock"] as AnyObject)) as! NSNumber != 1 }
    }
    
    func goTOBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    // MARK: - Table View DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrSyncContacts.count
    }
    
    // MARK: - Table View Delegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ContactTableViewCell
        let dataContacts = self.arrSyncContacts[indexPath.row]
        
        if self.contactShowFrom == 1 {
          cell.setBlockContactListData(dictData: dataContacts)
            
        } else if (self.contactShowFrom == 2){
           cell.setCompleteContactListDataOn(dictData: dataContacts)
        } else{
           cell.setAppUserContactListData(dictData: dataContacts)
        }
        cell.btnBlockOrInvite.tag = indexPath.row
        cell.btnBlockOrInvite.addTarget(self, action: #selector(self.doBlockOrUnblockUser(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !(self.isFromMenu)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserPostAnswerViewController")
                as! UserPostAnswerViewController
            let dictData = self.arrSyncContacts[indexPath.row] as [String : AnyObject]
            let userId = dictData["userId"] as! String
            let userName = dictData["userName"] as! String
             vc.strTitle = userName
            vc.strUserId = userId
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    
    func doBlockOrUnblockUser(sender : UIButton)
    {
        let dataContacts = self.arrSyncContacts[sender.tag]
        let isOnApp = dataContacts["isOnApp"] as! Bool
        if isOnApp {
       self.doCallServiceForBlockAndUnblock(sender: sender, dataContacts: dataContacts)
        }
    }
    
    func doCallServiceForBlockAndUnblock(sender : UIButton , dataContacts : [String : AnyObject]) {
        
        let blockUserId = dataContacts["userId"]!
        let dictData = ["version" : "1.0" , "os" : "1" , "language" : "english","userId":UserManager.sharedUserManager.userId!,"blockUserId":blockUserId] as [String : Any]
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "blockUser", parameter: dictData, success: { (responseObject) in
            
            print("this is response object \(responseObject)")
            self.arrSyncContacts.remove(at: sender.tag)
            CommonUtil.showTotstOnWindow(strMessgae: responseObject["responseMessage"]! as! String)
            
        }) { (error) in
        }

        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.00
    }
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString?
    {
        return  NSAttributedString(string:"txt_no_record".localized(), attributes:
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: Font_Helvetica_Neue, size: 14.0)!])
    }
 }
 
 extension String {
    
    var stringByRemovingWhitespaces: String {
        
        let components = self.components(separatedBy: .whitespaces)
        return components.joined(separator: "")
    }
 }
