//
//  RLMRealm.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/30/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import Realm

extension RLMRealm {
    func write(transactionBody: (realm: RLMRealm) -> Void) {
        self.beginWriteTransaction()
        transactionBody(realm: self)
        self.commitWriteTransaction()
    }
}