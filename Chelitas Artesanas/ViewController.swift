//
//  ViewController.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/6/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let map: VendorMap
    
    required init(coder aDecoder: NSCoder) {
        map = VendorMap()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.view.frame = self.view.bounds
        self.view.addSubview(map.view)
        
        map.locationManager.requestWhenInUseAuthorization()
        
        /*
        map.getUsersLocation()
        map.renderBrewerLocations()
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

