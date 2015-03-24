//
//  ViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/6/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UITextField!
    @IBOutlet weak var informationButton: UIButton!
    @IBOutlet weak var locateUserButton: UIButton!
    
    var previouslySelectedVendorAnnotations: [MKAnnotation]?
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    let map: Map
    
    
    // MARK: - Object Lifecycle
    
    required init(coder aDecoder: NSCoder) {
        map = Map()
        super.init(coder: aDecoder)
    }
    
    deinit {
        notificationCenter.removeObserver(self,
            name: InformationViewControllerModalWillCloseNotification,
            object: nil
        )
        
        notificationCenter.removeObserver(self,
            name: MapItemProviderAnnotationDisclosureButtonDidTapNotification,
            object: nil
        )
    }
    
    
    // MARK: - View Management

    override func viewDidLoad() {
        super.viewDidLoad()

        // Fetch some data
        API.sync { (error) -> Void in
            // Alert the user
            if let e = error {
                println("\(__FUNCTION__) Error: \(error)")
            }
        }
        
        // Map
        map.view.frame = UIScreen.mainScreen().bounds
        self.view.addSubview(map.view)
        self.view.sendSubviewToBack(map.view)
        
        map.requestAuthorization { [weak self] (granted, map) -> Void in
            if let weakSelf = self {
                weakSelf.syncVendorLocationsInMap(map)
            }
        }
        
        // Observe the Information modal
        notificationCenter.addObserver(self,
            selector: "informationModalDidClose:",
            name: InformationViewControllerModalWillCloseNotification,
            object: nil
        )
        
        // Observe Map Annotation Disclosure events
        notificationCenter.addObserver(self,
            selector: "mapAnnotationDisclosureDidTap:",
            name: MapItemProviderAnnotationDisclosureButtonDidTapNotification,
            object: nil
        )
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        enableMapElements()
    }
    

    // MARK: - Segues
    
    enum SegueIdentifier: String {
        case Information = "InformationSegue"
        case VendorDetail = "VendorDetailSegue"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = SegueIdentifier(rawValue: segue.identifier!) {
            switch identifier {
            case .Information:
                enableMapElements(enabled: false)
                map.deselectAllAnnotations()
            case .VendorDetail:
                enableMapElements(enabled: false)
                // Setup the destination vc
                let vendorDetailViewController = segue.destinationViewController as! VendorDetailViewController
                if let vendor = sender as? Vendor {
                    vendorDetailViewController.vendor = vendor
                }
            default:
                return
            }
        }
    }
    

    // MARK: - Touch
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.becomeFirstResponder()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func locateUserDidTap(sender: UIButton) {
        map.locateUser()
    }
    
    
    // MARK: - Notification Handlers
    
    func informationModalDidClose(note: NSNotification) {
        enableMapElements()
    }
    
    func mapAnnotationDisclosureDidTap(note: NSNotification) {
        if let noteObject = note.object as? MapItemProvider {
            let query: PFQuery = Vendor.queryWithPredicate(NSPredicate(format: "name = %@", noteObject.title))!
            let vendor = query.getFirstObject()

            performSegueWithIdentifier(SegueIdentifier.VendorDetail.rawValue, sender: vendor)
        }
    }

    
    // MARK: - Private
    
    private func syncVendorLocationsInMap(map: Map) {
        map.syncLocations(Vendor.query()!.findObjects()!)
    }

    private func enableMapElements(enabled: Bool = true) {
        locateUserButton.enabled  = enabled
        informationButton.enabled = enabled
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.searchBar.alpha = enabled ? 1 : 0
        })
    }
}