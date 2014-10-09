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

let MapItemProviderAnnotationDisclosureButtonDidTapNotification =
    "MapItemProviderAnnotationDisclosureButtonDidTapNotification"

@objc protocol MapItemProviderProtocol {
    var title: String { get }
    var lat: Double { get }
    var lon: Double { get }
}

extension UIButton {
    class func buttonAsMapAnnotationDisclosure() -> UIButton {
        let button = UIButton.buttonWithType(.DetailDisclosure) as UIButton
        return button
    }
}

class MapItemProvider: NSObject, MKAnnotation {
    let notificationCenter: NSNotificationCenter
    let coordinate: CLLocationCoordinate2D
    let title: String
    let subtitle: String
    
    required init(title: NSString, subtitle: NSString, latitude: Double, longitude: Double, notificationCenter: NSNotificationCenter) {
        self.notificationCenter = notificationCenter
        self.title      = title
        self.subtitle   = subtitle
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
 
    convenience init(title: NSString, subtitle: NSString, latitude: Double, longitude: Double) {
        self.init(title: title, subtitle: subtitle, latitude: latitude, longitude: longitude, notificationCenter: NSNotificationCenter.defaultCenter())
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
    
    func view(#mapView: MKMapView!) -> MKAnnotationView {
        let identifier = "MapItemProviderIdentifier"
        
        var annotationView =
            mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as MKAnnotationView?
        
        if let view = annotationView {
            return dressedAnnotationView(view)
        } else {
            return dressedAnnotationView(
                MKAnnotationView(annotation: self, reuseIdentifier: identifier)
            )
        }
    }
    
    
    // MARK: - Private
    
    private func dressedAnnotationView(view: MKAnnotationView!) -> MKAnnotationView! {
        view.canShowCallout = true
        view.calloutOffset = CGPoint(x: 0, y: -5)
        view.image = UIImage(named: "Map Pin Icon")
        
        let disclosureButton = UIButton.buttonAsMapAnnotationDisclosure()
        disclosureButton.addTarget(self,
            action: "disclosureButtonDidTap:",
            forControlEvents: .TouchUpInside
        )
        view.rightCalloutAccessoryView = disclosureButton
        
        return view
    }
    
    
    // MARK: - Button Handlers
    
    func disclosureButtonDidTap(sender: UIButton!) {
        notificationCenter.postNotificationName(
            MapItemProviderAnnotationDisclosureButtonDidTapNotification,
            object: self
        )
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
