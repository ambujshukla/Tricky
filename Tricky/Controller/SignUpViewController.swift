//
//  SignUpViewController.swift
//  Tricky
//
//  Created by gopalsara on 19/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0

class SignUpViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate {

    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblMobile : UILabel!
    @IBOutlet weak var lblPassword : UILabel!
    @IBOutlet weak var lblUrl : UILabel!
    @IBOutlet weak var lblPhoto : UILabel!
    @IBOutlet weak var lblNotifications : UILabel!
    @IBOutlet weak var lblTnC : UILabel!
    @IBOutlet weak var lblNoFileChoosen : UILabel!
    
    @IBOutlet weak var txtSelectCode : UITextField!
    @IBOutlet weak var txtMobile : UITextField!
    @IBOutlet weak var txtPassword : UITextField!
    @IBOutlet weak var txtUrl : UITextField!
    @IBOutlet weak var txtDomain : UITextField!
    
    @IBOutlet weak var btnNotifications : UIButton!
    @IBOutlet weak var btnTnC : UIButton!
    @IBOutlet weak var btnRegister : UIButton!
    @IBOutlet weak var btnChooseFile : UIButton!
    
    @IBOutlet weak var imgBG : UIImageView!

    let arrCountryCode = ["+91","+01","+02"]
    var imagePicker = UIImagePickerController()

  /*  @IBOutlet  var txtMobile : UITextField!
    @IBOutlet  var txtPassword : UITextField!
    @IBOutlet  var txtCnfPassword : UITextField!
    
    @IBOutlet  var btnTnC : UIButton!
    @IBOutlet  var btnSignUp : UIButton!
    
    @IBOutlet  var imgBG : UIImageView!
    
    @IBOutlet  var imgMobile : UIImageView!
    @IBOutlet  var imgPassword : UIImageView!
    @IBOutlet  var imgCnfPassword : UIImageView!
    
    @IBOutlet  var imgSeparator1 : UIImageView!
    @IBOutlet  var imgSeparator2 : UIImageView!
    @IBOutlet  var imgSeparator3 : UIImageView!
 */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decorateUI()
        // Do any additional setup after loading the view.
    }
    func decorateUI()
    {
        CommanUtility.decorateNavigationbarWithBackButtonAndTitle(target: self, leftselect: #selector(doClickBack), strTitle: "txt_SignUp".localized(), strBackImag: BACK_BUTTON, strFontName: "Arial", size: 20, color: UIColor.white)

        self.imgBG.backgroundColor = color(red: 89, green: 165, blue: 171)
        
        self.btnTnC.setImage(UIImage(named : CHECKBOX_UNSELECTED) , for: .normal)
        self.btnTnC.setImage(UIImage(named : CHECKBOX_SELECTED) , for: .selected)
        self.btnTnC.isSelected = false

        self.btnNotifications.setImage(UIImage(named : CHECKBOX_UNSELECTED) , for: .normal)
        self.btnNotifications.setImage(UIImage(named : CHECKBOX_SELECTED) , for: .selected)
        self.btnNotifications.isSelected = false
        
        self.lblTnC.text = "txt_TnC".localized()
        self.lblNotifications.text = "txt_notifications".localized()
        self.btnRegister.setTitle("txt_register".localized(), for: .normal)
        self.btnRegister.setTitleColor(UIColor.white, for: .normal)
        self.btnRegister.layer.borderColor = color(red: 41, green: 184, blue: 169).cgColor
        self.btnRegister.layer.borderWidth = 1.0
        self.lblNoFileChoosen.text = "txt_no_file_choosen".localized()
        
        self.btnChooseFile.setTitle("txt_choose_file".localized(), for: .normal)
        self.btnChooseFile.backgroundColor = color(red: 236, green: 236, blue: 236)
        self.btnChooseFile.setTitleColor(UIColor.black, for: .normal)
        self.lblTitle.text = "txt_register".localized()
       /* self.btnTnC.setTitle("txt_TnC".localized(), for: .normal)
        self.btnTnC.setTitleColor(UIColor.white, for: .normal)
        
        self.imgBG.image = UIImage(named : SIGNUP_BG)
        
        self.imgMobile.image = UIImage(named : MOBILE_ICON)
        self.imgPassword.image = UIImage(named : PASSWORD_ICON)
        self.imgCnfPassword.image = UIImage(named : PASSWORD_ICON)
        
        self.btnSignUp.setTitle("txt_SignUp".localized(), for: .normal)
        self.btnSignUp.backgroundColor = UIColor.white
        self.btnSignUp.setTitleColor(UIColor.darkGray, for: .normal)
        self.btnTnC.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0)
        
        self.txtMobile.attributedPlaceholder = NSAttributedString(string: "txt_mobile".localized(),
                                                                  attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.txtPassword.attributedPlaceholder = NSAttributedString(string: "txt_password".localized(),
                                                                    attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        self.txtCnfPassword.attributedPlaceholder = NSAttributedString(string: "txt_cnf_mobile".localized(),
                                                                       attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.imgSeparator1.backgroundColor = UIColor.white
        self.imgSeparator2.backgroundColor = UIColor.white
        self.imgSeparator3.backgroundColor = UIColor.white
        
         
        CommanUtility.decorateNavigationbarWithBackButtonAndTitle(target: self, leftselect: #selector(doClickBack), strTitle: "txt_SignUp".localized(), strBackImag: BACK_BUTTON, strFontName: "Arial", size: 20, color: UIColor.white)
        
        self.txtMobile.textColor = UIColor.white
        self.txtMobile.textColor = UIColor.white
        self.txtCnfPassword.textColor = UIColor.white
        */
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 75, green: 155, blue: 166)
    }

    func doClickBack()
    {
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doClickTnC()
    {
        self.btnTnC.isSelected = !self.btnTnC.isSelected
    }
    
    func doCallWebAPIForRegistration()
    {
    let dictData = ["version" : "1.0" , "os" : "ios" , "language" : "english" , "mobile": self.txtMobile.text! , "password" : self.txtPassword.text! , "url":self.txtUrl , "deviceToken" : "324343434343434343"] as [String : Any]
        
     WebAPIManager.sharedWebAPIMAnager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "register", parameter: dictData , success: { (obj) in
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPController") as! VerifyOTPController
        self.navigationController?.pushViewController(vc, animated: true)
    print("this is object \(obj)")
       }) { (error) in
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func doClickNotifications()
    {
        self.btnNotifications.isSelected = !self.btnNotifications.isSelected
    }
    
    @IBAction func doClickSelectCode(sender : UIButton)
    {
        ActionSheetMultipleStringPicker.show(withTitle: "Select Code", rows: [
            self.arrCountryCode
            ], initialSelection: [0], doneBlock: {
                picker, indexes, values in
                
                if let arrValue = values as? [String] {
                    self.txtSelectCode.text = arrValue[0]
                }
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func doClickRegister()
    {
        self.doCallWebAPIForRegistration()
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
            self.imgBG.image = image
        }
        picker.dismiss(animated: true, completion: nil);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
