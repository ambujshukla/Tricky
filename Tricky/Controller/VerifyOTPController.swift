//
//  OTPViewController.swift
//  OTPSection
//
//  Created by gopalsara on 19/08/17.
//  Copyright © 2017 gopalsara. All rights reserved.
//

import UIKit
import ObjectMapper

class VerifyOTPController: UIViewController
{
    @IBOutlet weak var tfOtp   : UITextField!
    @IBOutlet weak var btnOTP  : UIButton!
    @IBOutlet weak var btnResend  : UIButton!
    @IBOutlet weak var imgBG : UIImageView!
    var isFromSignUp : Bool = false
    var strMobileNo : String!
    var strOTP : String!
    var strLink : String!
    @IBOutlet weak var lblTimer : UILabel!
    var timer = Timer()
    var time = 60
    
    var isFromForgotPasswordScren : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.decorateUI()
        self.btnResend.isEnabled = false
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(doCallTimer)), userInfo: nil, repeats: true)
    }
    
    func doCallTimer()
    {
        if time > 0 {
            time -= 1
            let minutes = Int(time) / 60 % 60
            let seconds = Int(time) % 60
            self.lblTimer.text = String(format:"%02i:%02i", minutes, seconds)
        }else{
            self.btnResend.isEnabled = true
            timer.invalidate()
        }
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
        self.tfOtp.text = self.strOTP
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if self.isFromSignUp {
            self.navigationController?.navigationBar.barTintColor = color(red: 120, green: 211, blue: 151)
        }else{
            self.navigationController?.navigationBar.barTintColor = color(red: 102, green: 198, blue: 178)
        }
    }
    
    func doCallWebAPIForLogin()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let dictData = ["mobileNo" :self.strMobileNo ,"deviceToken":appDelegate.strDeviceToken , "otp" : self.strOTP , "countryCode" : "+91" , "os" :"2" ,"version" : "1.0.0" ,"language" : "english" ] as [String : Any]
        print(dictData)
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: METHOD_LOGIN, parameter: dictData , success: { (obj) in
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
        
        
        //        WebAPIManager.sharedWebAPIMAnager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: METHOD_LOGIN, parameter: dictData , success: { (obj) in
        //            print("this is object \(obj)")
        //
        //            let loginData = Mapper<LoginModel>().map(JSON: obj)
        //
        //            if (loginData?.status == "1")
        //            {
        //                UserManager.sharedUserManager.doSetLoginData(userData: (loginData?.responseData?[0])!)
        //                self.goTOHomeScreen()
        //            }
        //            else
        //            {
        //                CommonUtil.showTotstOnWindow(strMessgae: (loginData?.responseMessage)!)
        //            }
        //
        //
        //        }) { (error) in
        //            CommonUtil.showTotstOnWindow(strMessgae: (error?.localizedDescription)!)
        //        }
    }
    
    func doCallWebAPIForRegistration()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let dictData = ["version" : "1.0" , "os" : "2" , "language" : "english" , "mobileNo": self.strMobileNo  , "url":self.strLink , "deviceToken" : appDelegate.strDeviceToken , "countryCode" : "+91" , "otp" : self.strOTP] as [String : Any]
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: "register", parameter: dictData , success: { (obj) in
            let regData = Mapper<RegistrationModel>().map(JSON: obj)
            
            if (regData?.status == "1")
            {
                UserManager.sharedUserManager.doSetLoginData(userData: (regData?.responseData?[0])!)
                self.goTOHomeScreen()
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
    
    func doClickBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doClickReset()
    {
        if self.isFromForgotPasswordScren
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewPasswordController") as! NewPasswordController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            self.btnResend.isEnabled = false
            if isFromSignUp {
                self.doCallWebAPIForRegistration()
            }
            else{
                self.doCallWebAPIForLogin()
            }
        }
    }
    
    @IBAction func doClickResend(sender : UIButton)
    {
        self.btnResend.isEnabled = false
        if isFromSignUp {
            self.doCallWebAPIForRegistration()
        }
        else{
            self.doCallWebAPIForLogin()
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(doCallTimer)), userInfo: nil, repeats: true)
    }
    
    func goTOHomeScreen()
    {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(controller, animated: true, completion: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
