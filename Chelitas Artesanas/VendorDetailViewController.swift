//
//  VendorDetailViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 10/7/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import UIKit
import Realm

let VendorDetailBreweriesCellIdentifier = "VendorDetailBreweriesCellIdentifier"

class VendorDetailViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var phoneTextView: UITextView!
    @IBOutlet weak var phoneIconView: UIImageView!
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
            self.nameLabel.text = vendor.name
            if vendor.phone == "" {
                self.phoneTextView.hidden = true
                self.phoneIconView.hidden = true
            } else {
                self.phoneTextView.text = vendor.phone
            }
        }
        
        // Setup the table
        tableView.registerClass(VendorDetailBreweriesCell.self,
            forCellReuseIdentifier: VendorDetailBreweriesCellIdentifier)
    }
    
    
    // MARK: - UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(breweries.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(VendorDetailBreweriesCellIdentifier,
                forIndexPath: indexPath
            ) as VendorDetailBreweriesCell
        
        let brewery = breweries[indexPath.row]
//        let lastStocking = brewery.stockings.arraySortedByProperty("createdAt", ascending: false).firstObject() as Stocking?
        
        cell.textLabel?.text = brewery.name
        
        // FIXME: Appears to be a bug, but all my custom labels come up as nil
//        cell.breweryNameLabel.text = brewery.name
        
//        if let stocking = lastStocking {
//            cell.lastStockedLabel.text =
//                NSDateFormatter.localizedStringFromDate(stocking.createdAt,
//                    dateStyle: .ShortStyle,
//                    timeStyle: .NoStyle
//                )
//        }
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = VendorDetailTableViewFooter()
        return view
    }
    
    
    // MARK: - Actions
    
    func reloadData() {
        if let stockedBreweries = vendor?.stockedBreweries {
            breweries = stockedBreweries
        }
    }
}


// MARK: -
// MARK: -

class VendorDetailBreweriesCell: UITableViewCell {
    @IBOutlet weak var breweryLogoImageView: UIImageView!
    @IBOutlet weak var breweryNameLabel: UILabel!
    @IBOutlet weak var lastStockedLabel: UILabel!
}


// MARK: -
// MARK: -

class VendorDetailTableViewFooter: UIView {
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
}