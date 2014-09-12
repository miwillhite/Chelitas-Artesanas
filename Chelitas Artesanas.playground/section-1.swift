// Playground - noun: a place where people can play

import UIKit

/*

TODO
====

[x] Get lat/lon of the user
[x] Position the map there ^
[x] Plot some data
[x] Data model
[ ] Admin section
    [x] Popup view (AboutViewController)
    [ ] add logo and link to About section
    [ ] add link to brewery's section
    [ ] presents login form, which slides down to reveal admin interface
    [ ] navigation controller presents the following:
    [ ] list of vendor locations (sorted by nearness) (maybe this shows your location on a map and you can tap nearby vendors to bring them to the top of the list
    [ ] create new locale button
    [ ] vendor show: map with vendor centered, shows some data, add stock button

//////////////////////////////////////////////////
Selling points: 

By sharing all locations to all brewers: you can see where else you might want to stock

Potential for promotions, alerts for new stock (advertising),

maybe clients can vote for a new location

//////////////////////////////////////////////////

Frontend
========

Plots craft brew vendor spots
Markets, bars, etc

Marker is logo of the beer (or combination of logos)
Tap on the marker to see:
Name of locale
Beers/Brewers available
Last stocking (for each one)



Admin Section
=============

Account for each Brewer
Lists all locations, sorted by the closest to their current location
Create New
Set name, location, stocked



Web Backend
===========

Lists all locations, powers to edit name, location

NOTE:
If Brewer A creates a location, it will show up for Brewer B.
If Brewer B wants to change the location, he can do so, but it is submitted for everyone else to vote on the change.
Majority wins.



Technical
=========


Data Model
----------

Brewer
Name
Website
n Vendors

Vendor
Name
Location
n Stocks

Stock
Last updated
1 Vendor
1 Brewer


App Structuring
---------------

ViewController is the main viewcontroller
Admin is accessed via a login specific to the brewer
Map slides away to reveal



Map Kit Notes
=============

If GPS accuracy isn't critical and you don't need continuous tracking use the "significant-change" location service.
Doesn't track continuously and only wakes the device when significant changes occur. (500m or more)

*/


var frame = CGRect(x: 0, y: 0, width: 10, height: 10)
var otherFrame = frame
frame.origin.x = 100
otherFrame
frame

