//
//  Brewery.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/10/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import Parse

class Brewery: PFObject, PFSubclassing {
    
    @NSManaged var name: String
    @NSManaged var stockings: [Stocking]
    
    @NSManaged private var websiteURLPath: String
    
    var websiteURL: NSURL? {
        get {
            return NSURL(string: websiteURLPath)
        }
        set(URL) {
            if let URLPath = URL?.path {
                websiteURLPath = URLPath
            } else {
                websiteURLPath = ""
            }
        }
    }
    

    // MARK: - PFSubclassing
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Brewery"
    }
    
    
    // MARK: - External Services
    
    class func hydrate(data: NSDictionary) {
//        if let breweries = data["breweries"] as? [NSDictionary] {
//            let realm = RLMRealm.defaultRealm()
//            realm.write({ (realm) -> Void in
//                for brewery in breweries {
//                    
//                    // Append URL
//                    var modifiedBrewery = brewery.mutableCopy() as! [String: AnyObject]
//                    if let url = brewery["url"] as? String {
//                        modifiedBrewery["websiteURLPath"] = url
//                    }
//                    
//                    let breweryID = brewery["id"] as! Int
//                    let breweryIDString = String(breweryID)
//                    modifiedBrewery["id"] = breweryIDString
//                    
//                    if let foundBrewery = Brewery(forPrimaryKey: breweryIDString) as Brewery? {
//                        if let name = brewery["name"] as? String {
//                            foundBrewery.name = name
//                        }
//                        if let websiteURLPath = brewery["websiteURLPath"] as? String {
//                            foundBrewery.websiteURLPath = websiteURLPath
//                        }
//                    } else {
//                        Brewery.createInDefaultRealmWithObject(modifiedBrewery)
//                    }
//                }
//            })
//        }
    }
}