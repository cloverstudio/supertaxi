//
//  DriverInfoModel.swift
//  SuperTaxi
//
//  Created by Jurica Mlinarić on 25/07/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import Foundation
import ObjectMapper

open class DriverInfoModel: Mappable {
    
    var name: String!
    var car_type: String!
    var car_registration: String!
    var fee_start: NSInteger!
    var fee_km: NSInteger!
    
    required public init?(_ map: Map) {
        
    }
    
    init(name: String, car_type: String, car_registration: String, fee_start: NSInteger, fee_km: NSInteger){
        self.name = name
        self.car_type = car_type
        self.car_registration = car_registration
        self.fee_start = fee_start
        self.fee_km = fee_km
    }
    
    open func mapping(_ map: Map) {
        name <- map["name"]
        car_type <- map["car_type"]
        car_registration <- map["car_registration"]
        fee_start <- map["fee_start"]
        fee_km <- map["fee_km"]
    }
}
