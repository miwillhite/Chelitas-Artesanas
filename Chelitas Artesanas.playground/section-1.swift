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

/*

TODOs
=====


[ ] add logo and link to About section [CLIENT]
[ ] add link to brewery's section [LOGIN]
[ ] Custom icons [MAP]
[ ] Fix user location thing (why does it always revert?) [MAP]
|=| BENCHMARK

[ ] Localization [APP]
|=| BENCHMARK

|=| PRESENT APP

[ ] Restrict API requests to when the user is online
|=| BENCHMARK

[ ] Push data
|=| BENCHMARK

[ ] register for notifications [APP]
[ ] grabs device token [APP]
[ ] give user option to email device token [LOGIN]
[ ] also sends up device token [LOGIN]
[ ] current brewery (user service) [LOGIN]
|=| BENCHMARK

[ ] sort by shortest distance [VENDOR LIST]
[ ] add search bar, searches on brewery [MAP]
|=| BENCHMARK

[ ] Mapbox overlay [MAP]
[ ] slide down to reveal vendor list (custom transition) [LOGIN]
|=| BENCHMARK

[ ] mimetype [API]
[ ] Setup versioning process 
    http://nsscreencast.com/episodes/55-versioning

|=| RELEASE

MAYBES
[ ] look at using a view model for this data
[ ] List open source software used in About
[ ] private outlets
[ ] look at dynamic text sizing
[ ] hide navbar on scroll
[ ] make better json -> object mapper




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

*/

