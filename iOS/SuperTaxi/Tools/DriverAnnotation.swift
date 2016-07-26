//
//  DriverAnnotation.swift
//  SuperTaxi
//
//  Created by Jurica Mlinarić on 25/07/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import Foundation
import MapKit
import CoreAudioKit

public class DriverAnnotation: NSObject, MKAnnotation {
    
    public var title: String?
    public var coordinate: CLLocationCoordinate2D
    var info: String
    
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
        
    }

}
