//
//  Array.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/20/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation

extension Array {
    func combine(separator: String) -> String {
        var str: String = ""
        for (idx, item) in enumerate(self) {
            str += "\(item)"
            if idx < self.count - 1 {
                str += separator
            }
        }
        return str
    }
    
    func sample() -> T {
        let randomIndex = random() % count
        return self[randomIndex]
    }
}