//
//  CommonUtil.swift
//
//

import UIKit
import SVProgressHUD
import SystemConfiguration
import Alamofire
import Toast_Swift

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

var instance: CommonUtil?

class CommonUtil: NSObject {
    
    
    class func sharedInstance() -> CommonUtil {
        if !(instance != nil) {
            instance = CommonUtil()
        }
        return instance!
    }
    
    class func showLoader()
    {
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.gradient)
    }
    
    class  func hideLoader()
    {
        SVProgressHUD.dismiss()
    }
    // MARK:Error Messaging
    
    
    
    //MARK: Validation
    
    class func checkNullString(_ str:String!)->Bool
    {
        if str.isEmpty
        {
            return false
        }
        return true
    }
    
    //MARK: Check valid email
    class func checkValidEmail(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    class func checkValidPassword(_ testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    
    class func doValidateRegistration(_ controller:SignUpViewController)->(Bool,String)
    {
        
        controller.txtMobile.text = controller.txtMobile.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        controller.txtLink.text = controller.txtLink.text?.trimmingCharacters(in: .whitespacesAndNewlines)
       
        if(controller.txtMobile.text!.isEmpty)
        {
            return (false,NSString(format: "%@", "txt_please_enter_mobile".localized()) as String)
        }
       else if(controller.txtLink.text!.isEmpty)
        {
            return (false,NSString(format: "%@", "Please enter Username") as String)
        }
          else if(!controller.btnTnC.isSelected)
        {
            return (false,NSString(format: "%@", "Please select Terms and Conditions") as String)
        }
        return (true,"")
    }
    
    /*
     class func doValidateProfileSetup(_ controller:ProfileSetupViewController)->(Bool,String)
     {
     if(controller.tfUserName.text!.isEmpty)
     {
     return (false,"First and Last Name required")
     
     }
     return (true,"")
     }
     */
    /*
     
     class func doValidateProfile(_ controller:ProfileViewController)->(Bool,String)
     {
     if(controller.tfUserName.text!.isEmpty)
     {
     return (false,"First and Last Name required")
     }
     return (true,"")
     }
     */
    
    class func doValidateLogin(_ controller:LoginViewController)->(Bool,String)
    {
        if(controller.txtMobile.text!.isEmpty)
        {
            return (false,NSString(format: "%@", "Please enter mobile") as String)
        }
        //        else if(controller.txtPassword.text!.isEmpty)
        //        {
        //            return (false,NSString(format: "%@", "Please enter password") as String)
        //        }
        return (true,"")
    }
    
    /*
     class func doValidateForgotPassword(_ controller:ForgotPasswordViewController)->(Bool,String)
     {
     controller.tfEmail.text = controller.tfEmail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
     
     if(controller.tfEmail.text!.isEmpty)
     {
     return (false,"Please enter email")
     }
     else if(!checkValidEmail(controller.tfEmail.text!))
     {
     return (false,"Please enter valid email")
     }
     
     
     return (true,"")
     }
     */
    /*
     
     class func doValidateResetPassword(_ controller : ReEnterPasswordViewController)-> (Bool,String) {
     
     
     if(controller.tfOldPassword.text!.isEmpty)
     {
     return (false,"Please enter password")
     
     }else if(controller.tfOldPassword.text != CommonUtil.getDataForKey("userPassword")){
     return(false,"Wrong old password")
     }
     else if(controller.tfNewPassword.text!.isEmpty)
     {
     return (false,"Please enter password")
     }
     else if(controller.tfReEnterNewPass.text!.isEmpty)
     {
     return (false,"Please enter password")
     }
     else if(controller.tfOldPassword.text?.characters.count < 4 || controller.tfNewPassword.text?.characters.count < 8 || controller.tfReEnterNewPass.text?.characters.count < 8)
     {
     return (false,"Password must have at least 8 characters")
     }
     
     else  if(!(controller.tfNewPassword.text == controller.tfReEnterNewPass.text))
     {
     return (false,"Password mismatch, Please try again")
     }
     return (true,"")
     }
     
     */
    /*
     class func doValidateFrameCode(_ controller:AddFrameCodeViewController)->(Bool,String)
     {
     if(controller.tfCode1.text!.isEmpty)
     {
     return (false,"Please enter 6 digit frame code")
     
     }
     else  if(controller.tfCode2.text!.isEmpty)
     {
     return (false,NSString(format: "%@", "Please enter 6 digit frame code") as String)
     }
     else  if(controller.tfCode3.text!.isEmpty)
     {
     return (false,NSString(format: "%@", "Please enter 6 digit frame code") as String)
     } else  if(controller.tfCode4.text!.isEmpty)
     {
     return (false,NSString(format: "%@", "Please enter 6 digit frame code") as String)
     } else  if(controller.tfCode5.text!.isEmpty)
     {
     return (false,NSString(format: "%@", "Please enter 6 digit frame code") as String)
     } else  if(controller.tfCode6.text!.isEmpty)
     {
     return (false,NSString(format: "%@", "Please enter 6 digit frame code") as String)
     }
     return (true,"")
     }
     */
    /*
     
     class func doValidateFrameCode(_ controller:WizardSetupAddFrameViewController)->(Bool,String)
     {
     if(controller.tfCode1.text!.isEmpty)
     {
     return (false,"Please enter 6 digit frame code")
     
     }
     else  if(controller.tfCode2.text!.isEmpty)
     {
     return (false,NSString(format: "%@", "Please enter 6 digit frame code") as String)
     }
     else  if(controller.tfCode3.text!.isEmpty)
     {
     return (false,NSString(format: "%@", "Please enter 6 digit frame code") as String)
     } else  if(controller.tfCode4.text!.isEmpty)
     {
     return (false,NSString(format: "%@", "Please enter 6 digit frame code") as String)
     } else  if(controller.tfCode5.text!.isEmpty)
     {
     return (false,NSString(format: "%@", "Please enter 6 digit frame code") as String)
     } else  if(controller.tfCode6.text!.isEmpty)
     {
     return (false,NSString(format: "%@", "Please enter 6 digit frame code") as String)
     }
     return (true,"")
     }
     */
    
    //MARK:Navigation Bar Decoration
    
    class func decorateNavBar(_ target:AnyObject,leftImage:String,rightImage:String,title:String,leftSelector:Selector?,rightSelector:Selector?)
    {
        target.navigationController?!.navigationBar.isHidden = false
        
        if !(leftImage.isEmpty)
        {
            self.createCustomBackButton(target, navBarItem: target.navigationItem, strImage: leftImage as NSString, select: leftSelector!)
            
        }
        if !(rightImage.isEmpty)
        {
            self.createCustomRightButton(target, navBarItem: target.navigationItem, strImage: rightImage as NSString, select: rightSelector!)
            
        }
        if !(title.isEmpty)
        {
            self.setNavBarTitle(target.navigationItem, title: title as String as NSString)
        }
        
        target.navigationController?!.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont(name: FONT_ROBOTO_REGULAR , size: 20 )!]
    }
    
    class func createCustomRightButton(_ target:AnyObject,navBarItem:UINavigationItem,strImage:NSString,select:Selector)
    {
        let buttonEdit: UIButton = UIButton(type: .custom)
        buttonEdit.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        // buttonEdit.setImage(UIImage(named:strImage as String), for: UIControlState())
        buttonEdit.setTitle("Done", for: UIControlState())
        buttonEdit.addTarget(target, action: select, for: UIControlEvents.touchUpInside)
        let rightBarButtonItemEdit: UIBarButtonItem = UIBarButtonItem(customView: buttonEdit)
        navBarItem.setRightBarButton(rightBarButtonItemEdit, animated: false)
    }
    
    class func createCustomRightButtons(_ target:AnyObject,navBarItem:UINavigationItem,strLeftImage:NSString,leftselect:Selector,strRightImage:NSString,select:Selector)
    {
        
        let buttonleft: UIButton = UIButton(type: .custom)
        buttonleft.frame = CGRect(x: 40, y: 0, width: 40, height: 40)
        buttonleft.setImage(UIImage(named:strLeftImage as String), for: UIControlState())
        buttonleft.addTarget(target, action: leftselect, for: UIControlEvents.touchUpInside)
        let leftBarButtonItemEdit: UIBarButtonItem = UIBarButtonItem(customView: buttonleft)
        
        let buttonEdit: UIButton = UIButton(type: .custom)
        buttonEdit.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        buttonEdit.setImage(UIImage(named:strRightImage as String), for: UIControlState())
        buttonEdit.addTarget(target, action: select, for: UIControlEvents.touchUpInside)
        let rightBarButtonItemEdit: UIBarButtonItem = UIBarButtonItem(customView: buttonEdit)
        // add multiple right bar button items
        navBarItem.setRightBarButtonItems(NSArray(objects: rightBarButtonItemEdit,leftBarButtonItemEdit) as NSArray as? [UIBarButtonItem], animated: true)
        // uncomment to add single right bar button item
        // self.navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: false)
    }
    
    class func createCustomRightButton(_ target:AnyObject,navBarItem:UINavigationItem,strTitle : NSString ,strRightImage:NSString,select:Selector){
        
        let buttonEdit: UIButton = UIButton(type: .custom)
        buttonEdit.frame = CGRect(x: 0, y: 0, width: 60, height: 40)
        //buttonEdit.setImage(UIImage(named:strRightImage as String), for: UIControlState())
        buttonEdit.setTitle(strTitle as String, for: .normal)
        buttonEdit.addTarget(target, action: select, for: UIControlEvents.touchUpInside)
        let rightBarButtonItemEdit: UIBarButtonItem = UIBarButtonItem(customView: buttonEdit)
        // add multiple right bar button items
        navBarItem.setRightBarButtonItems(NSArray(objects: rightBarButtonItemEdit) as NSArray as? [UIBarButtonItem], animated: true)
    }
    
    class func createCustomBackButton(_ target:AnyObject,navBarItem:UINavigationItem,strImage:NSString,select:Selector)
    {
        
        let buttonEdit: UIButton = UIButton(type: .custom)
        buttonEdit.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        buttonEdit.setImage(UIImage(named:strImage as String), for: UIControlState())
        buttonEdit.addTarget(target, action: select, for: UIControlEvents.touchUpInside)
        let rightBarButtonItemEdit: UIBarButtonItem = UIBarButtonItem(customView: buttonEdit)
        navBarItem.setLeftBarButton(rightBarButtonItemEdit, animated: false)
        
        // add multiple right bar button items       self.navigationItem.setRightBarButtonItems([rightBarButtonItemDelete, rightBarButtonItemEdit], animated: true)
        // uncomment to add single right bar button item
        // self.navigationItem.setRightBarButtonItem(rightBarButtonItem, animated: false)
        
    }
    class func setNavBarTitle(_ navBarItem:UINavigationItem,title:NSString)
    {
        navBarItem.title =  title as String // CommonUtil.getLocalizeString(title as String) as String
        
    }
    class func setNavBarImage(_ navigationController:UINavigationController,title:NSString)
    {
        // let logo = UIImage(named: "home.jpeg")
        //let imageView = UIImageView(image:logo)
        //navBarItem.titleView = imageView
        // navigationController.navigationBar.setBackgroundImage(logo, forBarMetrics: .Default)
        navigationController.navigationBar.barTintColor = UIColor(red: 29.0/255.0, green: 92/255.0, blue: 164.0/255.0, alpha: 1.0)
        var font1:UIFont!
        
        font1 = UIFont(name: FONT_ROBOTO_REGULAR, size:20.0)!
        navigationController.navigationBar.titleTextAttributes = [NSFontAttributeName: font1,  NSForegroundColorAttributeName: UIColor.white]
        
    }
    
    
    
    //MARK:Localize File
    
    class func getLocalizeString(_ key:String)->String//(NSString*)key lang:(int)selectedLanguage
    {
        
        let userDefault:UserDefaults = UserDefaults.standard
        var path:NSString
        if (userDefault.value(forKey: "lang") as! String)==("en")
        {
            path = Bundle.main.path(forResource: "en", ofType: "lproj")! as NSString
        }
        else
        {
            path = Bundle.main.path(forResource: "ar", ofType: "lproj")! as NSString
        }
        
        let languageBundle :Bundle  = Bundle(path: path as String)!
        let str:NSString = languageBundle.localizedString(forKey: key, value: "", table: nil) as NSString
        //  print(str)
        return str as String;
        
    }
    
    
    class func showAlertWithSingleButton(_ message:String , title :String ,btnCancel:String, successBlock : @escaping (_ obj : Int) -> Void) {
        
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            if !(btnCancel.isEmpty )
            {
                alert.addAction(UIAlertAction(title: btnCancel, style: UIAlertActionStyle.default, handler: { action in
                    successBlock(0)
                }))
            }
            UIApplication.shared.delegate?.window!?.rootViewController?.present(alert, animated: true, completion: nil)
        })
        
    }
    
    
    class func showAlertInSwift_3Format(_ message:String , title :String ,btnCancel:String,btnOk:String, crl : UIViewController , successBlock : @escaping (_ obj : Int) -> Void , failure : @escaping (_ error : Int) -> Void)
    {
        DispatchQueue.main.async(execute: {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            if !(btnCancel.isEmpty )
            {
                alert.addAction(UIAlertAction(title: btnCancel, style: UIAlertActionStyle.default, handler: { action in
                    failure(0)
                }))
            }
            
            if !(btnOk.isEmpty )
            {
                alert.addAction(UIAlertAction(title: btnOk, style: UIAlertActionStyle.default, handler: { action in
                    alert.dismiss(animated: true, completion: nil)
                    successBlock(1)
                }))
            }
            
            crl.present(alert, animated: true, completion: nil)
          //  UIApplication.shared.delegate?.window!?.rootViewController?.present(alert, animated: true, completion: nil)
        })
        
    }
    
    
    //MARK: Text attributes Settings
    
    //    class func setTextAttribute(_ sender:AnyObject,title:String,fontName:String,size:CGFloat,RGB:CGFloat...)
    //    {
    //
    //        if sender.isKind(of: UIButton())
    //        {
    //            if !title.isEmpty
    //            {
    //                (sender as! UIButton).setTitle(CommonUtil.getLocalizeString(title) as String as String, for: UIControlState())
    //                (sender as! UIButton).setTitle(CommonUtil.getLocalizeString(title) as String, for: UIControlState.selected)
    //            }
    //            (sender as! UIButton).titleLabel?.font = UIFont(name: fontName, size: size)
    //            if RGB.count>1
    //            {
    //                (sender as! UIButton).titleLabel?.textColor = CommonUtil.getColor(RGB[0],RGB[1],RGB[2])
    //
    //            }
    //        }
    //        else if sender.isKind(of: UILabel())
    //        {
    //            if !title.isEmpty
    //            {
    //                (sender as! UILabel).text = CommonUtil.getLocalizeString(title)
    //            }
    //            (sender as! UILabel).font = UIFont(name: fontName, size: size)
    //            if RGB.count>1
    //            {
    //                (sender as! UILabel).textColor = CommonUtil.getColor(RGB[0],RGB[1],RGB[2])
    //            }
    //
    //        }
    //        else if sender.isKind(of: UITextField())
    //        {
    //            if !title.isEmpty
    //            {
    //                (sender as! UITextField).placeholder = CommonUtil.getLocalizeString(title)
    //            }
    //            (sender as! UITextField).font = UIFont(name: fontName, size: size)
    //            if RGB.count>1
    //            {
    //                (sender as! UITextField).textColor = CommonUtil.getColor(RGB[0],RGB[1],RGB[2])
    //            }
    //        }
    //        else if sender.isKind(of: UITextView())
    //        {
    //            (sender as! UITextView).font = UIFont(name: fontName, size: size)
    //            if RGB.count>1
    //            {
    //                (sender as! UITextView).textColor = CommonUtil.getColor(RGB[0],RGB[1],RGB[2])
    //            }
    //        }
    //
    //    }
    
    class func getColor(_ RGB:CGFloat...) -> UIColor
    {
        return UIColor(red:(RGB[0] as CGFloat/255.0), green: (RGB[1] as CGFloat/255.0), blue: (RGB[2] as CGFloat/255.0), alpha: 1.0)
    }
    //   class func showMessage(message:String,controller:UIViewController,notificationtype:TSMessageNotificationType)
    //    {
    //        //getLocalizeString(message)
    //        TSMessage.setDefaultViewController(controller)
    //        TSMessage.showNotificationWithTitle(App_Name, subtitle: message , type: notificationtype)
    //        TSMessage.dismissActiveNotification()
    //    }
    //    class func showLoader(_ message:String?)
    //    {
    //        /*let app = UIApplication.sharedApplication().delegate as AppDelegate
    //
    //         if (message?.isEmpty != nil)
    //         {
    //         KVNProgress.showWithStatus("Loading..", onView: app.window)
    //         }
    //         else
    //         {
    //         KVNProgress.showWithStatus("", onView: app.window)
    //
    //         }*/
    //        //        if(message != nil)
    //        //        {
    //        //            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Gradient)
    //        //            SVProgressHUD.showWithStatus(message)
    //        //        }
    //        //        else
    //        //        {
    //        //          SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.Gradient)
    //        //          SVProgressHUD.show();
    //        //        }
    ////        let window :UIWindow = UIApplication.shared.keyWindow!
    ////        let hud = GIFProgressHUD.show(withGIFName: "ProgressHUD", title: "", detailTitle: "", addedTo: window, animated: true)
    ////        hud?.backgroundColor = UIColor.clear
    ////        hud?.containerColor = UIColor.clear
    //        //  hud?.scaleFactor = 2.0
    //        //  hud.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    //        //      hud.containerColor = [UIColor colorWithRed:0.0 green:0.0 blue:1.0 alpha:0.5];
    //        //        hud.containerCornerRadius = 10;
    //        //        hud.scaleFactor = 2.0;
    //        //        hud.minimumPadding = 16;
    //        //        hud.titleColor = [UIColor redColor];
    //        //        hud.detailTitleColor = [UIColor greenColor];
    //
    //
    //        //        DispatchQueue.main.async(execute: {
    //        //            GiFHUD.showWithOverlay()
    //        //        })
    //        //GiFHUD.showWithOverlay()
    //
    //
    //    }
    //    class func hideLoader()
    //    {
    //
    //        DispatchQueue.main.async(execute: {
    //            let window :UIWindow = UIApplication.shared.keyWindow!
    //            GIFProgressHUD.hide(for: window, animated: true)
    //            // GiFHUD.dismiss()
    //        })
    //
    //        // KVNProgress.dismiss()
    //        // SVProgressHUD.dismiss()
    //    }
    
    class func showTotstOnWindow(strMessgae: String) {
        
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.makeToast(strMessgae, duration: 2.0, position: .bottom)
    }
    
    class func showWhiteTostOnWindow (strMessgae: String)
    {
        let window :UIWindow = UIApplication.shared.keyWindow!
        window.makeToast(strMessgae)
        
    }
    
    class func getcurrentLanguage() -> String
    {
        //return "en"
        let userDefault:UserDefaults = UserDefaults.standard
        return userDefault.value(forKey: "lang") as! String
    }
    class func setUserCredentials(_ userId:NSString)
    {
        let userDefault:UserDefaults = UserDefaults.standard
        userDefault.set(userId, forKey:"userId")
        userDefault.synchronize()
    }
    
    class func CheckUserLogin(_ controller:UIViewController?)->Bool
    {
        let userDefault:UserDefaults = UserDefaults.standard
        if (userDefault.value(forKey: "userId") != nil)
        {
            return true
        }
        else
        {
            if controller != nil
            {
                //  showMessage("LoginRequired", controller: controller!, notificationtype: TSMessageNotificationType.Error)
            }
            
        }
        return false
    }
    class func getUserId()->String
    {
        let userDefault:UserDefaults = UserDefaults.standard
        
        if (userDefault.value(forKey: "userId") != nil)
        {
            return userDefault.value(forKey: "userId") as! String
        }
        
        return ""
    }
    class func setData(_ key:NSString,value:NSString)
    {
        let userDefault:UserDefaults = UserDefaults.standard
        userDefault.set(value, forKey:key as String)
        userDefault.synchronize()
    }
    class func setUserDefaultBooleanValue(_ strValue: Bool, forUserDefaultKey strKey: String) {
        let userDefault:UserDefaults = UserDefaults.standard
        userDefault.set(strValue, forKey: strKey)
        userDefault.synchronize()
        //   print("setUserDefaultBooleanValue() strValue " + String(strValue) + " strKey " + strKey)
    }
    
    class func getDataForKey(_ key:String)-> String?
    {
        let userDefault:UserDefaults = UserDefaults.standard
        if let data =  userDefault.object(forKey: key as String)
        {
            return data as? String
        }
        return ""
    }
    
    class func setBooleanValue(_ key : NSString , value : Bool)
    {
        let userDefault : UserDefaults = UserDefaults.standard
        userDefault.set(value, forKey: key as String)
        userDefault.synchronize()
    }
    
    class func getBooleanDataForKey(_ key : String) -> Bool?
    {
        let userDefault:UserDefaults = UserDefaults.standard
        if (userDefault.value(forKey: key)   != nil)
        {
            return userDefault.value(forKey: key) as? Bool
        }
        return nil
    }
    
    
    class func filterVulgerMsg() -> String {
        if let isFilterOn  = self.getDataForKey("filterMessage"){
            return isFilterOn
        }
        else{
            return "0"
        }
    }
    
    class func countryCode() -> String{
        if let code  = self.getDataForKey("countryCode"){
            return code
        }
        else{
            return "0"
        }
    }
    
    class func isBlockUser() -> String {
        if let isBlockOn  = self.getDataForKey("isBlockUser"){
            return isBlockOn
        }
        else{
            return "0"
        }
    }
 
    class func isAnonymous() -> String {
        if let isAnonym  = self.getDataForKey("isAnonymous"){
            return isAnonym
        }
        else{
            return "0"
        }
    }
    
    class func isLoggedIn() -> Bool{
        if let isLogged  = self.getBooleanDataForKey("isLogin"){
            return isLogged
        }
        else{
            return false
        }
    }

    
    class func getAttributedString(strCommanFont : String , commanFontSize : Float , strUniqueFont : String , uniqueFontSize : Float , strSpecialString : String , strCompleteString : String) -> NSMutableAttributedString
    {
        
        var myMutableString = NSMutableAttributedString()
        
        myMutableString = NSMutableAttributedString(
            string: strCompleteString ,
            attributes: [NSFontAttributeName:UIFont(
                name: strCommanFont,
                size: CGFloat(commanFontSize))!])
        
        myMutableString.addAttribute(NSFontAttributeName,
                                     value: UIFont(
                                        name: strUniqueFont,
                                        size: CGFloat(uniqueFontSize))!,
                                     range: NSRange(
                                        location: 0,
                                        length: strSpecialString.characters.count))
        
        return myMutableString
        
        
    }
    
    class func doIntializePOpUP (vwPopUp : UIView , vwRoundBox : UIView){
        
        let  window = UIApplication.shared.keyWindow
        vwPopUp.backgroundColor = UIColor.darkGray.withAlphaComponent(0.9)
        vwPopUp.frame = window!.frame
        vwRoundBox.layer.cornerRadius = 10.0
        vwRoundBox.clipsToBounds = true
        window!.addSubview(vwPopUp)
        vwPopUp.isHidden = true
        
    }
    
    
    class func getDocumentDirecory()->NSArray
    {
        return NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,FileManager.SearchPathDomainMask.userDomainMask, true) as NSArray
    }
    
    
    
    class func makeRoundImage (_ image : UIImage , radious : CGFloat) -> UIImage {
        
        let imageLayer = CALayer()
        imageLayer.frame = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        imageLayer.contents = (image.cgImage as AnyObject)
        imageLayer.masksToBounds = true
        imageLayer.cornerRadius = radious
        UIGraphicsBeginImageContext(image.size)
        imageLayer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage!
    }
    
    
    class func getUserImageWithImage(_ image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    class func imageWithImage(_ image: UIImage, scaleToSize newSize: CGSize, isAspectRation aspect: Bool) -> UIImage{
        
        let originRatio = image.size.width / image.size.height;//CGFloat
        let newRatio = newSize.width / newSize.height;
        
        var sz: CGSize = CGSize.zero
        
        if (!aspect) {
            sz = newSize
        }else {
            if (originRatio < newRatio) {
                sz.height = newSize.height
                sz.width = newSize.height * originRatio
            }else {
                sz.width = newSize.width
                sz.height = newSize.width / originRatio
            }
        }
        let scale: CGFloat = 1.0
        
        sz.width /= scale
        sz.height /= scale
        UIGraphicsBeginImageContextWithOptions(sz, false, scale)
        image.draw(in: CGRect(x: 0, y: 0, width: sz.width, height: sz.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    
    class func putTextToLabel(_ label: UILabel, text labelText: String, font labelFontName: String, size labelFontSize: CGFloat, isAutolayout autolayout: Bool, color labelTextColor: UIColor?) {
        label.text = labelText
        if labelTextColor != nil {
            label.textColor = labelTextColor
        }
        label.font = UIFont(name: labelFontName, size: (autolayout) ? labelFontSize * WIDTH_FACTOR : labelFontSize)
    }
    
    //This method is calling from LoginViewController
    
    //    class func doGetAllImagesOfGalleryInBackground()
    //    {
    //        DBManager.sharedManager.getAllImageFromIphoneGallery()
    //
    //    }
    
    //This method is calling from HomeViewController
    
    //    class func doCallMethodForSavingImagesPathInDB(){
    //
    //        DBManager.sharedManager.createTask("")
    //    }
    
    //MARK: WifiConnectivity
    class func isConnectionAvailble()->Bool{
        
        let rechability = SCNetworkReachabilityCreateWithName(kCFAllocatorDefault, "www.apple.com")
        
        var flags : SCNetworkReachabilityFlags = SCNetworkReachabilityFlags()
        
        if SCNetworkReachabilityGetFlags(rechability!, &flags) == false {
            return false
        }
        
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
    }
    
    class func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    class  func addCircleOverlayToImageViewer(viewController: UIViewController) {
        let circleColor = UIColor.clear
        let maskColor = UIColor.black.withAlphaComponent(0.8)
        let screenHeight = UIScreen.main.bounds.size.height
        let screenWidth = UIScreen.main.bounds.size.width
        
        var plCropOverlayCropView: UIView? //The default crop view, we wan't to hide it and show our circular one
        var plCropOverlayBottomBar: UIView? //On iPhone is the bar with "cancel" and "choose" button, on Ipad is an Image View with a label saying "Scale and move"
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            plCropOverlayCropView = viewController.view.subviews[1]
            plCropOverlayBottomBar = viewController.view.subviews[1].subviews[1]
            
            // Protect against iOS changes...
            if plCropOverlayCropView != nil && type(of: plCropOverlayCropView!).description() != "PLCropOverlay" {
                print("Image Picker with circle overlay: PLCropOverlay not found")
                return;
            }
            
            if plCropOverlayBottomBar != nil && type(of: plCropOverlayBottomBar!).description() != "UIImageView" {
                print("Image Picker with circle overlay: PLCropOverlayBottomBar not found")
                return;
            }
        }
        else {
            plCropOverlayCropView = viewController.view.subviews[1].subviews.first
            plCropOverlayBottomBar = viewController.view.subviews[1].subviews[1]
            
            // Protect against iOS changes...
            if plCropOverlayCropView != nil && type(of: plCropOverlayCropView!).description() != "PLCropOverlayCropView" {
                print("Image Picker with circle overlay: PLCropOverlay not found.")
                return;
            }
            
            if plCropOverlayBottomBar != nil && type(of: plCropOverlayBottomBar!).description() != "PLCropOverlayBottomBar" {
                print("Image Picker with circle overlay: PLCropOverlayBottomBar not found.")
                return;
            }
        }
        
        //  It seems that everything is ok, we found the CropOverlayCropView and the CropOverlayBottomBar
        plCropOverlayCropView!.isHidden = true //Hide default CropView
        
        let circleLayer = CAShapeLayer()
        let circlePath = UIBezierPath(ovalIn : CGRect(x: CGFloat(0.0), y: CGFloat(screenHeight / 2 - screenWidth / 2), width: CGFloat(screenWidth), height: CGFloat(screenWidth)))
        circlePath.usesEvenOddFillRule = true
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = circleColor.cgColor
        /*
         
         let circleLayer = CAShapeLayer()
         let circlePath = UIBezierPath(ovalIn : CGRect(x: CGFloat((screenWidth-(screenWidth/2))/2), y: CGFloat((screenHeight)/3), width: CGFloat(screenWidth/2), height: CGFloat(screenWidth/2)))
         circlePath.usesEvenOddFillRule = true
         circleLayer.path = circlePath.cgPath
         circleLayer.fillColor = circleColor.cgColor
         
         */
        // Mask layer frame: it begins on y=0 and ends on y = plCropOverlayBottomBar.origin.y
        let maskPath = UIBezierPath(roundedRect: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(screenWidth), height: CGFloat(screenHeight - (plCropOverlayBottomBar?.frame.size.height)!)), cornerRadius: 0)
        maskPath.append(circlePath)
        maskPath.usesEvenOddFillRule = true
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.fillRule = kCAFillRuleEvenOdd
        maskLayer.fillColor = maskColor.cgColor
        viewController.view.layer.addSublayer(maskLayer)
        
        // Re-add the overlayBottomBar with the label "scale and move" because we set its parent to hidden (it's a subview of PLCropOverlay)
        viewController.view.addSubview(plCropOverlayBottomBar!)
    }
    class  func resize(_ image: UIImage) -> UIImage
    {
        var actualHeight: Float = Float(image.size.height)
        var actualWidth: Float = Float(image.size.width)
        let maxHeight: Float = 300.0
        let maxWidth: Float = 400.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 0.5
        //50 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: CGFloat(0.0), y: CGFloat(0.0), width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        // var imageData: Data? = .uiImageJPEGRepresentation(img,compressionQuality)
        let imageData: Data? = UIImageJPEGRepresentation(img!, CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!)!
    }
    
    class func timeAgoSinceDate(_ date:Date,currentDate:Date, numericDates:Bool) -> String {
        let calendar = Calendar.current
        let now = currentDate
        let earliest = (now as NSDate).earlierDate(date)
        let latest = (earliest == now) ? date : now
        let components:DateComponents = (calendar as NSCalendar).components([NSCalendar.Unit.minute , NSCalendar.Unit.hour , NSCalendar.Unit.day , NSCalendar.Unit.weekOfYear , NSCalendar.Unit.month , NSCalendar.Unit.year , NSCalendar.Unit.second], from: earliest, to: latest, options: NSCalendar.Options())
        
        if (components.year! >= 2) {
            return "\(components.year!) years"
        } else if (components.year! >= 1){
            if (numericDates){
                return "1 year"
            } else {
                return "Last year"
            }
        } else if (components.month! >= 2) {
            return "\(components.month!) months"
        } else if (components.month! >= 1){
            if (numericDates){
                return "1 month"
            } else {
                return "Last month"
            }
        } else if (components.weekOfYear! >= 2) {
            return "\(components.weekOfYear!) weeks"
        } else if (components.weekOfYear! >= 1){
            if (numericDates){
                return "1 week "
            } else {
                return "Last week"
            }
        } else if (components.day! >= 2) {
            return "\(components.day!)d"
        } else if (components.day! >= 1){
            if (numericDates){
                return "1d"
            } else {
                return "Yesterday"
            }
        } else if (components.hour! >= 2) {
            return "\(components.hour!)h"
        } else if (components.hour! >= 1){
            if (numericDates){
                return "1h"
            } else {
                return "An hour ago"
            }
        } else if (components.minute! >= 2) {
            return "\(components.minute!)m"
        } else if (components.minute! >= 1){
            if (numericDates){
                return "1m"
            } else {
                return "A minute ago"
            }
        } else if (components.second! >= 3) {
            return "\(components.second!)s"
        } else {
            return "txt_just_now".localized()
        }
        
    }
        class func isConnectedToInternet() ->Bool
        {
            return NetworkReachabilityManager()!.isReachable
        }
}

extension UIViewController{
    //MARK: TextFild delegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool    {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: Method to hide keyboard
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
