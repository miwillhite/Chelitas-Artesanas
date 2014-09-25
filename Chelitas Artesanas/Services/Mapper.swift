//
//  Map.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/24/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//
//  Responsible for all mapping responsibilities
//

import Foundation
import MapKit

class Mapper: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
//    let mapView: RMMapView

    let view: MKMapView
    
    var userLocation: CLLocationCoordinate2D?
    
    // MARK: MapKit, CLLocationManager
    let locationManager: CLLocationManager
    
    
    // MARK: - Lifecycle
    
    override init() {
//        self.mapView = RMMapVi ew(frame: UIScreen.mainScreen().bounds)
//        mapView.userTrackingMode = RMUserTrackingModeFollow
//        mapView.centerCoordinate = mapView.userLocation.coordinate
//        mapView.tileSource = RMMapboxSource(mapID: "examples.map-zgrqqx0w")
        self.view = MKMapView()
        self.locationManager = CLLocationManager()
        
        super.init()
        
        // Map View
        view.delegate = self
        
        // Location Manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 30 // Movement threshold
    }
    
    func requestAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func renderUserLocation(){}
    func renderLocation(#location: AnyObject){}
    
    
    // MARK: - CLLocationManagerDelegate
    // QUESTION: Do I need both this *and* the mapView:didUpdateUserLocation: methods?
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
    
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        view.setRegion(makeRegion(userLocation.coordinate)!, animated: true)
    }
}


// MARK: - Private
// MARK: -

private extension Mapper {
    
    func makeRegion(location: CLLocationCoordinate2D) -> MKCoordinateRegion? {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        return MKCoordinateRegion(center: location, span: span)
    }
    
    func startLocationManager() {
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
}

