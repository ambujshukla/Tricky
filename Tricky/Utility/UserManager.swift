//
//  UserManager.swift
//  Tricky
//
//  Created by gopal sara on 03/09/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit

class UserManager: NSObject {

    
    
    //MARK :- Shared Instance
    var userId : String?
    var userUrl : String?
    var language : String?
    var mobileNo : String?
    var name : String?
    var profilePic : String?
    var receiveMsgCount : String?
    var sentMsgCount : String?

    
    class var  sharedUserManager: UserManager {
        struct Static
        {
            static var instance : UserManager? = nil
        }
        
        if !(Static.instance != nil) {
            
            Static.instance = UserManager()
        }
        
        return Static.instance!
    }
  
    func doSetLoginData (userData : LoginResposeDataModel)
    {
        self.userId = userData.userId
        self.userUrl = userData.Link
        self.language = userData.language
        self.mobileNo = userData.mobileNo
        self.name = userData.name
        self.profilePic = userData.profilePic
        
        CommonUtil.setData("userId", value: self.userId! as NSString)
        CommonUtil.setData("userUrl", value: self.userUrl! as NSString)
        CommonUtil.setData("language", value: self.language! as NSString)
        CommonUtil.setData("mobileNo", value: self.mobileNo! as NSString)
        CommonUtil.setData("name", value: self.name! as NSString)
        CommonUtil.setData("profilePic", value: self.profilePic! as NSString)


    }
  
    func doSetReceiveMsgAndSentMessage(strSentMsg : String , strReceiveMsg : String){
      self.receiveMsgCount = strReceiveMsg
      self.sentMsgCount = strSentMsg
    }
    
    
    
}
