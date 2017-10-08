//
//  SignUpViewController.swift
//  Tricky
//
//  Created by gopalsara on 19/08/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0
import ObjectMapper

class SignUpViewController: UIViewController {
    
    //  @IBOutlet weak var lblTitle : UILabel!
    //  @IBOutlet weak var lblMobile : UILabel!
    //  @IBOutlet weak var lblPassword : UILabel!
    //  @IBOutlet weak var lblUrl : UILabel!
    //  @IBOutlet weak var lblPhoto : UILabel!
    //  @IBOutlet weak var lblNotifications : UILabel!
    @IBOutlet weak var lblTnC : UILabel!
    //  @IBOutlet weak var lblNoFileChoosen : UILabel!
    
    //  @IBOutlet weak var txtSelectCode : UITextField!
    @IBOutlet weak var txtMobile : UITextField!
    @IBOutlet weak var txtLink : UITextField!
    //  @IBOutlet weak var txtUrl : UITextField!
    @IBOutlet weak var txtDomain : UITextField!
    
    //  @IBOutlet weak var btnNotifications : UIButton!
    @IBOutlet weak var btnTnC : UIButton!
    @IBOutlet weak var btnRegister : UIButton!
    //  @IBOutlet weak var btnChooseFile : UIButton!
    
    @IBOutlet weak var imgBG : UIImageView!
    @IBOutlet weak var viewTop : UIView!
    @IBOutlet var btnCountryCode : UIButton!
    
    @IBOutlet var btnClickHere : UIButton!
    @IBOutlet var btnAllredyAC : UIButton!


    var arrCountryCode =  [String]()
    
    //  let arrCountryCode = ["+91","+01","+02"]
    //  var imagePicker = UIImagePickerController()
    
    /*  @IBOutlet  var txtMobile : UITextField!
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
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.decorateUI()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    func decorateUI()
    {
        self.btnCountryCode.setTitle("+91", for: .normal)
        self.viewTop.layer.borderColor = UIColor.white.cgColor
        self.viewTop.layer.cornerRadius = 5.0
        self.viewTop.layer.borderWidth = 1.0
        
        self.title = "txt_SignUp_nav_title".localized()

        
       // CommanUtility.decorateNavigationbarWithBackButtonAndTitle(target: self, leftselect: #selector(doClickBack), strTitle: "txt_SignUp_nav_title".localized(), strBackImag: BACK_BUTTON, strFontName: "Arial", size: 20, color: UIColor.white)
        
        self.imgBG.backgroundColor = color(red: 89, green: 165, blue: 171)
        
        self.btnTnC.setImage(UIImage(named : CHECKBOX_UNSELECTED) , for: .normal)
        self.btnTnC.setImage(UIImage(named : CHECKBOX_SELECTED) , for: .selected)
        self.btnTnC.isSelected = false
        
        self.lblTnC.text = "txt_TnC".localized()
        self.btnRegister.setTitle("txt_btn_Reg".localized(), for: .normal)
        self.btnRegister.setTitleColor(UIColor.white, for: .normal)
        self.btnRegister.layer.borderColor = UIColor.white.cgColor
        self.btnRegister.layer.borderWidth = 1.0
        self.btnRegister.backgroundColor = UIColor.clear
        
        self.txtMobile.attributedPlaceholder = NSAttributedString(string: "txt_mobile".localized(),
                                                                  attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        self.txtLink.attributedPlaceholder = NSAttributedString(string: "txt_link".localized(),
                                                                attributes: [NSForegroundColorAttributeName: UIColor.white])
        
        self.txtMobile.textColor = UIColor.white
        self.txtLink.textColor = UIColor.white
        self.btnAllredyAC.setTitle("txt_allready_ac".localized(), for: .normal)
        self.btnAllredyAC.titleLabel?.textColor = UIColor.white
        self.btnClickHere.setTitle("txt_click_here".localized(), for: .normal)
        self.btnClickHere.titleLabel?.textColor = UIColor.white
        
        CommanUtility.createCustomRightButton(self, navBarItem: self.navigationItem, strRightImage: "headericon", select: #selector(self.doNothing))
        
        self.readJson()


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

    
    func doNothing(){
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.barTintColor = color(red: 244, green: 166, blue: 202)
        self.navigationItem.setHidesBackButton(true, animated: false)
        

    }
    
    @IBAction func doActionOnClickHereButton() {
        
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewIdentifier") as! LoginViewController
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func doClickBack()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doClickTnC()
    {
        self.btnTnC.isSelected = !self.btnTnC.isSelected
    }
    
    
    func doCallServiceForGenrateOTP() {
        
        let dictData = ["mobileNo" :(self.txtMobile.text!) , "countryCode" : "+91"] as [String : Any]
        print(dictData)
        
        WebAPIManager.sharedWebAPIManager.doCallWebAPIForPOST(strURL: kBaseUrl, strServiceName: METHOD_OTP, parameter: dictData , success: { (obj) in
            print("this is object \(obj)")
            
            let OTPData = Mapper<OTPModel>().map(JSON: obj)
            
            if (OTPData?.status == "1")
            {
                self.goTOVerifyScreen(OTPData : OTPData!)
            }
            else
            {
                CommonUtil.showTotstOnWindow(strMessgae: (OTPData?.responseMessage)!)
            }
            
            
        }) { (error) in
            CommonUtil.showTotstOnWindow(strMessgae: (error?.localizedDescription)!)
        }    }
    

    
    
    func goTOVerifyScreen(OTPData : OTPModel) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "VerifyOTPController") as! VerifyOTPController
        vc.isFromSignUp = true
        vc.strMobileNo = self.txtMobile.text
        vc.strLink = self.txtLink.text
        vc.strOTP = "\(String(describing: OTPData.otp!))"
        vc.strCountryCode = self.btnCountryCode.titleLabel?.text
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func doClickNotifications()
    {
        // self.btnNotifications.isSelected = !self.btnNotifications.isSelected
    }
    
    @IBAction func doClickSelectCode(sender : UIButton)
    {
        ActionSheetMultipleStringPicker.show(withTitle: "Select Code", rows: [
            self.arrCountryCode
            ], initialSelection: [0], doneBlock: {
                picker, indexes, values in
                
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
    
    @IBAction func doClickRegister()
    {
        let (boolValue , message) = CommonUtil.doValidateRegistration(self)
        if boolValue {
            self.doCallServiceForGenrateOTP()
        }else{
            CommonUtil.showTotstOnWindow(strMessgae: message)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
