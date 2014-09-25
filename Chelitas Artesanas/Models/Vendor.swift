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
    dynamic var title = ""
    dynamic var lat: Double = 0.0
    dynamic var lon: Double = 0.0
    dynamic var stockings = RLMArray(objectClassName: Stocking.className())
    
    dynamic var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        }
        set(coordinate) {
            self.lat = coordinate.latitude
            self.lon = coordinate.longitude
        }
    }
    
    var breweriesAsArray: [Brewery] {
        get {
            var breweries = [Brewery]()
            for stocking in self.stockings {
                if let stocking = stocking as? Stocking {
                    breweries.append(stocking.brewery)
                }
            }
            return breweries
        }
    }
}