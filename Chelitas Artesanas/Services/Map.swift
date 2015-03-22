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
    var selectedAnnotation: MKAnnotation?
    
    // MARK: Private Properties
    
    private let locationManager: CLLocationManager
    private let notificationCenter: NSNotificationCenter
    private var originalMapCenterCoordinate: CLLocationCoordinate2D?
    
    
    // MARK: - Object Lifecycle
    
    required init(mapView: MKMapView, locationManager: CLLocationManager, notificationCenter: NSNotificationCenter) {
        self.view = mapView
        self.locationManager = locationManager
        self.notificationCenter = notificationCenter
        
        super.init()

        // Map View
        view.delegate = self
        view.rotateEnabled = false // Cheap way to stop the compass from appearing below the search bar
        
        // Location Manager
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.distanceFilter = 30 // Movement threshold
    }
    
    convenience override init() {
        self.init(mapView:MKMapView(), locationManager: CLLocationManager(), notificationCenter: NSNotificationCenter.defaultCenter())
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

    // Implement this instead of the UIButton
//    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
//    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        self.selectedAnnotation = view.annotation
    }

    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        self.selectedAnnotation = nil
    }
    
    
    // MARK: - Misc Map Tools, Functions
    
    func deselectAllAnnotations() -> [MKAnnotation] {
        if let selectedAnnotations = view.selectedAnnotations as? [MKAnnotation] {
            for annotation in selectedAnnotations {
                view.deselectAnnotation(annotation, animated: true)
            }
            return selectedAnnotations
        }
        return [MKAnnotation]()
    }
    
    func selectAnnotations(annotations: [MKAnnotation]) -> [MKAnnotation] {
        for annotation in annotations {
            view.selectAnnotation(annotation, animated: true)
        }
        return annotations
    }
    
    func focusSelectedAnnotationInRect(focusRect: CGRect) -> Bool {
        // Save this for the reset
        self.originalMapCenterCoordinate = view.centerCoordinate
        
        // Move the annotation coordinate to the center of the rect
        if let annotation = selectedAnnotation {
            let annotationPoint = view.convertCoordinate(annotation.coordinate,
                toPointToView: nil // Translates to the window
            )
            
            // Get deltas to map window center
            let xDelta = annotationPoint.x + focusRect.origin.x
            let yDelta = annotationPoint.y + CGRectGetMidY(focusRect) + (CGRectGetHeight(focusRect) / 2)
            
            // New map center (delta opposite)
            let mapCenterCoordinate = view.convertPoint(CGPoint(x: xDelta, y: yDelta),
                toCoordinateFromView: UIApplication.sharedApplication().keyWindow
            )
            
            // Move the map
            view.setRegion(MKCoordinateRegionMake(mapCenterCoordinate, view.region.span), animated: true)
            
            return true
        }
        
        return false
    }
    
    func resetFocusToPreviousCenter() {
        
        if let coord = originalMapCenterCoordinate {
            view.setRegion(MKCoordinateRegionMake(coord, view.region.span),
                animated: true
            )
        }

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

