//
//  VendorDetailViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 10/7/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import UIKit

class VendorDetailViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var presentationView: UIView!
    
    var vendorDetailTransitioningDelegate: VendorDetailTransitioningDelegate?
    var vendor: Vendor?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.modalPresentationStyle = .Custom
        vendorDetailTransitioningDelegate =
            VendorDetailTransitioningDelegate(viewController: self)
        self.transitioningDelegate = vendorDetailTransitioningDelegate
    }
    
    override func viewDidLoad() {
        // Setup the delegate with the right view
        if let transitioningDelegate = self.transitioningDelegate as? VendorDetailTransitioningDelegate {
            transitioningDelegate.setupGestureRecognizer(view: presentationView)
        }
        
        // Populate the view attributes
        if let vendor = vendor {
            self.titleLabel.text = vendor.title
        }
    }
}
