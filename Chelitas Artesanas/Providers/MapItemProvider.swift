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

@objc protocol MapItemProviderProtocol {
    var title: String { get }
    var lat: Double { get }
    var lon: Double { get }
}

class MapItemProvider: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String
    let subtitle: String
 
    required init(title: NSString, subtitle: NSString, latitude: Double, longitude: Double) {
        self.title      = title
        self.subtitle   = subtitle
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var mapItem: MKMapItem {
        var item: MKMapItem
        var placemark: MKPlacemark
            
        let addressDictionary = [String:String]()
            
        placemark = MKPlacemark(coordinate: self.coordinate, addressDictionary: addressDictionary)
        
        item = MKMapItem(placemark: placemark)
        item.name = self.title
            
        return item
    }
    
    // TODO: Update this to regular MKAnnotationView after I get the images
    func view(#mapView: MKMapView!) -> MKAnnotationView {
        let identifier = "MapItemProviderIdentifier"
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as MKPinAnnotationView?
        
        if let view = annotationView {
            return dressedAnnotationView(view)
        } else {
            let view = MKPinAnnotationView(annotation: self, reuseIdentifier: identifier)
            return dressedAnnotationView(view)
        }
    }
    
    
    // MARK: - Private
    
    private func dressedAnnotationView(view: MKAnnotationView!) -> MKAnnotationView! {
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: 0, y: -5)
        view.image = UIImage(named: "Map Pin Icon")
        
        let disclosureButton = UIButton.buttonWithType(.DetailDisclosure) as UIView
        view.rightCalloutAccessoryView = disclosureButton
        
        return view
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
