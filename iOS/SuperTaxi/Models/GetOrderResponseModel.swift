//
//  GetOrderResponseModel.swift
//  SuperTaxi
//
//  Created by Jurica Mlinarić on 26/07/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import Foundation
import ObjectMapper

class GetOrderResponseModel : Mappable {

    var code: Int?
    var time: Int?
    var data: GetOrderModel?
    
    required init?(_ map: Map) {
        
    }
    
    func mapping(_ map: Map) {
        code <- map["code"]
        data <- map["data"]
        time <- map["time"]
        
    }
    
}
