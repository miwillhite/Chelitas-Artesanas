//
//  BreweryViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/10/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import UIKit

class BreweryViewController: UIViewController {
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.yellowColor()
    }
    
    override func viewWillLayoutSubviews() {
        var bounds = UIScreen.mainScreen().bounds
        self.view.frame = bounds

    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
            println("dismissed \(self)")
        })
    }
}