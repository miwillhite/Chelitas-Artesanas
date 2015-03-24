//
//  Vendor.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/9/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import Parse

class Vendor: PFObject, PFSubclassing, MapItemProviderProtocol {

    @NSManaged var name: String
    @NSManaged var phone: String
    @NSManaged var lat: Double
    @NSManaged var lon: Double
    @NSManaged var stockings: [Stocking]
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    
    // MARK: - PFSubclassing
    
    static func parseClassName() -> String {
        return "Vendor"
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
                if let brewery = stocking.brewery {
                    breweries.addObject(brewery)
                }
            }
            return breweries.allObjects as! [Brewery]
        }
    }
    
    var location: CLLocation {
        get {
            return CLLocation(latitude: lat, longitude: lon)
        }
    }
    
    
    // MARK: - External Services
    
    class func hydrate(data: NSDictionary) {
//        if let vendorDatas = data["vendors"] as? [NSDictionary] {
//            let realm = RLMRealm.defaultRealm()
//            realm.write({ (realm) -> Void in
//                for vendorData in vendorDatas {
//                    let vendorID = vendorData["id"] as! Int
//                    let vendorIDString = String(vendorID)
//					
//					// If a vendor is found, update its values
//                    if let foundVendor = Vendor(forPrimaryKey: vendorIDString) as Vendor? {
//                        if let name = vendorData["name"] as? String {
//                            foundVendor.name = name
//                        }
//                        if let phone = vendorData["phone"] as? String {
//                            foundVendor.phone = phone
//                        }
//                        if let lat = vendorData["lat"] as? Double {
//                            foundVendor.lat = lat
//                        }
//                        if let lon = vendorData["lon"] as? Double {
//                            foundVendor.lon = lon
//                        }
//						
//                    // If no vendor is found, create one
//                    } else {
//                        var modifiedVendorData = vendorData.mutableCopy() as! [String:AnyObject]
//                        modifiedVendorData["id"] = vendorIDString
//                        Vendor.createInDefaultRealmWithObject(modifiedVendorData)
//                    }
//                }
//            })
//        }
    }
}