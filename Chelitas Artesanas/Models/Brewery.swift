//
//  Brewery.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/10/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import Realm

class Brewery: RLMObject {
    dynamic var id          = ""
    dynamic var name        = ""
    dynamic var stockings   = RLMArray(objectClassName: Stocking.className())
    
    dynamic private var websiteURLPath = ""
    dynamic var websiteURL: NSURL {
        get {
            return NSURL(string: websiteURLPath)
        }
        set(URL) {
            if let URLPath = URL.path {
                websiteURLPath = URLPath
            } else {
                websiteURLPath = ""
            }
        }
    }
    
    override class func primaryKey() -> String! {
        return "id"
    }
    
    override class func ignoredProperties() -> [AnyObject]! {
        return ["websiteURL"]
    }
    
    
    // MARK: - External Services
    
    class func hydrate(data: NSDictionary) {
        if let breweries = data["breweries"] as? [NSDictionary] {
            let realm = RLMRealm.defaultRealm()
            realm.write({ (realm) -> Void in
                for brewery in breweries {
                    
                    // Append URL
                    var modifiedBrewery = brewery.mutableCopy() as [String: AnyObject]
                    if let url = brewery["url"] as? String {
                        modifiedBrewery["websiteURLPath"] = url
                    }
                    
                    let breweryID = brewery["id"] as String
                    if let foundBrewery = Brewery.objectsWhere("id = %@", breweryID).lastObject()? as? Brewery {
                        if let name = brewery["name"] as? String {
                            foundBrewery.name = name
                        }
                        if let websiteURLPath = brewery["websiteURLPath"] as? String {
                            foundBrewery.websiteURLPath = websiteURLPath
                        }
                    } else {
                        Brewery.createInDefaultRealmWithObject(modifiedBrewery)
                    }
                }
            })
        }
    }
}