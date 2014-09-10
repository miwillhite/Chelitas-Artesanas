//
//  Vendor.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/9/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import MapKit
import Realm

class Vendor: RLMObject {
    var title = ""
    var lat: Double = 0.0
    var lon: Double = 0.0
    var stockings = RLMArray(objectClassName: Stocking.className())
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        set(coordinate) {
            self.lat = coordinate.latitude
            self.lon = coordinate.longitude
        }
    }
}