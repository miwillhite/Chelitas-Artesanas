//
//  InformationViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/10/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import UIKit

class InformationView: UIView {
    override func layoutSubviews() {
        self.layer.cornerRadius = 10
    }
}

class InformationViewController: UIViewController {
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        let adminStoryboard = UIStoryboard(name: "Admin", bundle: nil)
        let adminViewController = adminStoryboard.instantiateInitialViewController() as UINavigationController
        
        adminViewController.modalTransitionStyle = .FlipHorizontal
        
        self.presentingViewController!.presentViewController(adminViewController, animated: true) { () -> Void in
            // Do nothing...yet
        }
    }
    
    
    // MARK: IBActions
    @IBAction func brewersSectionAbutton(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
}