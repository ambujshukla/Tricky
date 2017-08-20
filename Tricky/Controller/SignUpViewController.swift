//
//  SignUpViewController.swift
//  Tricky
//
//  Created by Shweta Shukla on 19/08/17.
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
        CommanUtility.decorateNavigationbar(target: self, strTitle: "txt_SignUp".localized())

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
        
        CommanUtility.decorateNavigationbarWithBackButtonAndTitle(target: self, leftselect: #selector(doClickBack), strTitle: "", strBackImag: BACK_BUTTON, strFontName: "Arial", size: 20, color: UIColor.white)
    }
    
    func doClickBack()
    {
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doClickTnC()
    {
        self.btnTnC.isSelected = !self.btnTnC.isSelected
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
