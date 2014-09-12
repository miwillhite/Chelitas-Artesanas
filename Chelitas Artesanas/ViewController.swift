//
//  ViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/6/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let map: VendorMap
    var breweryViewController: BreweryViewController?
    let settingsButton: UIButton
    
    required init(coder aDecoder: NSCoder) {
        map = VendorMap()
    
        settingsButton = UIButton();
        settingsButton.setTitle("About", forState: .Normal)

        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.locationManager.requestWhenInUseAuthorization()
        map.view.frame = self.view.bounds
        self.view.addSubview(map.view)
        
        settingsButton.frame = CGRect(x: 5, y: 10, width: 100, height: 30)
        settingsButton.addTarget(self, action: "settingsButtonDidTap:", forControlEvents: .TouchUpInside)
        self.view.addSubview(settingsButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Button Responders
    func settingsButtonDidTap(sender: UIButton!) {
        var aboutViewController: AboutViewController? = AboutViewController()
        
        if let viewController = aboutViewController {
            viewController.willMoveToParentViewController(self)
            viewController.view.willMoveToSuperview(self.view)
            self.addChildViewController(viewController)
            
            viewController.view.alpha = 0
            self.view.addSubview(viewController.view)
            self.view.bringSubviewToFront(viewController.view)
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                viewController.view.alpha = 1
            }, completion: { (Bool) -> Void in
                viewController.view.didMoveToSuperview()
            })
            
            viewController.didMoveToParentViewController(self)
        }
    }
}

