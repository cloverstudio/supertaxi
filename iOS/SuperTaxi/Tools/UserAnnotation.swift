//
//  UserAnnotation.swift
//  SuperTaxi
//
//  Created by Jurica Mlinarić on 03/08/16.
//  Copyright © 2016 Jensen Pich. All rights reserved.
//

import Foundation
import MapKit
import CoreAudioKit

open class UserAnnotation: NSObject, MKAnnotation {
    
    open var title: String?
    open var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
    }
    
}
