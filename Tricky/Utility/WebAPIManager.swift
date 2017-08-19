//
//  WebAPIManager.swift
//  inDJ
//
//  Created by gopalsara on 27/07/17.
//  Copyright © 2017 padio. All rights reserved.
//

import UIKit
import Alamofire

class WebAPIManager: NSObject {


    //MARK :- Shared Instance
    
    class var  sharedWebAPIMAnager: WebAPIManager {
        struct Static
        {
            static var onceToken : Int = 0
            static var instance : WebAPIManager? = nil
        }
        
        if !(Static.instance != nil) {
            
            Static.instance = WebAPIManager()
        }
        
        return Static.instance!
    }

    
    func doCallWebAPIForPOST (strURL : String , strServiceName : String , parameter : [String : Any] , success: @escaping (_ obj : [String: Any]) -> Void , failure: @escaping (_ error: NSError?) -> Void)
    {
       let completeURL = "\(strURL)\(strServiceName)"
      
        Alamofire.request(completeURL, method: .post, parameters: parameter, encoding: URLEncoding.default , headers: nil).responseJSON { response in
        
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
                success(json as! [String : Any])
            }
            else{
                failure(response.result.error! as NSError?)
            }
        }
    }
    
    
    func doCallWebAPIForGET(strURL : String , strServiceName : String , success: @escaping (_ obj : [String: Any]) -> Void , failure: @escaping (_ error: NSError?) -> Void) -> Void {
        
        let completeURL = "\(strURL)\(strServiceName)"
        print("this is complete URL \(completeURL)")
        
        Alamofire.request("\(strURL)\(strServiceName)").responseJSON { response in
            print("Request: \(String(describing: response.request))")   // original url request
            print("Response: \(String(describing: response.response))") // http url response
            print("Result: \(response.result)")                         // response serialization result
            
            if let json = response.result.value {
            success(json as! [String : Any])
            }
            else{
                failure(response.result.error! as NSError?)
            }
            
//            if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
//                print("Data: \(utf8Text)") // original server data as UTF8 string
//            }
        }
    }
    
}
