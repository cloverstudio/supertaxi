//
//  DriverInfoModel.swift
//  SuperTaxi
//
//  Created by Jurica Mlinarić on 25/07/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import Foundation
import ObjectMapper

public class DriverInfoModel: Mappable {
    
    var id: String!
    var name: String!
    var car_type: String!
    var car_registration: String!
    var fee_start: NSInteger!
    var fee_km: NSInteger!
    var telNum: String!
    var fileId: String!
    var averageRate: Float!
    
    
    required public init?(_ map: Map) {
        
    }
    
    
    init(id:String, car_type: String, car_registration: String, fee_start: NSInteger, fee_km: NSInteger, telNum: String, fileId: String, averageRate:Float){
        self.id = id
        self.car_type = car_type
        self.car_registration = car_registration
        self.fee_start = fee_start
        self.fee_km = fee_km
        self.telNum = telNum
        self.fileId = fileId
        self.averageRate=averageRate
        
    }
    
    init(id:String, name: String, car_type: String, car_registration: String, fee_start: NSInteger, fee_km: NSInteger) {
        self.id = id
        self.name = name
        self.car_type = car_type
        self.car_registration = car_registration
        self.fee_start = fee_start
        self.fee_km = fee_km
        self.telNum = nil
        self.fileId = nil
        self.averageRate = nil
    }
    
    public func mapping(map: Map) {
        id <- map["_id"]
        name <- map["name"]
        car_type <- map["car_type"]
        car_registration <- map["car_registration"]
        fee_start <- map["fee_start"]
        fee_km <- map["fee_km"]
        telNum <- map["telNum"]
        fileId <- map["fileid"]
        averageRate <- map["averageRate"]
        
    }
}
