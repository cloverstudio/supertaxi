//
//  GetOrderModel.swift
//  SuperTaxi
//
//  Created by Jurica Mlinarić on 26/07/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import Foundation
import ObjectMapper

class GetOrderModel: Mappable {
    
    var userId: String?
    var createOrderTs: Int?
    var crewNum: Int?
    var _id: String?
    var __v: Int?
    var to: AddressModel?
    var from: AddressModel?
    var user: UserModel?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(map: Map) {
        userId <- map["userId"]
        createOrderTs <- map["crewNum"]
        crewNum <- map["crewNum"]
        _id <- map["_id"]
        __v <- map["__v"]
        to <- map["to"]
        from <- map["from"]
        user <- map["user"]
    }
}
