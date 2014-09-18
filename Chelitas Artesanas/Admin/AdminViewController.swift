//
//  AdminViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/16/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import UIKit
import Realm

class AdminViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let vendor = vendors()[UInt(indexPath.row)] as Vendor
        let cell = tableView.dequeueReusableCellWithIdentifier("VendorCell") as UITableViewCell
        cell.textLabel!.text = vendor.title
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(vendors().count)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Más Cerca"
    }
    
    // MARK: - Data
    
    func vendors() -> RLMArray {
        return Vendor.allObjects()
    }
}