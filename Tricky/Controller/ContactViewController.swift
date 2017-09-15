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
    var isFromMenu : Bool = false
    
    @IBOutlet weak var tblContact : UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decorateUI()
        self.doGetContactFromConactBook()
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
    }
    
    func doGetContactFromConactBook(){
        
        self.tblContact.tableFooterView = UIView()
        //  CommonUtil.showLoader()
        DispatchQueue.global(qos: .background).async {
            
            ContactPickerUtils.sharedContactPicker.getContctFromContactBook(target: self) { (contacts, error) in
                DispatchQueue.main.async {
                    self.contactsArray = contacts
                    print(self.contactsArray)
                        self.doCallSyncContactsWS()
                }
            }
        }
        
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: "All Contacts", strBackButtonImage: BACK_BUTTON, selector: #selector(self.goTOBack), color: color(red: 142, green: 110, blue: 137))
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
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if (self.isFromMenu)
        {
            return self.contactsArray.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if self.isFromMenu
        {
            let  contact =  self.contactsArray[section] as! ContactModel
            return contact.phoneNumbers.count
        }
        return self.arrSyncContacts.count
    }
    
    // MARK: - Table View Delegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        if (self.isFromMenu)
        {
            let  contact =  self.contactsArray[indexPath.section] as! ContactModel
            let label = cell.contentView.viewWithTag(10) as! UILabel!
            label?.text = contact.fullName
            let labelPhNo = cell.contentView.viewWithTag(11) as! UILabel!
            let phoneNoData = contact.phoneNumbers[indexPath.row]
            labelPhNo?.text = phoneNoData.phoneNumber
            labelPhNo?.textColor = UIColor.white
            let imgStatus = cell.contentView.viewWithTag(20) as! UIImageView!
            self.doCheckIfBlockOrUnblock(strPhoneNo: phoneNoData.phoneNumber,imgView: imgStatus!)
            print("")
        }else
        {
            let dataContacts = self.arrSyncContacts[indexPath.row]
            let label = cell.contentView.viewWithTag(10) as! UILabel!
            label?.text = dataContacts["userName"] as? String
            
            let labelPhNo = cell.contentView.viewWithTag(11) as! UILabel!
            labelPhNo?.textColor = UIColor.white
            labelPhNo?.text = dataContacts["userNumber"] as? String
            let imgStatus = cell.contentView.viewWithTag(20) as! UIImageView!
            
            let isOnApp = dataContacts["isOnApp"] as! Bool
            if (isOnApp)
            {
                let isBlock = dataContacts["isBlock"] as! Bool
                if (isBlock)
                {
                    imgStatus?.image = UIImage(named: "blockselecticon")
                }else
                {
                    imgStatus?.image = UIImage(named: "unblockicon")
                }
            }else
            {
                imgStatus?.backgroundColor = UIColor.green
            }
        }
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
            vc.strUserId = userId
            self.navigationController?.pushViewController(vc, animated: false)
        }
    }
    
    func doCheckIfBlockOrUnblock(strPhoneNo : String, imgView : UIImageView)
    {
        let predicate = NSPredicate(format: "userNumber contains %@", strPhoneNo)
        let searchDataSource = self.arrSyncContacts.filter { predicate.evaluate(with: $0) }
        if searchDataSource.count > 0
        {
            let dataContacts = searchDataSource[0]
            let isOnApp = dataContacts["isOnApp"] as! Bool
            if (isOnApp)
            {
                let isBlock = dataContacts["isBlock"] as! Bool
                if (isBlock)
                {
                    imgView.image = UIImage(named: "blockselecticon")
                }else
                {
                    imgView.image = UIImage(named: "unblockicon")
                }
            }else
            {
                imgView.image = UIImage(named : "refreshicon")
            }
           print("")
        }else
        {
            imgView.image = UIImage(named : "refreshicon")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.00
    }
}
