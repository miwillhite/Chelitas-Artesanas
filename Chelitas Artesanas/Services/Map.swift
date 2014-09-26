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
import Realm

class Map: NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
    
    let view: MKMapView
    var userLocation: CLLocationCoordinate2D?

    
    // MARK: Private Properties
    
    private let locationManager: CLLocationManager
    
    
    // MARK: - Object Lifecycle
    
    override init() {
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
    
    func requestAuthorization(authorizationBlock: (granted: Bool, map: Map) -> Void) {
        locationManager.requestWhenInUseAuthorization()
        // TODO: See if I can make this a true callback
        authorizationBlock(granted: true, map: self)
    }

    func addLocations(locations: [AnyObject]) {
        var mapItems = [MapItemProvider]()
        
        for location in locations {
            if let vendor = location as? Vendor {
                mapItems.append(
                    MapItemProvider(
                        title: vendor.title,
                        subtitle: "",
                        latitude: vendor.lat,
                        longitude: vendor.lon)
                )
            }
        }
        
        self.view.addAnnotations(mapItems)
    }
    
    
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
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? MapItemProvider {
            return annotation.view(mapView)
        }
        return nil
    }
}


// MARK: - Private
// MARK: -

private extension Map {
    
    func makeRegion(location: CLLocationCoordinate2D) -> MKCoordinateRegion? {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        return MKCoordinateRegion(center: location, span: span)
    }
    
    func startLocationManager() {
        view.showsUserLocation = true
        
        // TODO: Check to make sure location services are enabled prior to starting
        locationManager.startUpdatingLocation()
    }
}

