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

class LoginViewController: GAITrackedViewController
{
    @IBOutlet  var txtMobile : UITextField!
    
    @IBOutlet  var btnLogin : UIButton!
    @IBOutlet  var btnForgotPassword : UIButton!
    @IBOutlet  var btnSignup : UIButton!
    @IBOutlet  var btnDontAccount : UIButton!
    @IBOutlet  var imgSeparator1 : UIImageView!
    @IBOutlet var imgBg : UIImageView!
    @IBOutlet var btnCountryCode : UIButton!
    var arrCountryCode =  [String]()
    var selectedIndex : Int = 0

    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.decorateUI()
    }
    
    func decorateUI(){
        //self.txtPassword.text = "123456"
       //
        
        //self.txtMobile.text = "8770236795"
        self.btnCountryCode.setTitle("+91", for: .normal)
        
        self.title = "txt_login".localized()

        self.btnLogin.setTitle("txt_login".localized(), for: .normal)
        self.btnLogin.setTitleColor(UIColor.white, for: .normal)
        self.btnLogin.layer.borderColor = UIColor.white.cgColor
        self.btnLogin.layer.borderWidth = 1.0
        self.btnLogin.backgroundColor = UIColor.clear
        

        
        self.imgBg.image = UIImage(named : LOGIN_BG)
        
        self.btnForgotPassword.setTitle("txt_forgot_password".localized(), for: .normal)
        self.btnForgotPassword.titleLabel?.textColor = UIColor.white
        
        self.btnSignup.setTitle("txt_click_here".localized(), for: .normal)
        self.btnSignup.titleLabel?.textColor = UIColor.white
        
        self.btnDontAccount.setTitle("txt_don't_have_account".localized(), for: .normal)
        self.btnDontAccount.titleLabel?.textColor = UIColor.white
        
        self.txtMobile.attributedPlaceholder = NSAttributedString(string: "txt_mobile".localized(),
                                                                  attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        self.imgSeparator1.backgroundColor = UIColor.white
        self.txtMobile.textColor = UIColor.white
        CommanUtility.createCustomRightButton(self, navBarItem: self.navigationItem, strRightImage: "headericon", select: #selector(self.doNothing))
        
        self.readJson()
    }
    
    func doNothing(){
        
    }
    
    
    private func readJson() {
        do {
            if let file = Bundle.main.url(forResource: "CountryCodes", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    print(object)
                } else if let object = json as? [Any] {
                    // json is an array
                    print(object)
                    
                    for obj in object {
                        
                    let data : [String : Any] = obj as! [String : Any]
                    self.arrCountryCode.append("\(data["name"]!)(\(data["dial_code"]!))")
                    }
                    
                    print("this is arr data \(self.arrCountryCode)")
                    
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(true)
        // Set screen name.
        self.screenName = "Login"
        
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
            self.doCallServiceForGenrateOTP()
        }
        print(boolValue,message)
    }
    
    func doCallServiceForGenrateOTP() {
        
        let dictData = ["mobileNo" :(self.txtMobile.text!) , "countryCode" : (self.btnCountryCode.titleLabel?.text)! , "isSignUp" : "0"] as [String : Any]
        print(dictData)
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: METHOD_OTP, parameter: dictData , success: { (obj) in
            print("this is object \(obj)")
            
            let OTPData = Mapper<OTPModel>().map(JSON: obj)
            
            if (OTPData?.status == "1")
            {
                self.goTOHomeScreen(OTPData : OTPData!)
            }
            else
            {
                CommonUtil.showTotstOnWindow(strMessgae: (OTPData?.responseMessage)!)
            }
            
            
        }) { (error) in
            CommonUtil.showTotstOnWindow(strMessgae: "txt_something_went_wrong".localized())
        }    }
    
    
    func goTOHomeScreen(OTPData : OTPModel)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPController") as! VerifyOTPController
        vc.isFromSignUp = false
        vc.strMobileNo = self.txtMobile.text
        vc.strCountryCode = self.btnCountryCode.titleLabel?.text
        vc.strInfoMsg = OTPData.info_msg
     //   vc.strOTP = "\(String(describing: OTPData.otp!))"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func doClickForgotPassword(sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordController") as! ForgotPasswordController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func doClickSignUp(sender: UIButton)
    {
        self.navigationController?.popViewController(animated: true)
        
//        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewIdentifier") as! SignUpViewController
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func doClickCountryCode(sender : UIButton)
    {
                ActionSheetMultipleStringPicker.show(withTitle: "Select Code", rows: [
                    self.arrCountryCode
                    ], initialSelection: [self.selectedIndex], doneBlock: {
                        picker, indexes, values in
                        
                        let array = indexes as! [Int]
                        self.selectedIndex = array[0]
                        print(array[0])
                        
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
