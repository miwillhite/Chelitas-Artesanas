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
let VendorDetailTableViewFooterIdentifier = "VendorDetailTableViewFooterIdentifier"

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
        
        tableView.registerClass(VendorDetailTableViewFooter.self,
            forHeaderFooterViewReuseIdentifier: VendorDetailTableViewFooterIdentifier)
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
        let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier(VendorDetailTableViewFooterIdentifier) as VendorDetailTableViewFooter
        return view
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> Float {
        return 1
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
    
    override init() {
        super.init()
    }
    
    override init?(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


// MARK: -
// MARK: -

class VendorDetailTableViewFooter: UITableViewHeaderFooterView {
}
