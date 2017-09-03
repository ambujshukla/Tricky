//
//  OTPViewController.swift
//  OTPSection
//
//  Created by gopalsara on 19/08/17.
//  Copyright © 2017 gopalsara. All rights reserved.
//

import UIKit

class VerifyOTPController: UIViewController
{
    @IBOutlet weak var tfOtp   : UITextField!
    @IBOutlet weak var btnOTP  : UIButton!
    @IBOutlet weak var btnResend  : UIButton!
    @IBOutlet weak var imgBG : UIImageView!
    var isFromSignUp : Bool = false
    
    var isFromForgotPasswordScren : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.decorateUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func decorateUI ()
    {
        self.btnOTP.backgroundColor = UIColor.white
        self.btnOTP.setTitleColor(UIColor.darkGray, for: .normal)
        self.tfOtp.attributedPlaceholder = NSAttributedString(string: "txt_otp".localized(),
                                                              attributes: [NSForegroundColorAttributeName: UIColor.white])
        if self.isFromSignUp {
            self.btnOTP.setTitle("txt_verify".localized(), for: .normal)
            self.imgBG.image = UIImage(named : OTP_BG)
        }else
        {
            self.imgBG.image = UIImage(named : OTP_FORGOT_BG)
            self.btnOTP.setTitle("txt_reset".localized(), for: .normal)
        }
        self.btnResend.setTitleColor(UIColor.darkGray, for: .normal)
        
        CommanUtility.decorateNavigationbarWithBackButtonAndTitle(target: self, leftselect: #selector(doClickBack), strTitle: "txt_otp_verify".localized(), strBackImag: BACK_BUTTON, strFontName: "Arial", size: 20, color: color(red: 60, green: 120, blue: 101))
        
        self.tfOtp.textColor = UIColor.white
        self.btnResend.setTitleColor(UIColor.white, for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.isFromSignUp {
            self.navigationController?.navigationBar.barTintColor = color(red: 120, green: 211, blue: 151)
        }else{
            self.navigationController?.navigationBar.barTintColor = color(red: 102, green: 198, blue: 178)
        }
    }
    
    func doClickBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doClickReset()
    {
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        //        self.navigationController?.pushViewController(vc, animated: true)
        if self.isFromForgotPasswordScren
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewPasswordController") as! NewPasswordController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
