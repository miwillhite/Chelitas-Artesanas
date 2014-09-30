//
//  NSDateFormatter.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/29/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation

extension NSDateFormatter {
    convenience init(format: String) {
        self.init()
        self.dateFormat = format
    }
    
    class func stringFromDate(date: NSDate, format: String) -> String {
        let dateFormatter = NSDateFormatter(format: format)
        return dateFormatter.stringFromDate(date)
    }
}