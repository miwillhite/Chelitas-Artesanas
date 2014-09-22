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
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        saveButton.enabled = false
        vendorNameField.delegate = self
    }
    
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowVendorSegue" {
            let showVendorViewController =
                segue.destinationViewController as ShowVendorViewController
            
            let realm = RLMRealm.defaultRealm()
            realm.beginWriteTransaction()
            
            var vendor = Vendor()
            vendor.title = vendorNameField.text;
            vendor.coordinate = mapView.userLocation.coordinate
            
            realm.addObject(vendor)
            
            realm.commitWriteTransaction()
        
            showVendorViewController.vendor = vendor
        }
    }
    
    // FIXME: This crashes before it hits the body...bug?
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if vendorNameField.text.isEmpty {
            notifyUserOfInvalidData()
            return false
        }
        return true
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
    
    
    // MARK: - Private
    
    private func notifyUserOfInvalidData() {
        let message = "A vendor needs a name."
        let alert = UIAlertView(title: "Invalid Data",
                                message: message,
                                delegate: nil,
                                cancelButtonTitle: "OK")
        alert.show()
    }
}