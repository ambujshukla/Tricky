//
//  SignUpViewController.swift
//  Tricky
//
//  Created by gopalsara on 19/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import ObjectMapper

class SignUpViewController: UIViewController {
    
    //  @IBOutlet weak var lblTitle : UILabel!
    //  @IBOutlet weak var lblMobile : UILabel!
    //  @IBOutlet weak var lblPassword : UILabel!
    //  @IBOutlet weak var lblUrl : UILabel!
    //  @IBOutlet weak var lblPhoto : UILabel!
    //  @IBOutlet weak var lblNotifications : UILabel!
    @IBOutlet weak var lblTnC : UILabel!
    //  @IBOutlet weak var lblNoFileChoosen : UILabel!
    
    //  @IBOutlet weak var txtSelectCode : UITextField!
    @IBOutlet weak var txtMobile : UITextField!
    @IBOutlet weak var txtLink : UITextField!
    //  @IBOutlet weak var txtUrl : UITextField!
    @IBOutlet weak var txtDomain : UITextField!
    
    //  @IBOutlet weak var btnNotifications : UIButton!
    @IBOutlet weak var btnTnC : UIButton!
    @IBOutlet weak var btnRegister : UIButton!
    //  @IBOutlet weak var btnChooseFile : UIButton!
    
    @IBOutlet weak var imgBG : UIImageView!
    @IBOutlet weak var viewTop : UIView!
    @IBOutlet var btnCountryCode : UIButton!

    let arrCountryCode = ["Afghanistan(+93)","Aland Islands(+358)","Albania(+355)"]
    
    //  let arrCountryCode = ["+91","+01","+02"]
    //  var imagePicker = UIImagePickerController()
    
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
        self.btnCountryCode.setTitle("+91", for: .normal)
        self.viewTop.layer.borderColor = UIColor.white.cgColor
        self.viewTop.layer.cornerRadius = 5.0
        self.viewTop.layer.borderWidth = 1.0
        
        CommanUtility.decorateNavigationbarWithBackButtonAndTitle(target: self, leftselect: #selector(doClickBack), strTitle: "txt_SignUp".localized(), strBackImag: BACK_BUTTON, strFontName: "Arial", size: 20, color: UIColor.white)
        
        self.imgBG.backgroundColor = color(red: 89, green: 165, blue: 171)
        
        self.btnTnC.setImage(UIImage(named : CHECKBOX_UNSELECTED) , for: .normal)
        self.btnTnC.setImage(UIImage(named : CHECKBOX_SELECTED) , for: .selected)
        self.btnTnC.isSelected = false
        
        //  self.btnNotifications.setImage(UIImage(named : CHECKBOX_UNSELECTED) , for: .normal)
        //        self.btnNotifications.setImage(UIImage(named : CHECKBOX_SELECTED) , for: .selected)
        //        self.btnNotifications.isSelected = false
        
        self.lblTnC.text = "txt_TnC".localized()
        // self.lblNotifications.text = "txt_notifications".localized()
        self.btnRegister.setTitle("txt_SignUp".localized(), for: .normal)
        self.btnRegister.setTitleColor(UIColor.white, for: .normal)
        self.btnRegister.layer.borderColor = UIColor.white.cgColor
        self.btnRegister.layer.borderWidth = 1.0
        self.btnRegister.backgroundColor = UIColor.clear
        
        self.txtMobile.attributedPlaceholder = NSAttributedString(string: "txt_mobile".localized(),
                                                                  attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        self.txtLink.attributedPlaceholder = NSAttributedString(string: "txt_link".localized(),
                                                                attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        self.txtMobile.textColor = UIColor.white
        self.txtLink.textColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 244, green: 166, blue: 202)
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
        let dictData = ["version" : "1.0" , "os" : "ios" , "language" : "english" , "mobileNo": self.txtMobile.text!  , "url":self.txtLink.text! , "deviceToken" : "324343434343434343" , "countryCode" : "+91"] as [String : Any]
        
        WebAPIManager.sharedWebAPIMAnager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "register", parameter: dictData , success: { (obj) in
            let regData = Mapper<RegistrationModel>().map(JSON: obj)
            
            if (regData?.status == "1")
            {
                UserManager.sharedUserManager.doSetLoginData(userData: (regData?.responseData?[0])!)
                self.goTOVerifyScreen()
            }
            else
            {
                CommonUtil.showTotstOnWindow(strMessgae: (regData?.responseMessage)!)
            }
            
            print("this is object \(obj)")
        }) { (error) in
            CommonUtil.showTotstOnWindow(strMessgae: (error?.localizedDescription)!)
            
        }
    }
    
    func goTOVerifyScreen() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPController") as! VerifyOTPController
        vc.isFromSignUp = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func doClickNotifications()
    {
        // self.btnNotifications.isSelected = !self.btnNotifications.isSelected
    }
    
    @IBAction func doClickSelectCode(sender : UIButton)
    {
        ActionSheetMultipleStringPicker.show(withTitle: "Select Code", rows: [
            self.arrCountryCode
            ], initialSelection: [0], doneBlock: {
                picker, indexes, values in
                
                if let arrValue = values as? [String] {
                    let string = arrValue[0]
                    if let range = string.range(of: "(") {
                        let index = string.index(string.endIndex, offsetBy: -1)
                        let firstPart = string[range.upperBound..<index]
                        self.btnCountryCode.setTitle(firstPart, for: .normal)
                        print(firstPart) // print Hello
                    }
                }
                return
        }, cancel: { ActionMultipleStringCancelBlock in return }, origin: sender)
    }
    
    @IBAction func doClickRegister()
    {
        self.doCallWebAPIForRegistration()
    }
    
    //    @IBAction func doClickChangeProfilePic()
    //    {
    //        //Create the AlertController and add Its action like button in Actionsheet
    //        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "txt_profile_photo".localized(), message: "txt_options".localized(), preferredStyle: .actionSheet)
    //
    //        let cancelActionButton = UIAlertAction(title: "txt_cancel".localized(), style: .cancel) { _ in
    //            print("Cancel")
    //        }
    //        actionSheetControllerIOS8.addAction(cancelActionButton)
    //
    //
    //        actionSheetControllerIOS8.addAction(deleteActionButton)
    //        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
    //    }
    //
    //    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    //        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
    //            self.imgBG.image = image
    //        }
    //        picker.dismiss(animated: true, completion: nil);
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
