//
//  OTPModel.swift
//  Tricky
//
//  Created by gopal sara on 19/09/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
import ObjectMapper


class OTPModel: Mappable {

    var status    : String?
    var responseCode    : String?
    var responseMessage    : String?
    var otp : String?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    
    func mapping(map: Map) {
        status         <- map["status"]
        responseMessage      <- map["responseMessage"]
        responseCode       <- map["responseCode"]
        otp       <- map["otp"]
        
    }

    
}
