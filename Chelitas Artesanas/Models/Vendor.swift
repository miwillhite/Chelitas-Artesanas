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
    
    dynamic var id              = ""
    dynamic var title           = ""
    dynamic var lat: Double     = 0.0
    dynamic var lon: Double     = 0.0
    dynamic var stockings       = RLMArray(objectClassName: Stocking.className())
    
    override class func primaryKey() -> String! {
        return "id"
    }
    
    
    // MARK: - Ignored Properties
    
    override class func ignoredProperties() -> [AnyObject]! {
        return ["stockedBreweries"]
    }
    
    var stockedBreweries: [Brewery] {
        get {
            var breweries = NSMutableSet()
            for stocking in self.stockings {
                if let stocking = stocking as? Stocking {
                    breweries.addObject(stocking.brewery)
                }
            }
            return breweries.allObjects as [Brewery]
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
        if let vendors = data["vendors"] as? [NSDictionary] {
            let realm = RLMRealm.defaultRealm()
            realm.write({ (realm) -> Void in
                for vendor in vendors {
                    
                    // FIXME: So so gross...just fix it...
                    let vendorID = vendor["id"] as Int
                    if let foundVendor = Vendor.objectsWhere("id = %@", String(vendorID)).lastObject()? as? Vendor {
                        if let title = vendor["title"] as? String {
                            foundVendor.title = title
                        }
                        if let lat = vendor["lat"] as? Double {
                            foundVendor.lat = lat
                        }
                        if let lon = vendor["lon"] as? Double {
                            foundVendor.lon = lon
                        }
                    // If no vendor is found, create one
                    } else {
                        var modifiedVendor = vendor.mutableCopy() as [String:AnyObject]
                        modifiedVendor["id"] = String(vendorID)
                        Vendor.createInDefaultRealmWithObject(modifiedVendor)
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