//
//  BaseModel.swift
//  SuperTaxi
//
//  Created by Jurica Mlinarić on 13/07/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import Foundation
import ObjectMapper

open class BaseModel: Mappable {
    
    var code: NSInteger!
    var time: CLong!
    
    required public init?(map: Map) {
        
    }
    
    open func mapping(map: Map) {
        code <- map["code"]
        time <- map["time"]
    }
}
