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
    let aboutViewController: AboutViewController
    
    // MARK: - Object Lifecycle
    
    required init(coder aDecoder: NSCoder) {
        map = Map()
        aboutViewController = AboutViewController()
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
    
    override func viewWillAppear(animated: Bool) {
        softDismissViewController(aboutViewController, animations: { (viewController: UIViewController) -> Void in
            // TODO: Support no animation
            UIView.animateWithDuration(0, animations: { () -> Void in
            })
        })
    }
    
    
    // MARK: - IBActions
    
    @IBAction func informationButtonDidTap(sender: UIButton) {
        
        if ((aboutViewController.parentViewController) != nil) {
            softDismissViewController(aboutViewController, animations: { (viewController) -> Void in
                UIView.animateWithDuration(0.1618, animations: { () -> Void in
                    viewController.view.alpha = 0
                })
            })
        } else {
            softPresentViewController(aboutViewController,
                animations: { (viewController: UIViewController) -> Void in
                    UIView.animateWithDuration(0.2, animations: { () -> Void in
                        viewController.view.alpha = 1
                    })
            })
        }
    }
    
    
    // MARK: - Private
    
    private func syncVendorLocationsInMap(map: Map) {
        map.syncLocations(Vendor.allObjectsAsArray())
    }
    
    private func softPresentViewController(viewController: UIViewController, animations: (_: UIViewController) -> Void) {

        viewController.willMoveToParentViewController(self)
        viewController.view.willMoveToSuperview(self.view)
        self.addChildViewController(viewController)
        
        viewController.view.alpha = 0
        self.view.addSubview(viewController.view)
        self.view.bringSubviewToFront(viewController.view)

        animations(viewController)
        
        CATransaction.setCompletionBlock { [weak viewController, weak self] () -> Void in
            if let weakViewController = viewController {
                weakViewController.view.didMoveToSuperview()
                if let weakSelf = self {
                    weakViewController.didMoveToParentViewController(weakSelf)
                }
            }
            
            // Reset the completion block
            CATransaction.setCompletionBlock({})
        }
    }
    
    private func softDismissViewController(viewController: UIViewController, animations: (_: UIViewController) -> Void) {
        viewController.willMoveToParentViewController(nil)
        self.view.willRemoveSubview(viewController.view)
        
        animations(viewController)
        
        CATransaction.setCompletionBlock { [weak viewController, weak self] () -> Void in
            if let weakViewController = viewController {
                if let weakSelf = self {
                    weakViewController.view.removeFromSuperview()
                    weakViewController.removeFromParentViewController()
                    weakViewController.didMoveToParentViewController(nil)
                }
            }
            
            // Reset the completion block
            CATransaction.setCompletionBlock({})
        }
    }
}

