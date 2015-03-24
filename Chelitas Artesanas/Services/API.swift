//
//  API.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/30/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import Alamofire

let baseURLString = "http://mwillhite.local:3000"

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
    
    private class func handleResponse(JSON: AnyObject) {
        if let data = JSON as? NSDictionary {
            Vendor.hydrate(data)
            Brewery.hydrate(data)
            Stocking.hydrate(data)
        }
    }
}