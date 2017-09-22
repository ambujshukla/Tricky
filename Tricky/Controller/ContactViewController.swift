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
    }
    
    func decorateUI()
    {
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
        }else if(self.contactShowFrom == 2)
        {
            strTitle = "txt_contacts".localized()
            self.imgBg.image = UIImage(named : ALL_CONTACTS_BG)
        }else if(self.contactShowFrom == 3)
        {
            strTitle = "txt_favorite".localized()
        }
        
        CommanUtility.decorateNavigationbarWithBackButton(target: self, strTitle: strTitle, strBackButtonImage: BACK_BUTTON, selector: #selector(self.goTOBack), color: color(red: 142, green: 110, blue: 137))
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
                let string = phoneNo.phoneNumber as AnyObject // string starts as "hello[]
                let badchar = CharacterSet(charactersIn: "\"-() ")
                let cleanedstring = string.components(separatedBy: badchar).joined()
                dictContactsData["userNumber"] =  cleanedstring.stringByRemovingWhitespaces as AnyObject

              //  dictContactsData["userNumber"] = cleanedstring as AnyObject
                dictContactsData["userName"] = contact.fullName! as AnyObject
                print(phoneNo)
                print(dictContactsData)
            }
            arrayTempContacts .append(dictContactsData)
            print(contact)
        }
        var dictDataTemp = [String : AnyObject]()
        dictDataTemp["data"] = arrayTempContacts as AnyObject
        
        do {
          //  let jsonData = try JSONSerialization.data(withJSONObject: arrayTempContacts, options: .prettyPrinted)
         //   let theJSONText = String(data: jsonData,
                                    // encoding: .utf8)
            let dictData = ["version" : "1.0" , "os" : "1" , "language" : "english","userId":UserManager.sharedUserManager.userId!, "requestData" : dictDataTemp] as [String : Any]
            print(dictData)
            WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "SyncContact", parameter: dictData, success: { (obj) in
                if let dictContactsData = obj["responseData"] as? [[String : AnyObject]]
                {
                    print(dictContactsData)
                    for dataTemp in dictContactsData
                    {
                        if (self.contactShowFrom == 1)
                        {
                            if (dataTemp["isBlock"] as! Int == 1)
                            {
                                self.arrSyncContacts.append(dataTemp)
                            }
                        }else if (self.contactShowFrom == 2)
                        {
                            self.arrSyncContacts.append(dataTemp)
                        }else
                        {
                            self.arrSyncContacts.append(dataTemp)
                        }
                        print(dataTemp)
                    }
                    self.tblContact.reloadData()
                }
                print(obj)
            }) { (error) in
                print(error!)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func goTOBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table View DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.arrSyncContacts.count
        //        if self.isFromMenu
        //        {
        //        }
        //        let  contact =  self.contactsArray[section] as! ContactModel
        //        return contact.phoneNumbers.count
    }
    
    // MARK: - Table View Delegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        
        let dataContacts = self.arrSyncContacts[indexPath.row]
        let label = cell.contentView.viewWithTag(10) as! UILabel!
        label?.text = dataContacts["userName"] as? String
        
        let labelPhNo = cell.contentView.viewWithTag(11) as! UILabel!
        labelPhNo?.textColor = UIColor.white
        labelPhNo?.text = dataContacts["userNumber"] as? String
        let imgStatus = cell.contentView.viewWithTag(20) as! UIImageView!
        if self.isFromMenu {
            let isBlock = dataContacts["isBlock"] as! Bool
            
            if (isBlock)
            {
                imgStatus?.image = UIImage(named: "unblockicon")
            }else
            {
                imgStatus?.image = UIImage(named: "blockselecticon")
            }
            imgStatus?.isUserInteractionEnabled = true
            imgStatus?.tag = indexPath.row
            let tap = UITapGestureRecognizer(target: self, action: #selector(doBlockOrUnblockUser(tapG:)))
            imgStatus?.addGestureRecognizer(tap)

        }
        //        }
        //    else
        //        {
        //            let  contact =  self.contactsArray[indexPath.section] as! ContactModel
        //            let label = cell.contentView.viewWithTag(10) as! UILabel!
        //            label?.text = contact.fullName
        //            let labelPhNo = cell.contentView.viewWithTag(11) as! UILabel!
        //            let phoneNoData = contact.phoneNumbers[indexPath.row]
        //            labelPhNo?.text = phoneNoData.phoneNumber
        //            labelPhNo?.textColor = UIColor.white
        //            let imgStatus = cell.contentView.viewWithTag(20) as! UIImageView!
        //            if (self.contactShowFrom == 1)
        //            {
        //                imgStatus?.image = UIImage(named : "blockselecticon")
        //            }
        //            // self.doCheckIfBlockOrUnblock(strPhoneNo: phoneNoData.phoneNumber,imgView: imgStatus!)
        //            print("")
        //        }
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
                    imgView.image = UIImage(named: "unblockicon")
                }else
                {
                    imgView.image = UIImage(named: "blockselecticon")

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
    
    func doBlockOrUnblockUser(tapG : UITapGestureRecognizer? = nil)
    {
        let tappedImage = tapG?.view as! UIImageView
        let dataContacts = self.arrSyncContacts[tappedImage.tag]

        let dictData = ["version" : "1.0" , "os" : "1" , "language" : "english","userId":UserManager.sharedUserManager.userId!,"blockUserId":""] as [String : Any]
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "blockUnblockUser", parameter: dictData, success: { (responseObject) in
            
        }) { (error) in
            
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.00
    }
}

extension String {
    
    var stringByRemovingWhitespaces: String {
        
        let components = self.components(separatedBy: .whitespaces)
        return components.joined(separator: "")
    }
}
