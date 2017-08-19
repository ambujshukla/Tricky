//
//  ProfileViewController.swift
//  Tricky
//
//  Created by Shweta Shukla on 19/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
import Localize_Swift

class ProfileViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var imgProfilePic : UIImageView!
    @IBOutlet weak var btnChangeic : UIButton!
    @IBOutlet weak var btnSave : UIButton!
    var dictData:[String:String] = [:]

    var arrTitle = ["txt_name".localized(), "txt_mobile".localized(),"txt_password".localized()]
    var arrPlaceholder = ["txt_name".localized(), "txt_mobile".localized(),"txt_password".localized()]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.decorateUI()
        self.configureInitialParameters()
    }
    
    func decorateUI()
    {
      self.btnSave.setTitle("txt_save".localized(), for: .normal)
      self.btnSave.backgroundColor = UIColor.clear
   //   self.btnSave.layer.borderColor = UIColor.white as? CGColor
      self.btnSave.layer.borderWidth = 1.0
      self.view.backgroundColor = UIColor.red
      self.imgProfilePic.backgroundColor = UIColor.purple
        self.tblView.backgroundColor = UIColor.clear
    }
    
    func configureInitialParameters() {
        self.tblView.delegate = self
        self.tblView.dataSource = self
        self.tblView.tableFooterView = UIView()
        self.tblView.isScrollEnabled = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView() // The width will be the same as the cell, and the height should be set in tableView:heightForRowAtIndexPath:

        view.backgroundColor = UIColor.clear
        return view
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProfileTableViewCell
        cell.lblTitle.text = self.arrTitle[indexPath.section]
        cell.txtField.placeholder = self.arrPlaceholder[indexPath.section]
        cell.txtField.delegate = self
        cell.txtField.tag = indexPath.section
        cell.backgroundColor = UIColor.clear
        cell.lblTitle.textColor = UIColor.white
        cell.txtField.textColor = UIColor.white
        if indexPath.section == 1 {
            cell.txtField.isUserInteractionEnabled = false
        }else if indexPath.section == 2
        {
            cell.txtField.isSecureTextEntry = true
        }
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        let key = String(format: "%d", textField.tag)
        self.dictData[key] = textField.text
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func doClickChangeProfilePic()
    {
        
    }
    
    @IBAction func doClickSave()
    {
       self.view.endEditing(true)
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "BlockUserListViewIdentifier") as! BlockUserListViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
