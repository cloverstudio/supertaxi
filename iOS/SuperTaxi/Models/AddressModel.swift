//
//  AddressModel.swift
//  SuperTaxi
//
//  Created by Jurica Mlinarić on 21/07/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import Foundation
import ObjectMapper

public class AddressModel: Mappable {

    var address: String!
    var location: [Double]!
    
    required public init?(_ map: Map) {
        
    }
    
    public func mapping(map: Map) {
        address <- map["address"]
        location <- map["location"]
        
    }
}