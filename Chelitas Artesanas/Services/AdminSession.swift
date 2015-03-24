//
//  AdminSession.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/20/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import Parse

class AdminSession: NSObject {
    
    class var sharedSession: AdminSession {
        struct Static {
            static let session: AdminSession = AdminSession()
        }
        return Static.session
    }
    
    let brewery = Brewery.query()?.getFirstObject()
}