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

        println("Vendors: \(Vendor.query()?.findObjects())")
        println("Vendors count: \(Vendor.query()?.countObjects())")
        println("Breweries count: \(Brewery.query()?.countObjects())")
        println("Stockings count: \(Stocking.query()?.countObjects())")

        // Create some Stockings
        var times = 20
        var inc = 0
        while inc < times {
            let vendor = Vendor.query()!.findObjects()?.sample() as? Vendor
            let brewery = Brewery.query()!.findObjects()?.sample() as? Brewery
            
            if let vendor = vendor, brewery = brewery {
                var stocking = Stocking(className: Stocking.parseClassName())
                stocking.vendor = vendor
                stocking.brewery = brewery
                
                stocking.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if (!success) {
                        println(error)
                    }
                })
            }
            inc += 1
        }
        
        // APNs
        let userNotificationTypes: UIUserNotificationType = (.Alert | .Badge | .Sound)
        let settings: UIUserNotificationSettings = UIUserNotificationSettings(forTypes:userNotificationTypes, categories:nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    // MARK: APNs
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.channels = ["global"]
        currentInstallation.saveInBackgroundWithBlock(nil)
    }
}

