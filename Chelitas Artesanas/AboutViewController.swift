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
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(white: 1, alpha: 0.84)
    }
    
    override func viewWillLayoutSubviews() {
        let ϕ: CGFloat = 1.618
        var bounds = UIScreen.mainScreen().bounds
        bounds.size.height = bounds.height - bounds.height * (1 - ϕ)
        self.view.frame = bounds
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let breweryViewController = BreweryViewController()
        breweryViewController.modalTransitionStyle = .FlipHorizontal
        
        self.parentViewController!.presentViewController(breweryViewController, animated: true) { () -> Void in
            println("did present BreweryViewController")
        }
    }
}