//
//  MapItemProvider.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/26/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import MapKit
import AddressBook

class MapItemProvider: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String
    let subtitle: String
 
    required init(title: NSString, subtitle: NSString, latitude: Double, longitude: Double) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    // TODO: Need to cache this?
    var mapItem: MKMapItem {
        let addressDictionary = [
            kABPersonAddressCountryKey  : "EC",
            kABPersonAddressCityKey     : "Quito"
            ]
            
            var placemark: MKPlacemark
            placemark = MKPlacemark(coordinate: self.coordinate, addressDictionary: addressDictionary)
            
            var item = MKMapItem(placemark: placemark)
            item.name = self.title
            return item
    }
}

/* SUBTITLE

This could be generated with an Enum if I start to use different representations for bars vs markets

let breweryNames = vendor.breweriesAsArray.map { $0.name }
var subtitle = "We've got no beer 😩"

if !breweryNames.isEmpty {
subtitle = "We've got beer from: " + breweryNames.combine(", ")
}
*/
