//
//  VendorsListViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/16/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import UIKit
import Realm

class VendorsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var theTableView: UITableView!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // FIXME: Speed this up
        let indexPathsForVisibleRows = theTableView.indexPathsForVisibleRows() as [NSIndexPath]
        for indexPath in indexPathsForVisibleRows {
            theTableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
    
    
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowVendorSegue" {
            let showVendorViewController =
                segue.destinationViewController as ShowVendorViewController
            
            if let selectedIndexPath = theTableView.indexPathForSelectedRow() {
                showVendorViewController.vendor =
                    vendors()[UInt(selectedIndexPath.row)] as? Vendor
            }
        }
    }
    
    
    // MARK: - Data
    
    func vendors() -> RLMArray {
        return Vendor.allObjects()
    }
}