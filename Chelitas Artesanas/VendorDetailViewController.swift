//
//  VendorDetailViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 10/7/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import UIKit
import Realm

class VendorDetailTableViewFooter: UIView {
}

class VendorDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var presentationView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var vendorDetailTransitioningDelegate: VendorDetailTransitioningDelegate?
    var vendor: Vendor?
    var breweries = [Brewery]()
    var notificationToken: RLMNotificationToken?
    
    // MARK: - Object Lifecycle
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.modalPresentationStyle = .Custom
        vendorDetailTransitioningDelegate =
            VendorDetailTransitioningDelegate(viewController: self)
        self.transitioningDelegate = vendorDetailTransitioningDelegate
    }
    
    
    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup the delegate with the right view
        if let transitioningDelegate = self.transitioningDelegate as? VendorDetailTransitioningDelegate {
            transitioningDelegate.setupGestureRecognizer(view: presentationView)
        }
        
        // Set realm notification block
        notificationToken = RLMRealm.defaultRealm().addNotificationBlock { note, realm in
            self.reloadData()
        }
        reloadData()
        
        // Populate the view attributes
        if let vendor = vendor {
            self.titleLabel.text = vendor.title
        }
    }
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(breweries.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("VendorDetailBreweriesCell", forIndexPath: indexPath) as UITableViewCell
        
        let brewery = breweries[indexPath.row]
        cell.textLabel?.text = brewery.name
        
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = VendorDetailTableViewFooter()
// TODO:
//        let logoImage = UIImage(named: "Logo")
//        let imageView = UIImageView(image: logoImage)
//        
//        imageView.contentMode = .ScaleAspectFit
//        imageView.contentScaleFactor = 0.75
//        imageView.alpha = 0.15
//        imageView.frame = view.bounds
//        
//        view.addSubview(imageView)
        
        return view
    }
    
    
    // MARK: - Actions
    
    func reloadData() {
        if let stockedBreweries = vendor?.stockedBreweries {
            breweries = stockedBreweries
        }
    }
}
