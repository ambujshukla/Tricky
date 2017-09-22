//
//  ProfileViewController.swift
//  Tricky
//
//  Created by gopalsara on 19/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
import Localize_Swift
import SDWebImage
import ActionSheetPicker_3_0

class ProfileViewController: UIViewController, UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate  {
    
    @IBOutlet weak var tblView : UITableView!
    @IBOutlet weak var imgProfilePic : UIImageView!
    @IBOutlet weak var btnChangeic : UIButton!
    // @IBOutlet weak var btnSave : UIButton!
    @IBOutlet weak var imgBG : UIImageView!
    
    @IBOutlet weak var lblEmail : UILabel!
    @IBOutlet weak var btnCopy : UIButton!
    @IBOutlet weak var btnShare : UIButton!
    let arrCountryCode = ["+91","+01","+02"]
    
    var imagePicker = UIImagePickerController()
    
    var dictData:[String:String] = [:]
    
    var arrTitle = ["txt_name".localized(), "txt_mobile".localized(),"txt_password".localized()]
    var arrPlaceholder = ["txt_name".localized(), "txt_mobile".localized(),"txt_password".localized()]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.decorateUI()
        self.configureInitialParameters()
        self.doCallGetProfile()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 236, green: 92, blue: 83)
    }
    
    func decorateUI()
    {
        self.imgProfilePic.layer.cornerRadius = self.imgProfilePic.frame.size.width / 2
        self.imgProfilePic.layer.masksToBounds = true
        
        CommanUtility.decorateNavigationbarWithBackButtonAndTitle(target: self, leftselect: #selector(doClickBack), strTitle: "txt_profile".localized(), strBackImag: BACK_BUTTON, strFontName: "Arial", size: 20, color: UIColor.white)
        
        //        self.btnSave.setTitle("txt_save".localized(), for: .normal)
        //        self.btnSave.backgroundColor = UIColor.clear
        //        self.btnSave.layer.borderWidth = 1.0
        //        self.tblView.backgroundColor = UIColor.clear
        //        self.btnSave.layer.borderColor = UIColor.white.cgColor
        
        self.imgBG.image = UIImage(named : PROFILE_BG)
        self.btnChangeic.setImage(UIImage(named : EDIT_ICON), for: .normal)
        
        //179 39 40
        self.imgProfilePic.layer.borderColor = color(red: 175, green: 35, blue: 30).cgColor
        self.imgProfilePic.layer.borderWidth = 5.0
    }
    func doCallGetProfile()
    {
        let dictData = ["version" : "1.0" , "os" : "ios" , "language" : "english","userId":"61"]
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "getProfile", parameter: dictData , success: { (obj) in
            
            if (obj["status"] as! String == "1")
            {
                if let dictResponseData = obj["responseData"] as? [[String : AnyObject]]
                {
                    print(dictResponseData)
                    self.lblEmail.text = dictResponseData[0]["url"] as? String
                    
                    self.dictData["0"] = dictResponseData[0]["name"] as? String
                    self.dictData["1"] = dictResponseData[0]["mobileNo"] as? String
                    self.dictData["2"] = dictResponseData[0][""] as? String
                    self.imgProfilePic.sd_setImage(with: URL(string : (dictResponseData[0]["profilePic"] as? String)!) )
                }
                print(obj["responseData"])
                self.tblView.reloadData()
                
            }
            print("")
            //            let regData = Mapper<RegistrationModel>().map(JSON: obj)
            //
            //            if (regData?.status == "1")
            //            {
            //                UserManager.sharedUserManager.doSetLoginData(userData: (regData?.responseData?[0])!)
            //                self.goTOVerifyScreen()
            //            }
            //            else
            //            {
            //                CommonUtil.showTotstOnWindow(strMessgae: (regData?.responseMessage)!)
            //            }
            
            print("this is object \(obj)")
        }) { (error) in
            CommonUtil.showTotstOnWindow(strMessgae: (error?.localizedDescription)!)
            
        }
    }
    
    func doClickBack()
    {
        self.navigationController?.popViewController(animated: true)
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
        return 20;
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView() // The width will be the same as the cell, and the height should be set in tableView:heightForRowAtIndexPath:
        
        view.backgroundColor = UIColor.clear
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tblViewCell : UITableViewCell!
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProfileTableViewCell
            cell.lblTitle.text = self.arrTitle[indexPath.section]
            cell.lblTitle.font = UIFont(name: cell.lblTitle.font.fontName, size: 12)
            
            cell.txtField.attributedPlaceholder = NSAttributedString(string: self.arrPlaceholder[indexPath.section].localized(),
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.white])
            cell.txtField.delegate = self
            cell.txtField.tag = indexPath.section
            cell.backgroundColor = UIColor.clear
            cell.lblTitle.textColor = UIColor.white
            cell.txtField.textColor = UIColor.white
            
            let key = String(format: "%d", indexPath.section)
            cell.txtField.text = self.dictData[key]
            
            if indexPath.section == 1 {
                cell.txtField.isUserInteractionEnabled = false
            }else if indexPath.section == 2
            {
                cell.txtField.isSecureTextEntry = true
            }
            tblViewCell = cell
        }else if(indexPath.section == 1)
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProfileTableViewCell
            cell.lblTitle.text = self.arrTitle[indexPath.section]
            cell.lblTitle.font = UIFont(name: cell.lblTitle.font.fontName, size: 12)
            
            cell.txtField.attributedPlaceholder = NSAttributedString(string: self.arrPlaceholder[indexPath.section].localized(),
                                                                     attributes: [NSForegroundColorAttributeName: UIColor.white])
            cell.txtField.delegate = self
            cell.txtField.tag = indexPath.section
            cell.backgroundColor = UIColor.clear
            cell.lblTitle.textColor = UIColor.white
            cell.txtField.textColor = UIColor.white
            
            let key = String(format: "%d", indexPath.section)
            cell.txtField.text = self.dictData[key]
            cell.txtField.isUserInteractionEnabled = false
            tblViewCell = cell
        }else
        {
            let footerView: ProfileTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cellFooter") as? ProfileTableViewCell
            footerView?.btnSave .addTarget(self, action: #selector(doClickSave), for: .touchUpInside)
            tblViewCell = footerView
        }
        
        tblViewCell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        return tblViewCell
    }
    //    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
    //        if section == 1 {
    //            return 40.0
    //        }
    //        return 0.0
    //    }
    
    //    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView?
    //    {
    //        let footerView: ProfileTableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cellFooter") as? ProfileTableViewCell
    //        footerView?.btnSave .addTarget(self, action: #selector(doClickSave), for: .touchUpOutside)
    //        return footerView;
    //    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        let key = String(format: "%d", textField.tag)
        self.dictData[key] = textField.text
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    @IBAction func doClickChangeProfilePic()
    {
        //Create the AlertController and add Its action like button in Actionsheet
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "txt_profile_photo".localized(), message: "txt_options".localized(), preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "txt_cancel".localized(), style: .cancel) { _ in
            print("Cancel")
        }
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "txt_gallery".localized(), style: .default)
        { _ in
            if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                print("Button capture")
                
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = .savedPhotosAlbum;
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        actionSheetControllerIOS8.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "txt_photo".localized(), style: .default)
        { _ in
            print("Delete")
        }
        actionSheetControllerIOS8.addAction(deleteActionButton)
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imgProfilePic.image = image
        }
        picker.dismiss(animated: true, completion: nil);
    }
    
    @IBAction func doClickSave()
    {
        self.view.endEditing(true)
        //UpdateProfile
        let dictData = ["version" : "1.0" , "os" : "ios" , "language" : "english","userId":"61", "mobileNo" : self.dictData["1"]!,"fullName" : self.dictData["0"]!] as [String : Any]
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "UpdateProfile", parameter: dictData , success: { (obj) in
            
            if (obj["status"] as! String == "1")
            {
                if let dictResponseData = obj["responseData"] as? [[String : AnyObject]]
                {
                    print(dictResponseData)
                    self.dictData["0"] = dictResponseData[0]["name"] as? String
                    self.dictData["1"] = dictResponseData[0]["mobileNo"] as? String
                    self.dictData["2"] = dictResponseData[0][""] as? String
                    self.imgProfilePic.sd_setImage(with: URL(string : (dictResponseData[0]["profilePic"] as? String)!) )
                }
                print(obj["responseData"])
                self.tblView.reloadData()
                
            }
            print("this is object \(obj)")
        }) { (error) in
            CommonUtil.showTotstOnWindow(strMessgae: (error?.localizedDescription)!)
            
        }
    }
    
    //    @IBAction func doClickSelectCode(sender : UIButton)
    //    {
    //        ActionSheetMultipleStringPicker.show(withTitle: "Select Code", rows: [
    //            self.arrCountryCode
    //            ], initialSelection: [0], doneBlock: {
    //                picker, indexes, values in
    //
    //                if let arrValue = values as? [String] {
    ////                    self.txtSelectCode.text = arrValue[0]
    //                    self.dictData["countryCode"] = arrValue[0]
    //                }
    //                return
    //        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
    //    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
