// Playground - noun: a place where people can play

import UIKit

let a = [1, 2, 3, 1]
let b = a.filter {
    var uniqueValue = true
    for x in a {
        if x == $0 {
            uniqueValue = false
            break
        }
    }
    return uniqueValue
}
b

let set = NSSet(objects: 1, 2, 3, 1)
let arr = set.allObjects as Array

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

///////////////////////////////////////////////////////////////

enum ObjectifierMapping {
    case StringToDate(AnyObject, String)
    case IntToString(AnyObject)
    case StringToInt(String)
    case StringToDouble(String)
}

typealias ObjectifierMappingType = [String:ObjectifierMapping]

struct Objectifier {
    var out = [String:AnyObject]()

    init(data inputData: [String:AnyObject], mapping mappings: ObjectifierMappingType) {
        
        for mapping in mappings {
            out[mapping.0] = transformedValue(mapping.1)
        }
    }
    
    private func transformedValue(value: ObjectifierMapping) -> AnyObject? {
        switch value {
            
        case let .StringToDate(dateString, format):
            let dateAsString = dateString as String
            let formatter = NSDateFormatter(format: format)
            return formatter.dateFromString(dateAsString)
            
        case let .IntToString(intValue):
            return "\(intValue)"
            
        case let .StringToInt(intString):
            return nil // TODO
            
        case let .StringToDouble(doubleString):
            return nil // TODO
        }
    }
}

let response = NSDictionary(dictionary:
    [
        "id"            : 1,
        "created_at"    : "2014-08-20T04:03:28.740Z",
        "brewery_id"    : 1,
        "vendor_id"     : 1
    ])

// Convert to a Swift Dictionary
let data = response as [String : AnyObject]

// Map out the values
let mapping: ObjectifierMappingType = [
    "id"            : .IntToString(data["id"]!),
    "createdAt"     : .StringToDate(
        data["created_at"]!,
        "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    ),
    "brewery_id"    : .IntToString(data["brewery_id"]!),
    "vendor_id"     : .IntToString(data["vendor_id"]!)
]

let objectifiedData = Objectifier(
    data    : data,
    mapping : mapping
    ).out


class MyHelloWorldClass {
    func helloWithName(name: String) -> String {
        return "hello, \(name)"
    }
}

let helloWithNameFunc = MyHelloWorldClass.helloWithName
let myHelloWorldClassInstance = MyHelloWorldClass()
helloWithNameFunc(myHelloWorldClassInstance)("Mr. Roboto")


let rect1 = CGRect(x: 0, y: 0, width: 320, height: 568)
let rect2 = CGRect(x: 0, y: 170, width: 320, height: 398)

let heightDifference = CGRectGetMinY(rect1) - CGRectGetMinY(rect2)

let (map, _) = rect1.rectsByDividing(abs(heightDifference), fromEdge: .MinYEdge)

map


class SortTestModel {
    let name: String
    init(name: String) {
        self.name = name
    }
}

let s1 = SortTestModel(name: "a")
let s2 = SortTestModel(name: "b")

let sortedArr = [s2, s1].sorted { (obj1, obj2) -> Bool in
    return obj1.name < obj2.name
}

sortedArr

/*

TODOs
=====

[ ] Push data
    [x] Create Vendor endpoint [API]
    [x] Stocking endpoint [API]
    [ ] POST vendor [ ] serialize the object
    [ ] POST stocking [ ] serialize the object
[ ] idempotent data pull (think about versioning)
[ ] deal with compass indicator in map (falling behind the search bar)
|=| BENCHMARK

[ ] Sort breweries by last updated

[ ] ISSUE: Fix validation (not stopping)


[ ] register for notifications [APP]
[ ] grabs device token [APP]
[ ] give user option to email device token [LOGIN]
[ ] also sends up device token [LOGIN]
[ ] current brewery (user service) [LOGIN]
|=| BENCHMARK

[ ] Server validations

[ ] Restrict API requests to when the user is online
[ ] ensure map updates after api call
[ ] Don't let the API.push happen if the Realm commit fails
|=| BENCHMARK

[ ] Setup versioning process
http://nsscreencast.com/episodes/55-versioning
[ ] Setup test flight
[ ] RELEASE FOR TESTING alpha 1

[ ] ? Roll own search bar, searches on brewery [MAP]
|=| BENCHMARK

[ ] Brewery logos (S3, serving images) [API]
[ ] ISSUE: Fix layout with user location overlapping compass
|=| BENCHMARK

[ ] Logo ®
[ ] Mapbox overlay [MAP]
[ ] how can I speed up the vendor detail view?
[ ] get rid of unused classes Brewery.swift?
[ ] mimetype [API]

[ ] PUBLIC RELEASE v1.0

[ ] Market the shit out of this thing

[ ] slide down to reveal vendor list (custom transition) [LOGIN]
[ ] Add photo to vendor detail view
[ ] Sort vendor detail brewery list by stocking date: arraySortedByProperty:ascending
|=| BENCHMARK

[ ] 'Show' view needs to use annotation delegate
[ ] 'New' view needs to use annoation delegate

|=| BENCHMARK


MAYBES
[ ] look at using a view model for this data
[ ] List open source software used in About
[ ] private outlets
[ ] look at dynamic text sizing
[ ] hide navbar on scroll
[ ] make better json -> object mapper


Sync
====
One POST: puts up little bit of data, comes back with everything
consumes whatever I give it, be it stockings or vendors
returns the 3 points
Also need the GET for safety, POST will have to be authenticated with the device id




Selling points
==============

By sharing all locations to all brewers: you can see where else you might want to stock

Potential for promotions (good ad space for Regulars ;)

Alerts for new stock (advertising angle)



Ideas / Later
=============

Two icons, one for market, other for bar (needs distinction in database)
Clients can vote for new locations
Search on type of beer (requires beer list and classifications)


Map Kit Notes
=============

If GPS accuracy isn't critical and you don't need continuous tracking use the "significant-change" location service.
Doesn't track continuously and only wakes the device when significant changes occur. (500m or more)


Core Location Notes
===================

In request for permissions dialog and Settings.app I can set the reason why I need permission
NSLocationWhenInUseUsageDescription - Info.plist

Can now just directly to settings pane:

[[UIApplication sharedApplication] openURL: [NSURL URLWithString:UIApplicationOpenSettingsURLString]];


Attributions
============


Location by Pham Thi Dieu Linh from The Noun Project
Phone by Desbenoit from The Noun Project

*/

