//
//  InformationViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/10/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import UIKit

let InformationViewControllerModalWillCloseNotification =
    "InformationViewControllerModalWillCloseNotification"

class InformationView: UIView {
    override func layoutSubviews() {
        self.layer.cornerRadius = 10
    }
}

class InformationViewController: UIViewController {
    
    var hidingModal = false
    
    // MARK: IBOutlets
    
    @IBOutlet weak var versionLabel: UILabel!
    
    
    // MARK: View Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        // Set the version text
        self.versionLabel.text = versionString();
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter()
            .postNotificationName(
                InformationViewControllerModalWillCloseNotification,
                object: nil
            )
        
        // FIXME: There is probably a better way to handle this
        if hidingModal {
            hidingModal = false
            return
        }
        
        let adminStoryboard = UIStoryboard(name: "Admin", bundle: nil)
        let adminViewController = adminStoryboard.instantiateInitialViewController() as! UINavigationController
        
        adminViewController.modalTransitionStyle = .FlipHorizontal
        
        self.presentingViewController!.presentViewController(adminViewController, animated: true) { () -> Void in
            // Do nothing...yet
        }
    }
    
    
    // MARK: IBActions
    @IBAction func brewersSectionDidTap(sender: UIButton) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    @IBAction func clearModalDidTap(sender: UIButton) {
        hidingModal = true
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    private
    
    func versionString() -> String {
        let mainBundle = NSBundle.mainBundle()
        let dict = mainBundle.infoDictionary as! [String : AnyObject]
        let version = dict["CFBundleShortVersionString"] as! String;
        let build = dict["CFBundleVersion"] as! String;
        return "v\(version)b\(build)"
    }
}