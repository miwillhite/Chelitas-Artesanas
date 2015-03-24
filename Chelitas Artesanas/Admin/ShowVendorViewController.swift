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
import Parse

class ShowVendorViewController: UITableViewController {
    
    let brewery: Brewery = AdminSession.sharedSession.brewery as! Brewery
    var vendor: Vendor?
    
    @IBOutlet weak var titleItem: UINavigationItem!
    @IBOutlet weak var mapView: MKMapView! // FIXME: Should be using the Map class
    @IBOutlet weak var lastStockedDateLabel: UILabel!
    @IBOutlet weak var alsoSellingLabel: UILabel!
    
    
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
        }
    }

    
    // MARK: - IBActions
    
    @IBAction func updateStock(sender: UIButton) {
        // TODO: According to the docs I should be able to do Stocking()
        var stocking = Stocking(className: Stocking.parseClassName())
        stocking.brewery = brewery
        stocking.vendor = vendor!
        stocking.save()
    }
}


// MARK: - Private
// MARK: -

private extension ShowVendorViewController {
    
    // Not sure if setting my local var the same name as the property is a great idea...
    private func setupView(vendor: Vendor) {
        titleItem.title = vendor.name
        
        setAlsoSellingLabel(vendor.stockings)
        
        setLastStockedLabel(vendor)
        
        setupMapView(vendor)
    }
    
    private func setAlsoSellingLabel(vendorStockings: [Stocking]) {
        var brewerList = [String]()
        
        // First build the brewer list
        for stocking in vendorStockings {
            let brewery = stocking.brewery
            brewerList.append(brewery.name)
        }
        
        // Convert it to a string
        let brewerListString = brewerList.combine(", ")
        if brewerListString.isEmpty {
            alsoSellingLabel.text = NSLocalizedString("None",
                comment: "No other breweries selling at this location label"
            )
        } else {
            alsoSellingLabel.text = brewerListString
        }
    }
    
    private func setLastStockedLabel(vendor: Vendor) {
        let vendorStockings = Stocking.queryWithPredicate(NSPredicate(format: "brewery = %@ AND vendor = %@", brewery, vendor))
        let lastVendorStocking = vendorStockings?.orderByDescending("createdAt").getFirstObject()
        
        if let stocking = lastVendorStocking {
            let lastStockedAt = NSDateFormatter.localizedStringFromDate(stocking.createdAt!,
                dateStyle: .ShortStyle,
                timeStyle: .NoStyle
            )

            lastStockedDateLabel.text = lastStockedAt
        } else {
            lastStockedDateLabel.text = NSLocalizedString("None",
                comment: "No stockings at this location label"
            )
        }
    }
    
    // Set the pin on the map
    private func setupMapView(vendor: Vendor) {
        let mapItem = MapItemProvider(title: vendor.name, subtitle: "", latitude: vendor.lat, longitude: vendor.lon)
        
        mapView.addAnnotations([mapItem])
        mapView.setRegion(makeRegion(mapItem.coordinate)!, animated: false)
    }
    
    // Taken from VendorMap...possible refactor?
    private func makeRegion(location: CLLocationCoordinate2D) -> MKCoordinateRegion? {
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        return MKCoordinateRegion(center: location, span: span)
    }
}