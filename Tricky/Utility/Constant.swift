//
//  Constant.swift
//

import Foundation
import UIKit
import AAPopUp


extension AAPopUp {
    
    static let demo1 = AAPopUps<String? ,String>(identifier: "PopupViewController")
    static let demo2 = AAPopUps<String? ,String>("Main" ,identifier: "PopupViewController")
}


// Server constant

let kBaseUrl = "http://www.trickychat.com/api/"

let Font_Robitto_Regular = "Roboto-Regular"
let Font_Robitto_Medium = "Roboto-Medium"
let Font_Robitto_Light = "Roboto-Light"




// Custom Cell Identifier

let UNIVERSAL_WIDTH = UIScreen.main.bounds.size.width
let UNIVERSAL_HEIGHT = UIScreen.main.bounds.size.height

let WIDTH_FACTOR: CGFloat = UNIVERSAL_WIDTH/320.0
let HEIGHT_FACTOR : CGFloat = UNIVERSAL_HEIGHT/568.0

////// ******************* NOTIFICATION NAME ************************************////


////////*******************  NAVIGATION TITLE NAME **********************************//

//**********************************************ViewControllerIdentifier **************************************************************//



//*********************** Error Message ******************************************//


//************************ Universal Images ***********************************//

let BACK_IMG = "back.png"
let PROFILE_ICON = "profile_place_icon.png"

//*********************************************** FONT NAME ****************************** //

let Font_Helvetica_Bold       = "Helvetica-Bold"
let Font_Helvetica            = "Helvetica"
let Font_Helvetica_Neue       =  "Helvetica Neue"
let FONT_ROBOTO_REGULAR       =  "Roboto-Regular"
let FONT_ROBOTO_SEMIBOLD      = "Roboto-Bold"
let FONT_ROBOTO_LIGHT         = "Roboto-Light"
let FONT_ROBOTO_ITALIC        = "Roboto-Italic"
let FONT_ROBOTO_BLACK_ITALIC  = "Roboto-BlackItalic"
let FONT_ROBOTO_BOLD_ITALIC   = "Roboto-BoldItalic"



let FONT_SIZE_8        = 8
let FONT_SIZE_9        = 9
let FONT_SIZE_10       = 10
let FONT_SIZE_11       = 11
let FONT_SIZE_12       = 12
let FONT_SIZE_13       = 13
let FONT_SIZE_14       = 14
let FONT_SIZE_15       = 15
let FONT_SIZE_16       = 16
let FONT_SIZE_17       = 17
let FONT_SIZE_18       = 18
let FONT_SIZE_19       = 19
let FONT_SIZE_20       = 20
let FONT_SIZE_21       = 21
let FONT_SIZE_22       = 22
let FONT_SIZE_23       = 23
let FONT_SIZE_24       = 24
let FONT_SIZE_25       = 25




///////////////////////////////////////  Hard code deviceToken /////////////////////////////

let HARD_CODE_DEVICETOEKN = "666485c3ad9e3e171bbfe29ab1c56d24361438689344409dd30995de815cddbb"


/////////////////////////////////// Alert Title And Message /////////////////////////////

// ****************************************************************************************** //

/**
 *  /////////////////////////////////////////// MAKING DYNAMIC DICTIONARY FOR PARAMETER ////
 */

func userLoginDictionary(_ userName: String , password: String) -> Dictionary<String , AnyObject> {
    let dict = ["email" : userName , "password" : password]
    return dict as Dictionary<String, AnyObject>
}



func userRegisterDictionary(_ userEmail:String, userName: String, password: String , firstName: String , lastName: String ) -> Dictionary<String, AnyObject>{
    let dict =  ["email" : userEmail, "password": password, "username": userName , "firstName" : firstName , "lastName" : lastName]
    return dict as Dictionary<String, AnyObject>
}

func userVarifyDictionary (_ secretToken : String)-> Dictionary<String, AnyObject> {
    let dict =  ["secretToken" : secretToken]
    return dict as Dictionary<String, AnyObject>
    
}

func userFrameCodeDictionry (_ frameId : String )-> Dictionary<String, AnyObject>
{
    let dict =  ["frameId" : frameId]
    return dict as Dictionary<String, AnyObject>
    
}

func clientFrameCodeDictionry (_ frameId : String )-> Dictionary<String, AnyObject>
{
    let dict =  ["frame_code" : frameId]
    return dict as Dictionary<String, AnyObject>
    
}


func userSetUpProfileDictionry (_ email : String , fullName : String , user_picture : String, firstName :String)-> Dictionary<String, AnyObject>
{
    let dict =  ["fullName" : fullName , "email" : email , "firstName" : firstName ,"user_picture" : user_picture]
    return dict as Dictionary<String, AnyObject>
}

func userForgetPasswordDictionary (_ email : String)-> Dictionary<String, AnyObject> {
    let dict =  ["email" : email]
    return dict as Dictionary<String, AnyObject>
}

func userResetPasswordDictionry (_ oldPassword : String , newPassword : String )-> Dictionary<String, AnyObject>
{
    let dict =  ["oldPassword" : oldPassword , "newPassword" : newPassword]
    return dict as Dictionary<String, AnyObject>
    
}

func color(red : Float , green : Float , blue : Float) -> UIColor
{
    return UIColor.init(colorLiteralRed: red/255, green: green/255, blue: blue/255, alpha: 1.0)
}

func convertDateTOString (date : Date) -> String
{
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let strDate = dateFormatter.string(from: date)
    return strDate
}

//////Tricky

//Images
let MOBILE_ICON = "mobileicon"
let PASSWORD_ICON = "passwordicon"
let LOGIN_BG = "loginBG"
let SIGNUP_BG = "signUpBG"
let FOROGT_PASSWORD_BG = "forgotPassword_BG"
let BLOCK_LIST_BG  = "blockUserBG"
let PROFILE_BG = "ProfileBG"
let CHAT_BG = "chatScreenBG"
let BLOCK_ICON = "blockicon"
let SEARCH_ICON = "searchicon"
let SEND_ICON = "sendicon"
let REFRESH_ICON = "refreshicon"
let NEW_PASSWORD = "6background"
let ALL_CONTACTS_BG = "allcontbackground"
let POST_DETAIL_BG = "postdetailbackground"
let MESSAGE_SEND_BG = "msgsendbackground"
let CREATE_POST_BG = "1background"

let SEND_MESSAGE_PURPLE = "sendmsgicon_purple"

let OTP_BG = "OTP_BG"
let OTP_FORGOT_BG = "OtpForgot_Verify"

let BACK_BUTTON = "backbutton"
let CHECKBOX_UNSELECTED = "checkbox_unselected"
let CHECKBOX_SELECTED = "checkbox_selected"
let EDIT_ICON = "editicon"

//Title
let TITLE_LOGIN = "Login"
let SIGNUP_LOGIN = "Signup"


let METHOD_LOGIN = "login"
let METHOD_OTP = "otp_generate"

