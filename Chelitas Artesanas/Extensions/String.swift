//
//  String.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/25/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//
//  Copied straight from "Functional Programming in Swift"
//  http://www.objc.io/books/

import Foundation

extension String {
    static func UUID() -> String {
        let uuid = CFUUIDCreate(kCFAllocatorDefault)
        let uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuid) as NSString
        return uuidString as String
    }
}