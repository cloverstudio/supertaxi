//
//  UserModel.swift
//  SuperTaxi
//
//  Created by Jurica Mlinarić on 13/07/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

open class UserModel: Mappable {

    var _v: NSInteger!
    var _id: String!
    var created: CLong!
    var email: String!
    var password: String!
    var token: String!
    var token_generated: String!
    var avatar: JSON!
    var driver: DriverInfoModel!
    var user: UserInfoModel!
    var telNum: String!
    
    required public init?(_ map: Map) {
        
    }
    
    open func mapping(_ map: Map) {
        _v <- map["_v"]
        _id <- map["_id"]
        created <- map["created"]
        email <- map["email"]
        password <- map["password"]
        token <- map["token"]
        token_generated <- map["token_generated"]
        avatar <- map["avatar"]
        driver <- map["driver"]
        user <- map["user"]
        telNum <- map["telNum"]
        
    }

}
