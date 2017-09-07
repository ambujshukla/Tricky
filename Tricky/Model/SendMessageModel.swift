//
//  SendMessageModel.swift
//  Tricky
//
//  Created by gopal sara on 06/09/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
import ObjectMapper


class SendMessageModel: Mappable {

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
