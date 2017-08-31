//
//  LoginViewController.swift
//  Tricky
//
//  Created by gopalsara on 18/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
import Localize_Swift

class LoginViewController: UIViewController
{
    @IBOutlet  var txtMobile : UITextField!
    @IBOutlet  var txtPassword : UITextField!
    
    @IBOutlet  var btnLogin : UIButton!
    @IBOutlet  var btnForgotPassword : UIButton!
    @IBOutlet  var btnSignup : UIButton!
    @IBOutlet  var btnDontAccount : UIButton!
    
    @IBOutlet  var imgMobile : UIImageView!
    @IBOutlet  var imgPassword : UIImageView!
    
    @IBOutlet  var imgSeparator1 : UIImageView!
    @IBOutlet  var imgSeparator2 : UIImageView!
    
    @IBOutlet var imgBg : UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.decorateUI()
    }
    
    func decorateUI()
    {
        self.title = "txt_login".localized()

        self.btnLogin.setTitle("txt_login".localized(), for: .normal)
        self.btnLogin.backgroundColor = UIColor.white
        self.btnLogin.setTitleColor(UIColor.darkGray, for: .normal)
        
        self.imgBg.image = UIImage(named : LOGIN_BG)
        
        self.imgMobile.image = UIImage(named : MOBILE_ICON)
        self.imgPassword.image = UIImage(named : PASSWORD_ICON)
        
        self.btnForgotPassword.setTitle("txt_forgot_password".localized(), for: .normal)
        self.btnForgotPassword.titleLabel?.textColor = UIColor.white
        
        self.btnSignup.setTitle("txt_SignUp".localized(), for: .normal)
        self.btnSignup.titleLabel?.textColor = UIColor.white
        
        self.btnDontAccount.setTitle("txt_don't_have_account".localized(), for: .normal)
        self.btnDontAccount.titleLabel?.textColor = UIColor.white
        
        self.txtMobile.attributedPlaceholder = NSAttributedString(string: "txt_mobile".localized(),
                                                                  attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.txtPassword.attributedPlaceholder = NSAttributedString(string: "txt_password".localized(),
                                                                    attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        self.imgSeparator1.backgroundColor = UIColor.white
        self.imgSeparator2.backgroundColor = UIColor.white
        
        self.txtMobile.textColor = UIColor.white
        self.txtPassword.textColor = UIColor.white
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 53, green: 100, blue: 120)
    }
    
    @IBAction func doClickLogin(sender: UIButton)
    {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.present(controller, animated: true, completion: nil)
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
        
        
        let dictData = ["mobile" : self.txtMobile.text!,"password":self.txtPassword!.text!,"deviceToken":"324343434343434343"] as [String : Any]
        WebAPIManager.sharedWebAPIMAnager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: METHOD_LOGIN, parameter: dictData , success: { (obj) in
            print("this is object \(obj)")
        }) { (error) in
            print(error)
        }
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
