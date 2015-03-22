//
//  Vendor.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/9/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import Realm

var vendorSubscriptionToken: RLMNotificationToken?

class Vendor: RLMObject, MapItemProviderProtocol {
    
    dynamic var id = ""
    dynamic var name = ""
    dynamic var phone = ""
    dynamic var lat: Double = 0.0
    dynamic var lon: Double = 0.0
    dynamic var stockings = RLMArray(objectClassName: Stocking.className())
    
    override class func primaryKey() -> String! {
        return "id"
    }
    
    
    // MARK: - Ignored Properties
    
    override class func ignoredProperties() -> [AnyObject]! {
        return ["stockedBreweries", "title", "location"]
    }
    
    // Required to conform to the MapItemProviderProtocol
    var title: String {
        get {
            return name
        }
    }
    
    var stockedBreweries: [Brewery] {
        get {
            var breweries = NSMutableSet()
            for stocking in self.stockings {
                if let stocking = stocking as? Stocking {
					if let brewery = stocking.brewery {
						breweries.addObject(brewery)
					}
                }
            }
            return breweries.allObjects as [Brewery]
        }
    }
    
    var location: CLLocation {
        get {
            return CLLocation(latitude: lat, longitude: lon)
        }
    }
    
    
    // MARK: - Object Lifecycle
    
    deinit {
        let realm = RLMRealm.defaultRealm()
        realm.removeNotification(vendorSubscriptionToken)
    }
    
    
    // MARK: - Helpers
    
    // WARNING: This could be inefficient...
    class func allObjectsAsArray() -> [Vendor] {
        var vendors = [Vendor]()
        for vendor in Vendor.allObjects() {
            if let vendor = vendor as? Vendor {
                vendors.append(vendor)
            }
        }
        return vendors;
    }
    
    
    // MARK: - External Services
    
    class func hydrate(data: NSDictionary) {
        if let vendorDatas = data["vendors"] as? [NSDictionary] {
            let realm = RLMRealm.defaultRealm()
            realm.write({ (realm) -> Void in
                for vendorData in vendorDatas {
                    let vendorID = vendorData["id"] as Int
                    let vendorIDString = String(vendorID)
					
					// If a vendor is found, update its values
                    if let foundVendor = Vendor(forPrimaryKey: vendorIDString) as Vendor? {
                        if let name = vendorData["name"] as? String {
                            foundVendor.name = name
                        }
                        if let phone = vendorData["phone"] as? String {
                            foundVendor.phone = phone
                        }
                        if let lat = vendorData["lat"] as? Double {
                            foundVendor.lat = lat
                        }
                        if let lon = vendorData["lon"] as? Double {
                            foundVendor.lon = lon
                        }
						
                    // If no vendor is found, create one
                    } else {
                        var modifiedVendorData = vendorData.mutableCopy() as [String:AnyObject]
                        modifiedVendorData["id"] = vendorIDString
                        Vendor.createInDefaultRealmWithObject(modifiedVendorData)
                    }
                }
            })
        }
    }
    
    class func subscribe(onUpdate: (() -> Void)!) {
        let realm = RLMRealm.defaultRealm()
        // TODO: Scope this to just relevant data
        vendorSubscriptionToken = realm.addNotificationBlock { (note, realm) -> Void in
            onUpdate()
        }
    }
}