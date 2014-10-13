//
//  LoginViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/17/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import UIKit

class LoginViewController: UITableViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBAction func login(sender: UIButton) {
        self.performSegueWithIdentifier("VendorListSegue", sender: sender)
    }
    
    @IBAction func exitButton(sender: UIBarButtonItem) {
        self.parentViewController!.dismissViewControllerAnimated(true, completion: { () -> Void in
            // Do nothing yet
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        enum SegueIdentifier: String {
            case VendorList = "VendorListSegue"
        }
        
        if let identifier = SegueIdentifier(rawValue: segue.identifier!) {
            switch identifier {
            case .VendorList:
                let vendorListViewController = segue.destinationViewController as VendorListViewController
                if let presentingVC = presentingViewController as? ViewController {
                    let userCoordinate = presentingVC.map.userCoordinate!
                    vendorListViewController.userLocation = CLLocation(
                        latitude: userCoordinate.latitude,
                        longitude: userCoordinate.longitude
                    )
                }
                
            default:
                return
            }
        }
    }
}