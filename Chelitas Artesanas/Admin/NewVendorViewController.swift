//
//  VendorNewViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/22/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//
//  TODO: Allow user to update coordinate

import UIKit
import MapKit
import Realm

class NewVendorViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var vendorNameField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var aVendor: Vendor?
    
    override func viewDidLoad() {
        saveButton.enabled = false
        vendorNameField.delegate = self
    }
    

    // MARK: - UITextFieldDelegate
    
    func textFieldDidEndEditing(textField: UITextField) {
        if vendorNameField.text.isEmpty {
            return
        }
        saveButton.enabled = true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    
    // MARK: - Segues
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NewToShowVendorSegue" {
            let showViewController = segue.destinationViewController as ShowVendorViewController
            if let vendor = aVendor {
                showViewController.vendor = aVendor
            }
        }
    }
    
    
    // MARK: - Actions
    
    @IBAction func saveVendor(sender: UIBarButtonItem) {
        if formValidates() {
            createAndSaveVendor()
        } else {
            notifyUserOfInvalidData()
            return
        }
        
        // Move on to the show view
        performSegueWithIdentifier("NewToShowVendorSegue", sender: self)
        
        // Clean up the view controller stack so that the show view goes back to the list
        if let navController = navigationController {
            let filteredViewControllers = navController.viewControllers.filter({
                !($0 is NewVendorViewController)
            })
            navController.viewControllers = filteredViewControllers
        }
    }
    
    
    // MARK: - Private
    
    private func formValidates() -> Bool {
        var validates: Bool
        
        // Validations
        validates = !vendorNameField.text.isEmpty

        return validates
    }
    
    private func createAndSaveVendor() {
        let realm = RLMRealm.defaultRealm()
        realm.beginWriteTransaction()
        
        aVendor = Vendor()
        if let vendor = aVendor {
            vendor.name = vendorNameField.text;
            vendor.lat = mapView.userLocation.coordinate.latitude
            vendor.lon = mapView.userLocation.coordinate.longitude
            
            // Add to the realm
            realm.addObject(vendor)
            
            // Save to server
            API.push(vendor)
        }
        
        realm.commitWriteTransaction()
    }
    
    private func notifyUserOfInvalidData() {
        let message = NSLocalizedString("A vendor needs a name.",
            comment: "Inform the user that a vendor needs a name"
        )
        // FIXME: Replace this with the new alert controller
        let alert = UIAlertView(title: NSLocalizedString("Invalid Data",
                                    comment: "Inform the user that they have invalid data"),
                                message: message,
                                delegate: nil,
                                cancelButtonTitle: NSLocalizedString("OK",
                                    comment: "Error alert confirmation"
                                ))
        alert.show()
    }
}