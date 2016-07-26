//
//  OrderModel.swift
//  SuperTaxi
//
//  Created by Jurica Mlinarić on 21/07/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import Foundation
import ObjectMapper

public class OrderModel: Mappable {
    
//    var __v: NSInteger?
    var _id: String?
//    var createOrderTs: CLong?
//    var crewNum: NSInteger?
//    var from: AddressModel?
//    var to: AddressModel?
//    var userId: String?
    
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
//        __v <- map["__v"]
        _id <- map["_id"]
//        createOrderTs <- map["createOrderTs"]
//        crewNum <- map["crewNum"]
//        from <- map["from"]
//        to <- map["to"]
//        userId <- map["userId"]
    }
    
}