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
    @IBOutlet weak var lblInfo : UILabel!
    var isFromSignUp : Bool = false
    var strMobileNo : String!
    var strOTP : String!
    var strLink : String!
    var strCountryCode : String!
    @IBOutlet weak var lblTimer : UILabel!
    var timer = Timer()
    var time = 15
    
    var isFromForgotPasswordScren : Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.decorateUI()
        self.btnResend.isEnabled = false
        self.btnResend.setTitleColor(UIColor.darkGray, for: .normal)
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
            
            self.lblTimer.text = ""
            self.btnResend.isEnabled = true
            self.btnResend.setTitleColor(UIColor.white, for: .normal)
            timer.invalidate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func decorateUI ()
    {
        self.lblInfo.text = "otp_info".localized()
        self.btnOTP.backgroundColor = UIColor.white
        
        self.btnOTP.setTitleColor(UIColor.white, for: .normal)
        self.btnOTP.layer.borderColor = UIColor.white.cgColor
        self.btnOTP.layer.borderWidth = 1.0
        self.btnOTP.backgroundColor = UIColor.clear
        
        
        
        self.tfOtp.attributedPlaceholder = NSAttributedString(string: "txt_otp".localized(),
                                                              attributes: [NSForegroundColorAttributeName: UIColor.white])
      //  if self.isFromSignUp {
            self.btnOTP.setTitle("txt_verify".localized(), for: .normal)
            self.imgBG.image = UIImage(named : OTP_BG)
//        }else
//        {
//            self.imgBG.image = UIImage(named : OTP_FORGOT_BG)
//            self.btnOTP.setTitle("txt_reset".localized(), for: .normal)
//        }
        CommanUtility.decorateNavigationbarWithBackButtonAndTitle(target: self, leftselect: #selector(doClickBack), strTitle: "txt_otp_verify".localized(), strBackImag: BACK_BUTTON, strFontName: "Arial", size: 20, color: color(red: 60, green: 120, blue: 101))
        
        self.tfOtp.textColor = UIColor.white
        self.btnResend.setTitleColor(UIColor.darkGray, for: .normal)
        
        CommanUtility.createCustomRightButton(self, navBarItem: self.navigationItem, strRightImage: "headericon", select: #selector(self.doNothing))

    }
    
    func doNothing(){
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
      //  if self.isFromSignUp {
            self.navigationController?.navigationBar.barTintColor = color(red: 120, green: 211, blue: 151)
//        }else{
//            self.navigationController?.navigationBar.barTintColor = color(red: 102, green: 198, blue: 178)
//        }
    }
    
    func doCallWebAPIForLogin(isSignUp : String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let dictData = ["mobileNo" :self.strMobileNo ,"deviceToken":appDelegate.strDeviceToken , "otp" : self.tfOtp.text! , "countryCode" : "+91" , "os" :"2" ,"version" : "1.0.0" ,"language" : "english" , "isSignUp" : isSignUp] as [String : Any]
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
            CommonUtil.showTotstOnWindow(strMessgae: "txt_something_went_wrong".localized())
        }
        
    }
    
    func doCallWebAPIForRegistration(isSignUp : String)
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate

        let dictData = ["version" : "1.0" , "os" : "2" , "language" : "english" , "mobileNo": self.strMobileNo  , "url":self.strLink , "deviceToken" : appDelegate.strDeviceToken , "countryCode" : "+91" , "otp" : self.strOTP , "isSignUp" : isSignUp] as [String : Any]
        
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
            CommonUtil.showTotstOnWindow(strMessgae: "txt_something_went_wrong".localized())
        }
    }
    
    func doClickBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func doCallServiceForGenrateOTP() {
        
        let dictData = ["mobileNo" :self.strMobileNo , "countryCode" : self.strCountryCode] as [String : Any]
        print(dictData)
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: METHOD_OTP, parameter: dictData , success: { (obj) in
            print("this is object \(obj)")
            
            let OTPData = Mapper<OTPModel>().map(JSON: obj)
            
            if (OTPData?.status == "1")
            {
                self.time = 15
                self.btnResend.isEnabled = false
                self.btnResend.setTitleColor(UIColor.darkGray, for: .normal)
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.doCallTimer)), userInfo: nil, repeats: true)
            }
            else
            {
                CommonUtil.showTotstOnWindow(strMessgae: (OTPData?.responseMessage)!)
            }
            
            
        }) { (error) in
            CommonUtil.showTotstOnWindow(strMessgae: "txt_something_went_wrong".localized())
        }    }

    
    @IBAction func doClickReset(){
        if self.isFromForgotPasswordScren
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewPasswordController") as! NewPasswordController
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            
            if ((self.tfOtp.text?.characters.count)! > 0){
            
            CommonUtil.setData("countryCode", value: self.strCountryCode! as NSString)
            self.btnResend.isEnabled = false
            if isFromSignUp {
                self.doCallWebAPIForRegistration(isSignUp : "1")
            }
            else{
                self.doCallWebAPIForLogin(isSignUp : "0")
            }
            }else{
                CommonUtil.showTotstOnWindow(strMessgae: "txt_opt_check".localized())
            }
        }
    }
    
    @IBAction func doClickResend(sender : UIButton){

        self.doCallServiceForGenrateOTP()
    }
    
    func goTOHomeScreen()
    {
        CommonUtil.setBooleanValue("isLogin", value: true)
        if (self.isFromSignUp)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProfileViewIdentifier") as! ProfileViewController
            vc.isFromSignUp = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else
        {
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.present(controller, animated: true, completion: nil)
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}
