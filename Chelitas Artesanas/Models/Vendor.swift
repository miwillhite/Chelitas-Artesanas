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
import AddressBook

class Vendor: RLMObject, MKAnnotation {
    dynamic var id              = ""
    dynamic var title           = ""
    dynamic var subtitle        = ""
    dynamic var lat: Double     = 0.0
    dynamic var lon: Double     = 0.0
    dynamic var stockings       = RLMArray(objectClassName: Stocking.className())
    
    override class func primaryKey() -> String! {
        return "id"
    }
    
    /* SUBTITLE
        let breweryNames = vendor.breweriesAsArray.map { $0.name }
        var subtitle = "We've got no beer 😩"
        
        if !breweryNames.isEmpty {
            subtitle = "We've got beer from: " + breweryNames.combine(", ")
        }
    */
    
    dynamic var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
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