//
//  SignUpViewController.swift
//  Tricky
//
//  Created by gopalsara on 19/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet  var txtMobile : UITextField!
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.decorateUI()
        // Do any additional setup after loading the view.
    }
    func decorateUI()
    {

        self.btnTnC.setTitle("txt_TnC".localized(), for: .normal)
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
        
        self.btnTnC.setImage(UIImage(named : CHECKBOX_UNSELECTED) , for: .normal)
        self.btnTnC.setImage(UIImage(named : CHECKBOX_SELECTED) , for: .selected)
        self.btnTnC.isSelected = false
        
        CommanUtility.decorateNavigationbarWithBackButtonAndTitle(target: self, leftselect: #selector(doClickBack), strTitle: "txt_SignUp".localized(), strBackImag: BACK_BUTTON, strFontName: "Arial", size: 20, color: UIColor.white)
        
        self.txtMobile.textColor = UIColor.white
        self.txtMobile.textColor = UIColor.white
        self.txtCnfPassword.textColor = UIColor.white
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 151, green: 92, blue: 126)
    }

    func doClickBack()
    {
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doClickTnC()
    {
        self.btnTnC.isSelected = !self.btnTnC.isSelected
        
        self.doCallWebAPIForRegistration()
    }
    
    
    func doCallWebAPIForRegistration() {
        
        let dictData = ["version" : "" , "os" : "ios" , "language" : "english" , "mobile":"9713279803" , "password" : "12345678" , "url":"user1@trickychat.com" , "deviceToken" : "324343434343434343"]
        
     WebAPIManager.sharedWebAPIMAnager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "register", parameter: dictData , success: { (obj) in
    print("this is object \(obj)")
       }) { (error) in
    
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
