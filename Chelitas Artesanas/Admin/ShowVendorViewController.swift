//
//  ShowVendorViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/17/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//
//  TODO: Filter out logged-in brewer in "Also Selling Here" list
//

import UIKit
import MapKit
import Realm

class ShowVendorViewController: UITableViewController {
    
    let realm = RLMRealm.defaultRealm()
    let brewery: Brewery = AdminSession.sharedSession.brewery
    var notificationToken: RLMNotificationToken?
    var vendor: Vendor?
    
    @IBOutlet weak var titleItem: UINavigationItem!
    @IBOutlet weak var mapView: MKMapView! // FIXME: Should be using the Map class
    @IBOutlet weak var lastStockedDateLabel: UILabel!
    @IBOutlet weak var alsoSellingLabel: UILabel!
    
    
    // MARK: - Life Cycle
    
    override func didReceiveMemoryWarning() {
        realm.removeNotification(notificationToken)
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        realm.removeNotification(notificationToken)
    }
    
    
    // MARK: - View Management
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.toolbar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.toolbar.hidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let v = vendor {
            setupView(v)
            
            notificationToken = realm.addNotificationBlock {[weak self] note, realm in
                if let weakSelf = self {
                    weakSelf.setLastStockedLabel(v)
                }
            }
        }
    }

    
    // MARK: Private
    
    // Not sure if setting my local var the same name as the property is a great idea...
    private func setupView(vendor: Vendor) {
        titleItem.title = vendor.title
        
        setAlsoSellingLabel(vendor.stockings)
        
        setLastStockedLabel(vendor)
        
        setupMapView(vendor)
    }
    
    private func setAlsoSellingLabel(vendorStockings: RLMArray) {
        var brewerList = [String]()

        // First build the brewer list
        for stocking in vendorStockings {
            if let s = stocking as? Stocking {
                let name = s.brewery.name
                brewerList.append(name)
            }
        }
        
        // Convert it to a string
        let brewerListString = brewerList.combine(", ")
        if brewerListString.isEmpty {
            alsoSellingLabel.text = "None"
        } else {
            alsoSellingLabel.text = brewerListString
        }
    }
    
    private func setLastStockedLabel(vendor: Vendor) {
        // TODO: Find Stocking by brwwery and vendor, sorted by last updated
        
        let vendorStockings = Stocking.objectsWhere("brewery = %@ AND vendor = %@", brewery, vendor)
        let lastVendorStocking = vendorStockings.arraySortedByProperty("lastUpdated", ascending: true)
                                    .lastObject() as? Stocking

        if let stocking = lastVendorStocking {
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            var lastUpdated: String = dateFormatter.stringFromDate(stocking.lastUpdated)
            lastStockedDateLabel.text = lastUpdated
        } else {
            lastStockedDateLabel.text = "None"
        }
    }
    
    // Set the pin on the map
    private func setupMapView(vendor: Vendor) {
        let mapItem = MapItemProvider(title: vendor.title, subtitle: "", latitude: vendor.lat, longitude: vendor.lon)
        
        mapView.addAnnotations([mapItem])
        mapView.setRegion(makeRegion(mapItem.coordinate)!, animated: false)
    }
    
    // Taken from VendorMap...possible refactor?
    private func makeRegion(location: CLLocationCoordinate2D) -> MKCoordinateRegion? {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        return MKCoordinateRegion(center: location, span: span)
    }
    
    
    // MARK: - Actions
    
    @IBAction func updateStock(sender: UIButton) {
        realm.beginWriteTransaction()
        
        var stocking = Stocking()
        stocking.lastUpdated = NSDate()
        stocking.brewery = brewery
        stocking.vendor = vendor!
        realm.addObject(stocking)
        
        realm.commitWriteTransaction()
    }
}