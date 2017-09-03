//
//  RegResponseDataModel.swift
//  Tricky
//
//  Created by gopal sara on 03/09/17.
//  Copyright © 2017 Gopal Sara. All rights reserved.
//

import UIKit
import ObjectMapper

class RegResponseDataModel:  Mappable {
    
    var Link : String?
    var language : String?
    var mobileNo : String?
    var name  : String?
    var profilePic : String?
    var userId    : String?
    
    required init?(map: Map) {
        mapping(map: map)
    }
    
    
    func mapping(map: Map) {
        Link    <- map["Link"]
        language         <- map["language"]
        mobileNo      <- map["mobileNo"]
        name       <- map["name"]
        profilePic    <- map["profilePic"]
        userId         <- map["userId"]
        
    }
}
