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

1️⃣2️⃣3️⃣

[ ] find-or-create in sync, get rid of data clear on app startup
[ ] mimetype
[ ] Localization

[ ] add search bar, searches on brewery [MAP]

[ ] Option to leave admin section [ADMIN]

Auth
    [ ] register for notifications
    [ ] grabs device token
    [ ] give user option to email device token
    [ ] email field only, also sends up device token
    [ ] current brewery (user service)

Admin Vendor list
[ ] sort by shortest distance

[ ] App needs to pull down location data when it logs in

[ ] add logo and link to About section
[ ] add link to brewery's section

Login
[ ] slide down to reveal vendor list (custom transition)

[ ] Custom icons [MAP]
[ ] Mapbox overlay
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

*/

