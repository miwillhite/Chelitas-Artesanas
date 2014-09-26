//
//  AboutViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/10/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UIViewController {
    
    let ϕ: CGFloat = 1.618
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.84)
        var bounds = CGRectInset(UIScreen.mainScreen().bounds, 20, 20)
        bounds.size.height = bounds.height / ϕ
        self.view.frame = bounds
        self.view.layer.cornerRadius = 10
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let adminStoryboard = UIStoryboard(name: "Admin", bundle: nil)
        let adminViewController = adminStoryboard.instantiateInitialViewController() as UINavigationController
        
        adminViewController.modalTransitionStyle = .FlipHorizontal
        
        self.parentViewController!.presentViewController(adminViewController, animated: true) { () -> Void in
            // Do nothing...yet
        }
    }
}