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
            vendor.title = vendorNameField.text;
            vendor.coordinate = mapView.userLocation.coordinate
            
            // Add to the realm
            realm.addObject(vendor)
        }
        
        realm.commitWriteTransaction()
    }
    
    private func notifyUserOfInvalidData() {
        let message = "A vendor needs a name."
        let alert = UIAlertView(title: "Invalid Data",
                                message: message,
                                delegate: nil,
                                cancelButtonTitle: "OK")
        alert.show()
    }
}