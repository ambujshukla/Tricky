 //
 //  ContactViewController.swift
 //  OTPSection
 //
 //  Created by gopalsara on 19/08/17.
 //  Copyright © 2017 gopalsara. All rights reserved.
 //
 
 import UIKit
 import DZNEmptyDataSet
 
 @objc protocol ContactsPostDelegate{
    @objc optional func sendingMessageDone()
 }

 class ContactViewController: GAITrackedViewController , UITableViewDelegate , UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate, UISearchBarDelegate, UserPostDelegate {
    
    var delegate:ContactsPostDelegate?

    var contactsArray = NSMutableArray()
    var arrSyncContacts = [[String : AnyObject]]()
    {
        didSet{
            self.tblContact.reloadData()
        }
    }
    
    var arrMainData = [[String : AnyObject]]()
    var arrLocalData = [[String : AnyObject]]()

    
    @IBOutlet weak var imgBg : UIImageView!
    var isFromMenu : Bool = false
    var contactShowFrom : Int = 0
    var searchBar : UISearchBar!
    var shouldSearchStart : Bool = false
    
    @IBOutlet weak var tblContact : UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.decorateUI()
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
        self.arrMainData = CommanUtility.getObjectFromPrefrence(key: "contact")
        if self.arrMainData.count > 0{
            self.doCustmizeData()
            self.doGetContactFromConactBook(isShowLoader: false)
        }
        else{
            self.doGetContactFromConactBook(isShowLoader:  true)
        }
        
        let revealViewController: SWRevealViewController? = self.revealViewController()
        if revealViewController != nil {
            CommanUtility.decorateNavigationbarWithRevealToggleButton(target : revealViewController!, strTitle: "txt_trickychat".localized(), strBackButtonImage: "menuicon", selector: #selector(SWRevealViewController.revealToggle(_:)) , controller : self , color:  color(red: 56, green: 152, blue: 108) )
            navigationController?.navigationBar.addGestureRecognizer(revealViewController!.panGestureRecognizer())
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func doGetContactFromConactBook(isShowLoader : Bool)
    {
        if isShowLoader {
            CommonUtil.showLoader()
        }
        self.tblContact.tableFooterView = UIView()
        DispatchQueue.global(qos: .background).async
            {
                ContactPickerUtils.sharedContactPicker.getContctFromContactBook(target: self) { (contacts, error) in
                    DispatchQueue.main.async {
                        self.contactsArray = contacts
                        DispatchQueue.global(qos: .background).async{
                            self.doCallSyncContactsWS(isShowLoader: isShowLoader)
                        }
                    }
                }
        }

    }
    
    func doCallSyncContactsWS(isShowLoader : Bool)
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
            
            let dictData = ["version" : "1.0" , "os" : "2" , "language" : CommanUtility.getCurrentLanguage(),"userId":CommonUtil.getUserId(), "requestData" : theJSONText!] as [String : Any]
            WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOSTAndPullToRefresh(isShowLoder :isShowLoader , strURL: kBaseUrl, strServiceName: "SyncContact", parameter: dictData, success: { (obj) in
                if let dictContactsData = obj["responseData"] as? [[String : AnyObject]]
                {
                    print(dictContactsData)
                    self.arrMainData.removeAll()
                    self.arrMainData.append(contentsOf: dictContactsData)
                    CommanUtility.saveObjectInPreference(arrData: self.arrMainData, key: "contact")
                    self.doCustmizeData()
                    CommonUtil.hideLoader()
                }
            }) { (error) in
                CommonUtil.hideLoader()
            }
        } catch {
            CommonUtil.hideLoader()
            print(error.localizedDescription)
        }
    }
    
    func doCustmizeData(){
        
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
    
    func doFilterIsOnAppData(){
        self.arrLocalData = self.arrSyncContacts.filter{ (($0["isOnApp"] as AnyObject)) as! NSNumber == 1 }
        self.arrSyncContacts = self.arrLocalData
    }
    
    func doFilterBlockContactLis() {
        self.arrLocalData = self.arrSyncContacts.filter{ (($0["isBlock"] as AnyObject)) as! NSNumber == 1 }
        self.arrSyncContacts = self.arrLocalData

    }
    
    func doFilterAllContactWhichIsNotBlock() {
        self.arrLocalData = self.arrSyncContacts.filter{ (($0["isBlock"] as AnyObject)) as! NSNumber != 1 }
        self.arrSyncContacts = self.arrLocalData

    }
    
    func goTOBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let predicate = NSPredicate(format: "SELF contains %@", searchBar.text!)
        self.arrSyncContacts = self.arrLocalData.filter { predicate.evaluate(with: $0["userName"]) }
        
        if (searchBar.text?.isEmpty)! {
            self.arrSyncContacts = self.arrLocalData
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
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func sendingMessageDone() {
        self.delegate?.sendingMessageDone!()
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
        
        var data = dataContacts
        
        let blockUserId = dataContacts["userId"]!
        let dictData = ["version" : "1.0" , "os" : "1" , "language" : CommanUtility.getCurrentLanguage(),"userId":CommonUtil.getUserId(),"blockUserId":blockUserId] as [String : Any]
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "blockUser", parameter: dictData, success: { (responseObject) in
            
            let index = self.arrMainData.index(where: {$0["userNumber"] as! String == data["userNumber"] as! String})
            
            if (sender.isSelected){
              data["isBlock"] = 0 as AnyObject
            }else{
              data["isBlock"] = 1 as AnyObject
            }
            self.arrMainData[index!] = data
            CommanUtility.saveObjectInPreference(arrData: self.arrMainData, key: "contact")
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
