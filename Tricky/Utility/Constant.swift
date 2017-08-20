//
//  Constant.swift
//  PhotoSpring
//
//  Created by gopalsara on 10/08/16.
//  Copyright © 2016 CDN Software Solutions Indore. All rights reserved.
//

import Foundation
import UIKit

// Server constant
//let kBaseUrl  = "http://192.168.0.77/ps-production/public/api/v1/"
let kBaseUrl = "https://api.photospring.com/api/v1/"
//let kBaseUrl = "http://staging.photospring.com/api/v1/"

let kLoginService        = "users/login"
let kReistration         = "users/register"
let kUserVarification    = "users/checkVerfication"
let kResendVarification  = "resendVerification"
let kUpdateProfile       = "users/updateProfile"
let kForgotPassword      = "users/forgotPassword"
let kFrame               = "users/frame"
let kRestPassword        = "resetPassword"
let kUserProfile         = "users/profile"
let kUserFrameList       = "frame/list"
let kSharePhoto           = "users/sharePhotos"
let kUserFrameConnList    = "frame/connection"
let KuserLogs             = "userLogs"
let KClientFrameConnection = "getFrameConnectionClient"
let KuserLogout           = "users/logout"
let KusersDeleteFrameClient    = "users/deleteFrameClient"
let Kterms                = "terms"
let Kprivacy              = "privacy"
let KinviteFriend         = "inviteFriendViaEmail"


// Custom Cell Identifier
let cellPopup = "popUpCell"
let App_Name = "Photo Spring"

let UNIVERSAL_WIDTH = UIScreen.main.bounds.size.width
let UNIVERSAL_HEIGHT = UIScreen.main.bounds.size.height

let WIDTH_FACTOR: CGFloat = UNIVERSAL_WIDTH/320.0
let HEIGHT_FACTOR : CGFloat = UNIVERSAL_HEIGHT/568.0

////// ******************* NOTIFICATION NAME ************************************////

let GO_TO_LETS_SEND_NOTIFIER = "GoToLetsSendViewController"
let GET_PUSH_NOTIFIER = "GetPush"
let DATA_FETCH_COMPELETION_NOTIFIER = "DataFetchCompletionNotificationFromDB"
let SELECTED_FRAME_NOTIFIER = "GetSelectedFrame"
let REFRESH_SETTING_DATA = "RefreshSettingData"
let WIFIORCELULAR = "WifiOrCelular"
let CELULAR_MSG_ALERT = "Your current settings will allow photos from this device to automatically be uploaded to the frame via Wi-Fi or Cellular. This may affect your cell phone data plan"

////////*******************  NAVIGATION TITLE NAME **********************************//

let ADD_FRIEND_TITLE = "Add Frame"
let VERIFY_EMAIL_TITLE = "Verify your email"
let FORGOT_TITLE = "Forgot Password"
let MANAGE_FRMAE_TITLE = "Manage Frames"
let GIVE_THEM_TITLE = "Connect via Frame Code"
let LOGIN_TITLE = "Login"
let FRMAE_SETUP = "Frame Setup"
let FRIEND_FRMAE_TITLE = "Friend's frames"
let ADD_TITLE = "Add Title"
let SEND_PHOTO_TITLE = "Send Photos"
let SELECT_RECIPIENT_TITLE = "Select Recipients"
let SETUP_TITLE = "Setup your profile"
let RESET_PASS_TITLE = "Reset Password"
let SETTING_TITLE = "Settings"
let SIGNUP_TITLE = "Sign up"
let TERM_SERVICE_TITLE = "Terms of Services"
let TERM_POLICY_TITLE = "Terms and Policy"
let FRAME_TITLE = "Frame"
//**********************************************ViewControllerIdentifier **************************************************************//


let HOMEVIEW = "HomeViewController"
let EMAIL_VERIFY_VIEW = "EmailVerifyViewController"
let PROFILE_SETUP = "ProfileSetupViewController"
let ADD_FRAME_VIEW = "AddFrameCodeViewController"
let REENTER_VIEW = "ReEnterPasswordViewController"
let TERM_COND_VIEW = "TermsAndPolicyViewController"
let MANAGE_FRAME_SETUP = "ManageFrameSetupViewController"
let LETS_SEND_VIEW =  "LetsSendViewController"
let OWNER_FRAME_VIEW = "OwnerFrameViewController"
let MANAGE_FRAME_VIEW = "ManageFrameViewController"
let FRAME_VIEW = "FrameViewController"
let VIEW_CTR = "ViewController"
let PHOTO_SEND_VIEW = "PhotoSendViewController"
let HOME_POPUP_VIEW = "HomePopOverViewController"
let PROFILE_VIEW = "ProfileViewController"
let SETTING_VIEW = "SettingViewController"
let DEVICE_VIEW = "DeviceViewController"
let FRIEND_VIEW = "FriendsViewController"
let ACCOUNT_VIEW = "AccountViewController"
let GIVETHEM_VIEW = "GiveThemFrameCodeController"
let PHOTO_SENDING_VIEW = "PhotoSendingViewController"
let SEARCH_VIEW = "SearchFrameViewController"
let SETTINEG_DETAIL = "SettingDetailViewController"
let TERM_VIEW = "T_CViewController"
let FORGOT_VIEW = "ForgotPasswordViewController"
let LOGIN_VIEW = "LoginViewController"
let SIGNUP_VIEW = "SignUpViewController"
let REQUEST_SEND_VIEW = "RequestSentViewController"

//*********************** Error Message ******************************************//

let NO_FRAME_ALERT = "No frame added"
let NETWORK_ERROR = "Please check internet connection"
let NO_FRAME_AVAILABLE = "Frame not available"
let NO_FRAME_SELECTED = "Frame not selected"
let FRAME_DELETE = "frame deleted successfully"
let PROFILE_ALERT = "Please select profile image"

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

let DeleteFrame = "Delete Frame"
let Delete_Frame_Message = "If you delete this frame you will no longer be able to send photos or videos to it."
let AlertTitle = "Delete Friend"
let AlertMessage = "Will be disconnected from this frame and will no longer be able to send photos or videos?"
let AlertDelete = "Delete"
let AlertCancel = "Cancel"
let TERM_CONDITION_TITLE = "termAndConditions"
let Alert_OK = "OK"
let SERVER_ERROR = "PhotoSpring is having problems reaching its servers in the Cloud. Please check your Internet connection and try again"
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
    return UIColor.init(colorLiteralRed: red, green: green, blue: blue, alpha: 1.0)
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
let BLOCK_ICON = "blockicon"
let SEARCH_ICON = "searchicon"

let OTP_BG = "OTP_BG"

let BACK_BUTTON = "backbutton"
let CHECKBOX_UNSELECTED = "checkbox_unselected"
let CHECKBOX_SELECTED = "checkbox_selected"
let EDIT_ICON = "editicon"

//Title
let TITLE_LOGIN = "Login"
let SIGNUP_LOGIN = "Signup"




