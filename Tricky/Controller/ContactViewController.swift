 //
 //  ContactViewController.swift
 //  OTPSection
 //
 //  Created by gopalsara on 19/08/17.
 //  Copyright © 2017 gopalsara. All rights reserved.
 //
 
 import UIKit
 import DZNEmptyDataSet

 class ContactViewController: GAITrackedViewController , UITableViewDelegate , UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UISearchBarDelegate {
    
    var contactsArray = NSMutableArray()
    var arrSyncContacts = [[String : AnyObject]]()
    {
        didSet{
            self.tblContact.reloadData()
        }
    }
    
    var arrMainData = [[String : AnyObject]]()

    
    @IBOutlet weak var imgBg : UIImageView!
    var isFromMenu : Bool = false
    var contactShowFrom : Int = 0
    var searchBar : UISearchBar!
    var shouldSearchStart : Bool = false


    
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
            CommanUtility.createCustomRightButton(self, navBarItem: self.navigationItem, strRightImage: SEARCH_ICON as NSString, select: #selector(doClickSearch))
            self.searchBar = UISearchBar()
            self.searchBar.sizeToFit()
            self.searchBar.placeholder = "txt_search".localized()
            self.searchBar.delegate = self
            self.searchBar.isHidden = true

            self.navigationController?.navigationBar.barTintColor = color(red: 148, green: 108, blue: 139)
        }
        else{
            
            CommanUtility.createCustomRightButton(self, navBarItem: self.navigationItem, strRightImage: SEARCH_ICON as NSString, select: #selector(doClickSearch))
            self.searchBar = UISearchBar()
            self.searchBar.sizeToFit()
            self.searchBar.placeholder = "txt_search".localized()
            self.searchBar.delegate = self
            self.searchBar.isHidden = true
            self.navigationController?.navigationBar.barTintColor = color(red: 148, green: 108, blue: 139)
        }
    }
    
    func decorateUI(){
        self.tblContact.emptyDataSetSource = self
        self.tblContact.emptyDataSetDelegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func doGetContactFromConactBook()
    {
        CommonUtil.showLoader()
        self.tblContact.tableFooterView = UIView()
        DispatchQueue.global(qos: .background).async
            {
                ContactPickerUtils.sharedContactPicker.getContctFromContactBook(target: self) { (contacts, error) in
                    DispatchQueue.main.async {
                        self.contactsArray = contacts
                        self.doCallSyncContactsWS()
                    }
                }
        }
        var strTitle = "txt_AllContact".localized()
        if (self.contactShowFrom == 1){
            // Set screen name.
            self.screenName = "Blocked Contacts";
            strTitle = "txt_block_users".localized()
            self.imgBg.image = UIImage(named : BLOCK_LIST_BG)
        }else if(self.contactShowFrom == 2)
        {
            self.screenName = "Contact";
            strTitle = "txt_contacts".localized()
            self.imgBg.image = UIImage(named : ALL_CONTACTS_BG)
        }
        else if(self.contactShowFrom == 3){
            
            strTitle = "txt_select_cont".localized()
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
            }
            arrayTempContacts.append(dictContactsData)
        }
        let data = ["data" : arrayTempContacts]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            let theJSONText = String(data: jsonData,
                                     encoding: .utf8)
            
            let dictData = ["version" : "1.0" , "os" : "2" , "language" : "english","userId":CommonUtil.getUserId(), "requestData" : theJSONText!] as [String : Any]
            WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "SyncContact", parameter: dictData, success: { (obj) in
                if let dictContactsData = obj["responseData"] as? [[String : AnyObject]]
                {
                    self.arrMainData.append(contentsOf: dictContactsData)
                    self.arrSyncContacts = self.arrMainData
                    
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
            }) { (error) in
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let predicate = NSPredicate(format: "SELF contains %@", searchBar.text!)
        self.arrSyncContacts = self.arrMainData.filter { predicate.evaluate(with: $0["userName"]) }
        
        if (searchBar.text?.isEmpty)! {
            self.arrSyncContacts = self.arrMainData
        }
        self.tblContact.reloadData()
    }
    
    func doClickSearch(){
        if shouldSearchStart == false
        {
            navigationItem.titleView = self.searchBar
            self.searchBar.isHidden = false
        }else{
            navigationItem.titleView = nil
            self.searchBar.isHidden = true
            self.searchBar.text = ""
        }
        shouldSearchStart = !(self.searchBar.isHidden)
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
        if !(self.isFromMenu){
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
            
            var strMessage = "txt_block".localized()
            
            if sender.isSelected {
                strMessage = "txt_unblock".localized()
            }
            
            CommonUtil.showAlertInSwift_3Format(strMessage, title: "txt_trickychat".localized(), btnCancel: "txt_no".localized(), btnOk: "txt_yes".localized(), crl: self, successBlock: { (obj) in
                
                self.doCallServiceForBlockAndUnblock(sender: sender, dataContacts: dataContacts)
                
            }) { (obj) in
                print("ok")
            }
      
            
            
        }
        else{
       self.doActionOnShare(sender: sender)
        }
    }
    
    func doActionOnShare(sender : UIButton)
    {
        let shareText = "\("txt_Invite_Contact".localized())"
        print(shareText)
        let vc = UIActivityViewController(activityItems: [shareText ], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }

    
    func doCallServiceForBlockAndUnblock(sender : UIButton , dataContacts : [String : AnyObject]) {
        
        let blockUserId = dataContacts["userId"]!
        let dictData = ["version" : "1.0" , "os" : "1" , "language" : "english","userId":CommonUtil.getUserId(),"blockUserId":blockUserId] as [String : Any]
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "blockUser", parameter: dictData, success: { (responseObject) in
            
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
