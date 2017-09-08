//
//  ContactViewController.swift
//  OTPSection
//
//  Created by gopalsara on 19/08/17.
//  Copyright © 2017 gopalsara. All rights reserved.
//

import UIKit

class ContactViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    
    var contactsArray = NSMutableArray()
    var arrSyncContacts = [[String : AnyObject]]()
    @IBOutlet weak var imgBg : UIImageView!
    
    @IBOutlet weak var tblContact : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decorateUI()
        self.doGetContactFromConactBook()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 148, green: 108, blue: 139)
    }
    
    func decorateUI()
    {
        self.imgBg.image = UIImage(named : ALL_CONTACTS_BG)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doGetContactFromConactBook(){
        
        self.tblContact.tableFooterView = UIView()
        //  CommonUtil.showLoader()
        DispatchQueue.global(qos: .background).async {
            
            ContactPickerUtils.sharedContactPicker.getContctFromContactBook(target: self) { (contacts, error) in
                //  self.filteredContacts = contacts
                DispatchQueue.main.async {
                    //   CommonUtil.hideLoader()
                    //   self.tblContact.isHidden = true
                    self.contactsArray = contacts
                    self.doCallSyncContactsWS()
                    //                    self.tblContact.reloadData()
                    
                }
            }
        }
        /*key : value
         
         userId : 47
         
         requestData : {
         "data": [
         {
         "userName": "vishal",
         "userNumber": "9589077130"
         },
         {
         "userName": "vishal1",
         "userNumber": "9589077131"
         },
         {
         "userName": "abc",
         "userNumber": "12365489"
         }
         ],
         }
         */   // func doGetContactFromConactBook(){
        
        
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: "All Contacts", strBackButtonImage: BACK_BUTTON, selector: #selector(self.goTOBack), color: color(red: 142, green: 110, blue: 137))
        
        //142 , 110 ,137
    }
    
    func doCallSyncContactsWS()
    {
        var arrayTempContacts = [[String : AnyObject]]()
        for model in self.contactsArray
        {
            var dictContactsData = [String : AnyObject]()
            let contact: ContactModel
            contact =  model as! ContactModel
            
            for phoneNo in contact.phoneNumbers
            {
                dictContactsData["userNumber"] = phoneNo.phoneNumber as AnyObject
                dictContactsData["userName"] = contact.fullName! as AnyObject
                print(phoneNo)
            }
            arrayTempContacts .append(dictContactsData)
                print(contact)
        }
        var dictDataTemp = [String : AnyObject]()
        dictDataTemp["data"] = arrayTempContacts as AnyObject

        print(arrayTempContacts)
        let dictData = ["version" : "1.0" , "os" : "ios" , "language" : "english","userId":"47", "requestData" : dictDataTemp] as [String : Any]
        WebAPIManager.sharedWebAPIMAnager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "SyncContact", parameter: dictData, success: { (obj) in
                if let dictContactsData = obj["responseData"] as? [[String : AnyObject]]
                {
                    print(dictContactsData)
                   for dataTemp in dictContactsData
                   {
                    self.arrSyncContacts.append(dataTemp)
                    print(dataTemp)
                   }
                    self.tblContact.reloadData()
                }
            print(obj)
        }) { (error) in
            
        }
        
    }
    
    func goTOBack()
    {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    // MARK: - Table View DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.arrSyncContacts.count
    }
    
    // MARK: - Table View Delegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
//        let contact: ContactModel
//        contact =  self.contactsArray[indexPath.row] as! ContactModel
        let dataContacts = self.arrSyncContacts[indexPath.row] 
        let label = cell.contentView.viewWithTag(10) as! UILabel!
        label?.text = dataContacts["userName"] as? String
        
        let labelPhNo = cell.contentView.viewWithTag(11) as! UILabel!
        labelPhNo?.textColor = UIColor.white
        labelPhNo?.text = dataContacts["userNumber"] as? String
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.00
    }
}
