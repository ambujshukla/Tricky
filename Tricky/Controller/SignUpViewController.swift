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
        self.btnTnC.setTitle("txt_TnC".localized(), for: .normal)
        self.btnTnC.setTitleColor(UIColor.white, for: .normal)
        
        self.imgBG.backgroundColor = UIColor.lightGray
        
        self.imgMobile.backgroundColor = UIColor.red
        self.imgPassword.backgroundColor = UIColor.red
        self.imgCnfPassword.backgroundColor = UIColor.red
        
        self.btnSignUp.setTitle("txt_SignUp".localized(), for: .normal)
        self.btnSignUp.titleLabel?.textColor = UIColor.black
        self.btnSignUp.backgroundColor = UIColor.white

        self.txtMobile.attributedPlaceholder = NSAttributedString(string: "txt_mobile".localized(),
                                                                  attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.txtPassword.attributedPlaceholder = NSAttributedString(string: "txt_password".localized(),
                                                                    attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        self.txtCnfPassword.attributedPlaceholder = NSAttributedString(string: "txt_cnf_mobile".localized(),
                                                                  attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.imgSeparator1.backgroundColor = UIColor.white
        self.imgSeparator2.backgroundColor = UIColor.white
        self.imgSeparator3.backgroundColor = UIColor.white
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
