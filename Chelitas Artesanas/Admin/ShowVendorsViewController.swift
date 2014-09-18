//
//  ShowVendorsViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/17/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import UIKit

class ShowVendorsViewController: UITableViewController {
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.toolbar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.toolbar.hidden = false
    }
}