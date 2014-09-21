//
//  BreweryViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/10/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import UIKit

class BreweryViewController: UIViewController {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.yellowColor()
    }
    
    override func viewWillLayoutSubviews() {
        var bounds = UIScreen.mainScreen().bounds
        self.view.frame = bounds

    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in
        })
    }
}