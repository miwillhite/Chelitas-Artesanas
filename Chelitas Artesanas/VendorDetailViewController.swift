//
//  VendorDetailViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 10/7/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import UIKit
import Parse

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
    var map: Map?
    var selectedAnnotation: MKAnnotation?
    
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
        
        // Setup Table View
        setupTableView()
        
        // Load the data
        reloadData()

        // Focus Map on selected Vendor
        focusMapOnSelectedVendor()
    }
    
    func modalWillClose() {
        resetMapView()
    }
    

    // MARK: - UITableViewDataSource
    
    func setupTableView() {
        // Setup the table
        tableView.registerNib(UINib(nibName: "VendorDetailTableViewCell", bundle: nil), forCellReuseIdentifier: VendorDetailBreweriesCellIdentifier)
        
        tableView.registerClass(VendorDetailTableViewFooter.self,
            forHeaderFooterViewReuseIdentifier: VendorDetailTableViewFooterIdentifier)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(breweries.count)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(VendorDetailBreweriesCellIdentifier,
                forIndexPath: indexPath
            ) as! VendorDetailBreweriesCell
        
        // TODO: Test this
        let brewery = breweries[indexPath.row]
        let query = Stocking.queryWithPredicate(NSPredicate(format: "brewery = %@", brewery))
        query?.orderByDescending("createdAt")
        let lastStocking = query?.getFirstObject()
        
        cell.breweryNameLabel.text = brewery.name
        cell.breweryLogoImageView.image = UIImage(named: "Hop Icon")
        if let stocking = lastStocking {
            let lastStockedDateString =
                NSDateFormatter.localizedStringFromDate(stocking.createdAt!,
                    dateStyle: .ShortStyle,
                    timeStyle: .NoStyle
                )
            
            cell.lastStockedLabel.text = String.localizedStringWithFormat(NSLocalizedString("Last Stocked: %@", comment: "Label describes the last stocked date"), lastStockedDateString)
        }
        return cell
    }
    
    
    // MARK: - UITableViewDelegate
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier(VendorDetailTableViewFooterIdentifier) as! VendorDetailTableViewFooter
        return view
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> Float {
        return 1
    }
    
    
    // MARK: - Actions
    
    func reloadData() {
        
        if let stockedBreweries = vendor?.stockedBreweries {
            breweries = stockedBreweries
            breweries = stockedBreweries.sorted({ (lBrewery, rBrewery) -> Bool in
                var query: PFQuery
                
                query = Stocking.queryWithPredicate(NSPredicate(format: "brewery = %@", lBrewery))!
                query.orderByDescending("createdAt")
                let lStocking = query.getFirstObject()
                
                query = Stocking.queryWithPredicate(NSPredicate(format: "brewery = %@", rBrewery))!
                query.orderByDescending("createdAt")
                let rStocking = query.getFirstObject()
                
                if let lDate = lStocking?.createdAt, rDate = rStocking?.createdAt {
                    return lDate.compare(rDate) == NSComparisonResult.OrderedDescending
                }
                return false
            })
        }

        // Setup view
        if let vendor = vendor {
            self.nameLabel.text = vendor.name
            if let phone = vendor.phone {
                self.phoneTextView.text = phone
            } else {
                self.phoneTextView.hidden = true
                self.phoneIconView.hidden = true
            }
        }
    }
    
    
    // MARK: - Misc Map Stuff
    
    func focusMapOnSelectedVendor() {
        // Focus Adjust the map view. FIXME: There should be a better place for this
        if let parentController = self.presentingViewController as? ViewController {
            self.map = parentController.map
        }
        
        // Calculate the map presentation rect
        let yDelta = CGRectGetMinY(self.view.frame) - CGRectGetMinY(self.presentationView.frame)
        
        let (mapPresentationRect, _) = self.view.frame.rectsByDividing(abs(yDelta), fromEdge: .MinYEdge)
        
        map?.focusSelectedAnnotationInRect(mapPresentationRect)
        self.selectedAnnotation = map?.selectedAnnotation
        map?.deselectAllAnnotations()
    }
    
    func resetMapView() {
        if let del = vendorDetailTransitioningDelegate {
            if del.isClosing {
                map?.resetFocusToPreviousCenter()
                if let annotation = selectedAnnotation {
                    map?.selectAnnotations([annotation])
                }
            }
        }
    }
}


// MARK: -
// MARK: -

class VendorDetailBreweriesCell: UITableViewCell {
    @IBOutlet weak var breweryLogoImageView: UIImageView!
    @IBOutlet weak var breweryNameLabel: UILabel!
    @IBOutlet weak var lastStockedLabel: UILabel!
    
//    override init?(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        self.breweryLogoImageView.contentMode = .ScaleAspectFill
//    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


// MARK: -
// MARK: -

class VendorDetailTableViewFooter: UITableViewHeaderFooterView {
}
