//
//  Map.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/6/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import MapKit

extension Array {
    func combine(separator: String) -> String {
        var str: String = ""
        for (idx, item) in enumerate(self) {
            str += "\(item)"
            if idx < self.count - 1 {
                str += separator
            }
        }
        return str
    }
}

class VendorMap: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let view: MKMapView
    let locationManager: CLLocationManager
    var userLocation: CLLocationCoordinate2D?
    
    override init() {
        self.view = MKMapView()
        self.locationManager = CLLocationManager()
        super.init()
        
        // Counting on the view actually being there
        self.setup()
    }
    
    private func setup() -> () {
        
        view.delegate = self

        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        // Movement threshhold
        locationManager.distanceFilter = 30
    }
    
    func startLocationManager() -> () {
        view.showsUserLocation = true

        // TODO: Check to make sure location services are enabled prior to starting
        locationManager.startUpdatingLocation()
        for vendorObject in Vendor.allObjects() {
            if let vendor = vendorObject as? Vendor {
                let locationAnnotation = MKPointAnnotation()
                locationAnnotation.coordinate = vendor.coordinate
                locationAnnotation.title = vendor.title
                
                var breweryNames = [String]()
                for stockingObject in vendor.stockings {
                    if let stocking = stockingObject as? Stocking {
                        breweryNames.append(stocking.brewery.name)
                    }
                }
                
                var subtitle = "We've got no beer 😩"
                if !breweryNames.isEmpty {
                    subtitle = "We've got beer from: " + breweryNames.combine(", ")
                }
                locationAnnotation.subtitle = subtitle
                
                view.addAnnotation(locationAnnotation)
            }
        }
    }
    
    
    
    // MARK: CLLocationManagerDelegate
    
    // QUESTION: Do I need this and the mapView didUpdateUserLocation methods both?
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        let location: CLLocation = locations.last as CLLocation
        self.view.setRegion(makeRegion(location.coordinate)!, animated: true)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedWhenInUse:
            startLocationManager()
        default:
            println("Other: \(status)")
        }
    }
    
    private func makeRegion(location: CLLocationCoordinate2D) -> MKCoordinateRegion? {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        return MKCoordinateRegion(center: location, span: span)
    }
    

    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        view.setRegion(makeRegion(userLocation.coordinate)!, animated: true)
    }
}