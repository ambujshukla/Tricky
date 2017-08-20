//
//  ForgotPasswordController.swift
//  OTPSection
//
//  Created by gopalsara on 19/08/17.
//  Copyright © 2017 gopalsara. All rights reserved.
//

import UIKit

class ForgotPasswordController: UIViewController {
    
    
    @IBOutlet weak var tfMobile   : UITextField!
    @IBOutlet weak var btnReset  : UIButton!
    @IBOutlet weak var imgBG : UIImageView!
    @IBOutlet  var imgMobile : UIImageView!
    @IBOutlet weak var btnLogin  : UIButton!
    @IBOutlet weak var btnSignup  : UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.decorateUI()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func decorateUI ()
    {
        CommanUtility.decorateNavigationbar(target: self, strTitle: "txt_title_forgot_password".localized())
        
        CommanUtility.decorateNavigationbarWithBackButtonAndTitle(target: self, leftselect: #selector(doClickBack), strTitle: "", strBackImag: BACK_BUTTON, strFontName: "Arial", size: 20, color: UIColor.white)
        
        self.imgBG.image = UIImage(named : FOROGT_PASSWORD_BG)
        
        self.btnReset.setTitle("txt_reset".localized(), for: .normal)
        self.btnReset.backgroundColor = UIColor.white
        self.btnReset.setTitleColor(UIColor.darkGray, for: .normal)
        
        self.imgMobile.image = UIImage(named : MOBILE_ICON)
        
        self.btnLogin.setTitle("txt_login".localized(), for: .normal)
        self.btnLogin.backgroundColor = UIColor.black
        self.btnLogin.alpha = 0.2
        self.btnLogin.setTitleColor(UIColor.white, for: .normal)
        
        self.btnSignup.setTitle("txt_SignUp".localized(), for: .normal)
        self.btnSignup.backgroundColor = UIColor.black
        self.btnSignup.alpha = 0.2
        self.btnSignup.setTitleColor(UIColor.white, for: .normal)
        self.tfMobile.attributedPlaceholder = NSAttributedString(string: "txt_password".localized(),
                                                                    attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.tfMobile.textColor = UIColor.white
        self.tfMobile.isSecureTextEntry = true
    }
    
    func doClickBack()
    {
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doActionOnResetButton()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPController") as! VerifyOTPController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func doClickLogin()
    {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func doClickSignUp()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewIdentifier") as! SignUpViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
