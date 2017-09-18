//
//  LoginViewController.swift
//  Tricky
//
//  Created by gopalsara on 18/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
import Localize_Swift
import ObjectMapper
import ActionSheetPicker_3_0

class LoginViewController: UIViewController
{
    @IBOutlet  var txtMobile : UITextField!
    
    @IBOutlet  var btnLogin : UIButton!
    @IBOutlet  var btnForgotPassword : UIButton!
    @IBOutlet  var btnSignup : UIButton!
    @IBOutlet  var btnDontAccount : UIButton!
    @IBOutlet  var imgSeparator1 : UIImageView!
    @IBOutlet var imgBg : UIImageView!
    @IBOutlet var btnCountryCode : UIButton!
    let arrCountryCode = ["Afghanistan(+93)","Aland Islands(+358)","Albania(+355)"]

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.decorateUI()
    }
    
    func decorateUI()
    {
        //self.txtPassword.text = "123456"
        self.txtMobile.text = "9993880850"
        self.btnCountryCode.setTitle("+91", for: .normal)
        
        self.title = "txt_login".localized()

        self.btnLogin.setTitle("txt_login".localized(), for: .normal)
        self.btnLogin.backgroundColor = UIColor.white
        self.btnLogin.setTitleColor(UIColor.darkGray, for: .normal)
        
        self.imgBg.image = UIImage(named : LOGIN_BG)
        
        self.btnForgotPassword.setTitle("txt_forgot_password".localized(), for: .normal)
        self.btnForgotPassword.titleLabel?.textColor = UIColor.white
        
        self.btnSignup.setTitle("txt_SignUp".localized(), for: .normal)
        self.btnSignup.titleLabel?.textColor = UIColor.white
        
        self.btnDontAccount.setTitle("txt_don't_have_account".localized(), for: .normal)
        self.btnDontAccount.titleLabel?.textColor = UIColor.white
        
        self.txtMobile.attributedPlaceholder = NSAttributedString(string: "txt_mobile".localized(),
                                                                  attributes: [NSForegroundColorAttributeName: UIColor.white])
//        self.txtPassword.attributedPlaceholder = NSAttributedString(string: "txt_password".localized(),
//                                                                    attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        self.imgSeparator1.backgroundColor = UIColor.white
       // self.imgSeparator2.backgroundColor = UIColor.white
        
        self.txtMobile.textColor = UIColor.white
       // self.txtPassword.textColor = UIColor.white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 105, green: 181, blue: 198)
        self.navigationItem.setHidesBackButton(true, animated: false)
    }
    
    @IBAction func doClickLogin(sender: UIButton)
    {
        var (boolValue , message) = CommonUtil.doValidateLogin(self)
        if boolValue == false
        {
            CommonUtil.showTotstOnWindow(strMessgae: message)
        }else{
            self.doCallWebAPIForLogin()
        }
        print(boolValue,message)
    }
    
    func doCallWebAPIForLogin()
    {
        let dictData = ["mobileNo" :(self.txtMobile.text!) /*,"password":self.txtPassword!.text!*/,"deviceToken":"324343434343434343" , "countryCode" : "+91"] as [String : Any]
        print(dictData)
        
        WebAPIManager.sharedWebAPIMAnager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: METHOD_LOGIN, parameter: dictData , success: { (obj) in
            print("this is object \(obj)")
            
            let loginData = Mapper<LoginModel>().map(JSON: obj)
            
            if (loginData?.status == "1")
            {
                UserManager.sharedUserManager.doSetLoginData(userData: (loginData?.responseData?[0])!)
                self.goTOHomeScreen()
            }
            else
            {
                CommonUtil.showTotstOnWindow(strMessgae: (loginData?.responseMessage)!)
            }
            
            
        }) { (error) in
            CommonUtil.showTotstOnWindow(strMessgae: (error?.localizedDescription)!)
        }
    }

    
    func goTOHomeScreen()
    {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPController") as! VerifyOTPController
        vc.isFromSignUp = true
        self.navigationController?.pushViewController(vc, animated: true)
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
//        self.present(controller, animated: true, completion: nil)
    }
    
    @IBAction func doClickForgotPassword(sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordController") as! ForgotPasswordController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func doClickSignUp(sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewIdentifier") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func doClickCountryCode(sender : UIButton)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
