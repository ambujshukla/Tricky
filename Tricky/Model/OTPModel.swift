//
//  OTPModel.swift
//  Tricky
//
//

import UIKit
import ObjectMapper


class OTPModel: Mappable {

    var status    : String?
    var responseCode    : String?
    var responseMessage    : String?
    var otp : String?
    var info_msg : String?

    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        status         <- map["status"]
        responseMessage      <- map["responseMessage"]
        responseCode       <- map["responseCode"]
        otp       <- map["otp"]
        info_msg       <- map["info_msg"]

        
    }
}
