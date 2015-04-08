//
//  AppDelegate.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/6/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Parse integration
        Parse.setApplicationId("fNwPuuWottScg6TMN2tEGra8ABVG7mL78pmtUnDI", clientKey: "I8bFH634mX5XIrwFFged50bp42tirbbO6iTlJONn")
        
        // APNs
        let userNotificationTypes: UIUserNotificationType = (.Alert | .Badge | .Sound)
        let settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes:userNotificationTypes, categories:nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

        return true
    }
    
    
    // MARK: APNs
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.channels = ["global"]
        currentInstallation.saveInBackgroundWithBlock(nil)
    }
}

