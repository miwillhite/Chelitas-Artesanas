//
//  Stocking.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/10/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import Realm

class Stocking: RLMObject {
    dynamic var id              = ""
    dynamic var brewery         = Brewery()
    dynamic var vendor          = Vendor()
    dynamic var createdAt       = NSDate()
    
    override class func primaryKey() -> String! {
        return "id"
    }
    
    
    
    // MARK: - External Services
    
    class func hydrate(data: NSDictionary) {
        if let stockings = data["stockings"] as? [NSDictionary] {
            let realm = RLMRealm.defaultRealm()
            realm.write({ (realm) -> Void in
                for stocking in stockings {
                    
                    // Convert the string date to NSDate
                    var modifiedStocking = stocking.mutableCopy() as [String:AnyObject]
                    if let createdAtString = stocking["created_at"] as? String {
                        let formatter = NSDateFormatter(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'")
                        modifiedStocking["createdAt"] = formatter.dateFromString(createdAtString)
                    }
                    
                    var stg: Stocking
                    
                    let stockingID = stocking["id"] as Int
                    if let foundStocking = Stocking.objectsWhere("id = %@", String(stockingID)).lastObject()? as? Stocking {
                        if let createdAt = modifiedStocking["createdAt"] as? NSDate {
                            foundStocking.createdAt = createdAt
                        }
                        stg = foundStocking
                    } else {
                        modifiedStocking["id"] = String(stockingID)
                        stg = Stocking.createInDefaultRealmWithObject(modifiedStocking)
                    }

                    // Wire up associations
                    if let vendorID = stocking["vendor_id"] as? Int {
                        stg.vendor = Vendor.objectsWhere("id = %@", String(vendorID)).lastObject() as Vendor
                        stg.vendor.stockings.addObject(stg)
                    }
                    
                    if let breweryID = stocking["brewery_id"] as? Int {
                        stg.brewery = Brewery.objectsWhere("id = %@", String(breweryID)).lastObject() as Brewery
                        stg.brewery.stockings.addObject(stg)
                    }
                }
            })
        }
    }
}