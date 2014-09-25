// Playground - noun: a place where people can play

import UIKit

var number: Double?

if let number = number {
    println(number)
} else {
    println(number)
}


/*

TODOs
=====

[ ] ‼️Localization

Connect vendor show to an actual vendor
    [x] Show title
    [x] Map location
    [x] Brewer information
    [x] Last stock information
    [x] Update stock

New locale view
    [x] View controller
    [~] Do not return to this VC after creation: http://stackoverflow.com/questions/21414786/instead-of-push-segue-how-to-replace-view-controller-or-remove-from-navigation
        [~] Verification (both on uniqueness and empty)
    [x] Name input
    [~] Location on map (make this adjustable?)
    [x] Save button (takes user to show view)
    [x] Move save button to the top right
    [~] Change Vendors button to Back

Client side
    [ ] add logo and link to About section
    [ ] add link to brewery's section
    [ ] add search bar, searches on brewery

Vendors list
    [ ] sort by shortest distance

Login
    [ ] slide down to reveal vendor list (custom transition)
    [ ] collect data
    [ ] stub out api connection
    [ ] current brewery

General
    [ ] App needs to pull down location data when it logs in
    [ ] Implement MapBox https://www.mapbox.com
    [ ] List open source software used in About
    [ ] private outlets
    [ ] look at dynamic text sizing
    [ ] hide navbar on scroll
    [ ] ‼️ look at using a view model for this data
    [ ] ‼️ abstract out map as Map <-------------------<<
    [ ] ‼️ instead of setting the public vendor property in the list view, just set the tableviewcell as the sender

Mapper
    [ ] Shows user location on map
    [ ] Shows annotations
    [ ] Requests permission

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




Web Backend
===========

Lists all locations, powers to edit name, location

NOTE:
If Brewer A creates a location, it will show up for Brewer B.
If Brewer B wants to change the location, he can do so, but it is submitted for everyone else to vote on the change.
Majority wins.


Map Kit Notes
=============

If GPS accuracy isn't critical and you don't need continuous tracking use the "significant-change" location service.
Doesn't track continuously and only wakes the device when significant changes occur. (500m or more)

*/

