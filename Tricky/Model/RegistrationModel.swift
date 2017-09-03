//
//  RegistrationModel.swift
//  Tricky
//
//  Created by gopal sara on 03/09/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
import ObjectMapper

class RegistrationModel: Mappable {
    
    var responseData    : [LoginResposeDataModel]? = []
    var status    : String?
    var responseCode    : String?
    var responseMessage    : String?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    
    func mapping(map: Map) {
        responseData    <- map["responseData"]
        status         <- map["status"]
        responseMessage      <- map["responseMessage"]
        responseCode       <- map["responseCode"]
    }
}
