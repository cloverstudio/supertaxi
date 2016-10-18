//
//  OrderResponseModel.swift
//  SuperTaxi
//
//  Created by Jurica Mlinarić on 21/07/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import Foundation
import ObjectMapper
import SwiftyJSON

public class OrderResponseModel: Mappable {
    
    var code: NSInteger!
    var data: JSON!
    var time: CLong!
    
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        code <- map["code"]
        data <- map["data"]
        time <- map["time"]
        
    }
}