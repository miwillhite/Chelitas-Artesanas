//
//  Brewery.swift
//  Chelitas Artesanas
//
//  Created by Matthew Willhite on 9/10/14.
//  Copyright (c) 2014 Notion. All rights reserved.
//

import Foundation
import Parse

class Brewery: PFObject, PFSubclassing {
    
    @NSManaged var name: String
    @NSManaged var stockings: [Stocking]
    
    @NSManaged private var websiteURLPath: String
    
    var websiteURL: NSURL? {
        get {
            return NSURL(string: websiteURLPath)
        }
        set(URL) {
            if let URLPath = URL?.path {
                websiteURLPath = URLPath
            } else {
                websiteURLPath = ""
            }
        }
    }
    
    private var _logoThumbnailImage: UIImage?
    func getLogoThumbnailImage() -> UIImage? {
        if let image = _logoThumbnailImage {
            return image
        } else {
            if let
                thumbnailFile = (self["logoThumbnail180"] as? PFFile),
                file = thumbnailFile.getData(),
                image = UIImage(data: file) {
                _logoThumbnailImage = image
            }
            return _logoThumbnailImage
        }
    }
    

    // MARK: - PFSubclassing
    
    override class func initialize() {
        var onceToken: dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            self.registerSubclass()
        }
    }
    
    static func parseClassName() -> String {
        return "Brewery"
    }
}