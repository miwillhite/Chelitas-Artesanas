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
    
//    func addLocation(#title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
//        var annotation = MKPointAnnotation()
//        annotation.title = title
//        annotation.subtitle = subtitle
//        annotation.coordinate = coordinate
//
//        view.addAnnotation(annotation)
//    }
    

    func addLocations(locations: [AnyObject]) {
        self.view.addAnnotations(locations)
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

        // YUCK: To all the following
        if let annotation = annotation as? Vendor {
            let kPinIdentifier = "Vendor"
            var pinAnnotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(kPinIdentifier) as MKPinAnnotationView?
            
            if pinAnnotationView != nil {
                // Continue
            } else {
                pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: kPinIdentifier)
                pinAnnotationView?.canShowCallout = true
                pinAnnotationView?.calloutOffset = CGPoint(x: -5, y: -5)
                pinAnnotationView?.animatesDrop = false
            }
            
            pinAnnotationView?.pinColor = .Red
            pinAnnotationView?.image
            
            return pinAnnotationView
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

