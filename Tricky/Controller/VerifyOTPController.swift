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
        self.btnOTP.setTitle("txt_verify".localized(), for: .normal)
        self.btnOTP.backgroundColor = UIColor.white
        self.btnOTP.setTitleColor(UIColor.darkGray, for: .normal)
        self.imgBG.image = UIImage(named : OTP_BG)
        self.tfOtp.attributedPlaceholder = NSAttributedString(string: "txt_otp".localized(),
                                                                    attributes: [NSForegroundColorAttributeName: UIColor.white])
        self.btnResend.setTitle("txt_resend_otp".localized(), for: .normal)
        self.btnResend.setTitleColor(UIColor.darkGray, for: .normal)
        
        CommanUtility.decorateNavigationbar(target: self, strTitle: "txt_otp_verify".localized())
        
        CommanUtility.decorateNavigationbarWithBackButtonAndTitle(target: self, leftselect: #selector(doClickBack), strTitle: "", strBackImag: BACK_BUTTON, strFontName: "Arial", size: 20, color: UIColor.white)
        
        self.tfOtp.textColor = UIColor.white
        self.btnResend.setTitleColor(UIColor.white, for: .normal)
    }
    
    func doClickBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doClickReset()
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessageViewController") as! MessageViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
