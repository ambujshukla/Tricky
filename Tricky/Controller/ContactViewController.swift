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
    @IBOutlet weak var tblContact : UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       self.doGetContactFromConactBook()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func doGetContactFromConactBook(){
        
      //  CommonUtil.showLoader()
        DispatchQueue.global(qos: .background).async {
            
            ContactPickerUtils.sharedContactPicker.getContctFromContactBook { (contacts, error) in
              //  self.filteredContacts = contacts
                DispatchQueue.main.async {
                 //   CommonUtil.hideLoader()
                 //   self.tblContact.isHidden = true
                    self.contactsArray = contacts
                    self.tblContact.reloadData()
                    
                }
            }
        }
    }

    
    // MARK: - Table View DataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.contactsArray.count
    }
    
    // MARK: - Table View Delegates
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as UITableViewCell
        let contact: ContactModel
        contact =  self.contactsArray[indexPath.row] as! ContactModel
        
        let label = cell.contentView.viewWithTag(10) as! UILabel!
        label?.text = contact.fullName
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.00
    }
    


}
