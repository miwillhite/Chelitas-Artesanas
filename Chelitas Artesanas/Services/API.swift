//
//  API.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/30/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import Alamofire
import Realm

let baseURLString = "http://mwillhite.local:3001"

extension RLMObject {
    func asJSON() -> [String:AnyObject] {
        // TODO Serialize the object
        return [String:AnyObject]()
    }
}

class API: NSObject {
    
    class func sync(completion: ((error: NSError!) -> Void)) {
        Alamofire.request(.GET, "\(baseURLString)/vendors").responseJSON { (_, _, JSON, error) -> Void in
            completion(error: error)
            
            if let e = error {
                // Do nothing
            } else {
                self.handleResponse(JSON!)
            }
        }
    }
    
    class func push(obj: RLMObject) {
        func push(path: String, `as` key: String) {
            Alamofire.request(.POST, "\(baseURLString)\(path)",
                parameters: [key: obj.asJSON()],
                encoding: .JSON
            ) // TODO: Handle response
        }
        
        switch obj {
        case obj as Vendor:
            push("/vendors", `as`: "vendor")
        case obj as Stocking:
            push("/stockings", `as`: "stocking")
        default:
            // TODO: Inform the user with an error
            println("Unable to push type of \(obj)")
            return
        }
    }
    
    private class func handleResponse(JSON: AnyObject) {
        if let data = JSON as? NSDictionary {
            Vendor.hydrate(data)
            Brewery.hydrate(data)
            Stocking.hydrate(data)
        }
    }
}