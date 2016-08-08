//
//  UserInfoModel.swift
//  SuperTaxi
//
//  Created by Jurica Mlinarić on 25/07/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import Foundation
import ObjectMapper

public class UserInfoModel: Mappable {
    
    var name: String!
    var age: NSInteger!
    var note: String!
    
    
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        name <- map["name"]
        age <- map["age"]
        note <- map["note"]
        
    }
}