//
//  ViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/6/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    let map: Map
    
    // MARK: - Object Lifecycle
    
    required init(coder aDecoder: NSCoder) {
        map = Map()
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - View Management

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Subscribe to Vendor updates
        Vendor.subscribe {
            self.syncVendorLocationsInMap(self.map)
        }
        
        // Fetch some data
        API.sync { (error) -> Void in
            // Alert the user
            if let e = error {
                println("\(__FUNCTION__) Error: \(error)")
            }
        }
        
        // Map
        map.view.frame = CGRectOffset(self.view.bounds, 0, CGRectGetHeight(searchBar.frame))
        self.view.addSubview(map.view)
        self.view.sendSubviewToBack(map.view)
        
        map.requestAuthorization { [weak self] (granted, map) -> Void in
            if let weakSelf = self {
                weakSelf.syncVendorLocationsInMap(map)
            }
        }
    }

    
    // MARK: - Private
    
    private func syncVendorLocationsInMap(map: Map) {
        map.syncLocations(Vendor.allObjectsAsArray())
    }}

