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
    
    // FIXME: This is awesomely horrible...save it for another day
    func syncLocations(locations: [AnyObject]) {
        self.view.removeAnnotations(self.view.annotations)
        self.addLocations(locations)
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
            // Present an alert indicating location authorization required
            // and offer to take the user to Settings for the app via
            // UIApplication -openURL: and UIApplicationOpenSettingsURLString
            println("\(__FUNCTION__) Pending implementation")
        }
    }
    
    
    // MARK: - MKMapViewDelegate
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        view.setRegion(makeRegion(userLocation.coordinate)!, animated: true)
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
