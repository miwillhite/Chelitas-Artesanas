//
//  Stocking.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/10/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import Parse

class Stocking: PFObject, PFSubclassing {

	@NSManaged var brewery: Brewery?
	@NSManaged var vendor: Vendor?
    
    // MARK: - PFSubclassing
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Stocking"
    }
    
    // MARK: - External Services
    
    class func hydrate(data: NSDictionary) {
//        if let stockings = data["stockings"] as? [NSDictionary] {
//            let realm = RLMRealm.defaultRealm()
//            realm.write({ (realm) -> Void in
//                for stocking in stockings {
//                    
//                    // Convert the string date to NSDate
//                    var modifiedStocking = stocking.mutableCopy() as! [String:AnyObject]
//                    if let createdAtString = stocking["created_at"] as? String {
//                        let formatter = NSDateFormatter(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
//                        modifiedStocking["createdAt"] = formatter.dateFromString(createdAtString)
//                    }
//                    
//                    var stg: Stocking
//                    
//                    let stockingID = stocking["id"] as! Int
//                    let stockingIDString = String(stockingID)
//                    if let foundStocking = Stocking(forPrimaryKey: stockingIDString) as Stocking? {
//                        if let createdAt = modifiedStocking["createdAt"] as? NSDate {
//                            foundStocking.createdAt = createdAt
//                        }
//                        stg = foundStocking
//                    } else {
//                        modifiedStocking["id"] = stockingIDString
//                        stg = Stocking.createInDefaultRealmWithObject(modifiedStocking)
//                        
//                        // Wire up associations
//                        if let vendorID = stocking["vendor_id"] as? Int {
//                            stg.vendor = Vendor(forPrimaryKey: String(vendorID))
//							if let vendor = stg.vendor {
//								vendor.stockings.addObject(stg)
//							}
//                        }
//                        
//                        if let breweryID = stocking["brewery_id"] as? Int {
//                            stg.brewery = Brewery(forPrimaryKey: String(breweryID))
//							if let brewery = stg.brewery {
//								brewery.stockings.addObject(stg)
//							}
//                        }
//                    }
//                }
//            })
//        }
    }
}