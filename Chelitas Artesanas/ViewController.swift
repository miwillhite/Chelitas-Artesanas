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
    let aboutButton: UIButton
    
    // MARK: - Object Lifecycle
    
    required init(coder aDecoder: NSCoder) {
        map = Map()
        aboutButton = UIButton();
        
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
        
        // About Button
        aboutButton.setTitle("About", forState: .Normal)
        aboutButton.frame = CGRect(x: 5, y: 10, width: 100, height: 30)
        aboutButton.addTarget(self, action: "aboutButtonDidTap:", forControlEvents: .TouchUpInside)
        self.view.addSubview(aboutButton)
    }
    
    
    // MARK: - Button Responders
    
    func aboutButtonDidTap(sender: UIButton!) {
        var aboutViewController = AboutViewController()

        softPresentViewController(aboutViewController,
            animations: { (viewController: UIViewController) -> Void in
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    viewController.view.alpha = 1
                })
            })
    }
    
    
    // MARK: - Private
    
    private func syncVendorLocationsInMap(map: Map) {
        map.syncLocations(Vendor.allObjectsAsArray())
    }
    
    private func softPresentViewController(viewController: UIViewController, animations: ((_: UIViewController) -> Void)?) {

        viewController.willMoveToParentViewController(self)
        viewController.view.willMoveToSuperview(self.view)
        self.addChildViewController(viewController)
        
        viewController.view.alpha = 0
        self.view.addSubview(viewController.view)
        self.view.bringSubviewToFront(viewController.view)

        if let animations = animations {
            animations(viewController)
        }
        
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
}

