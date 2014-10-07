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
    var userCoordinate: CLLocationCoordinate2D?

    
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
    
    
    // MARK: - Location Management
    
    func locateUser() -> CLLocationCoordinate2D? {
        if let coord = userCoordinate {
            view.setRegion(makeRegion(coord)!, animated: true)
            return coord
        }
        return nil
    }
    
    func requestAuthorization(authorizationBlock: (granted: Bool, map: Map) -> Void) {
        locationManager.requestWhenInUseAuthorization()
        // TODO: See if I can make this a true callback
        authorizationBlock(granted: true, map: self)
    }
    
    // FIXME: This is awesomely horrible...save it for another day
    func syncLocations(locations: [AnyObject]) {
        self.view.removeAnnotations(self.view.annotations)
        self.addLocations(locations)
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case .AuthorizedWhenInUse:
            startLocationManager()
        default:
            // Present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openURL: and UIApplicationOpenSettingsURLString
            println("\(__FUNCTION__) Pending implementation")
        }
    }
    
    
    // MARK: - MKMapViewDelegate

    var token: dispatch_once_t = 0
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        userCoordinate = userLocation.coordinate
        
        // Find the user
        dispatch_once(&token, { [weak self] () -> Void in
            if let strongSelf = self {
                strongSelf.locateUser()
            }
        })
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        if let annotation = annotation as? MapItemProvider {
            return annotation.view(mapView: mapView)
        }
        return nil
    }
}


// MARK: - Private
// MARK: -

private extension Map {
    
    func addLocations(locations: [AnyObject]) {
        var mapItems = [MapItemProvider]()
        
        for location in locations {
            if let loc = location as? MapItemProviderProtocol {
                mapItems.append(
                    MapItemProvider(
                        title       : loc.title,
                        subtitle    : "",
                        latitude    : loc.lat,
                        longitude   : loc.lon
                    )
                )
            }
        }
        
        self.view.addAnnotations(mapItems)
    }
    
    func makeRegion(location: CLLocationCoordinate2D) -> MKCoordinateRegion? {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        return MKCoordinateRegion(center: location, span: span)
    }
    
    func startLocationManager() {
        view.showsUserLocation = true
        locationManager.startUpdatingLocation()
    }
}

