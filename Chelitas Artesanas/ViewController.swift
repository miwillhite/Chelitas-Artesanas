//
//  ViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/6/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var informationButton: UIButton!
    @IBOutlet weak var locateUserButton: UIButton!
    
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
        map.view.frame = UIScreen.mainScreen().bounds
        self.view.addSubview(map.view)
        self.view.sendSubviewToBack(map.view)
        
        map.requestAuthorization { [weak self] (granted, map) -> Void in
            if let weakSelf = self {
                weakSelf.syncVendorLocationsInMap(map)
            }
        }
        
        // Observe the Information modal
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "informationModalDidClose:",
            name: InformationViewControllerModalDidCloseNotification,
            object: nil
        )
    }
    
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "InformationSegue" {
            locateUserButton.enabled = false
            informationButton.enabled = false
            searchBar.enabled = false
        }
    }
    
    
    // MARK: - Touch
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        self.becomeFirstResponder()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func locateUserDidTap(sender: UIButton) {
        map.locateUser()
    }
    
    
    // MARK: - Notification Handlers
    func informationModalDidClose(note: NSNotification) {
        locateUserButton.enabled = true
        informationButton.enabled = true
        searchBar.enabled = true
    }

    
    // MARK: - Private
    
    private func syncVendorLocationsInMap(map: Map) {
        map.syncLocations(Vendor.allObjectsAsArray())
    }}

