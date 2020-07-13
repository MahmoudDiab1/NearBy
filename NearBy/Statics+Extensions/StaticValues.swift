//
//  StaticValues.swift
//  NearBy
//
//  Created by mahmoud diab on 7/10/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

class StaticValues {
    public static var shared = StaticValues()
    
    //User defaults keys
    var currentLatitude = "currentLatitude"
    var currentLongitude = " currentLongitude"
    var currentMode = "currentMode"
    
    //Application modes
    var realtime = "realTime"
    var singleUpdate = "singleUpdate"
    
    //Table view statics
    var venueTableViewCellId = "VenueTableViewCell"
    var nibName = "VenueTableViewCell"
    let imagePlaceholder = "imagePlaceholder.png"
    
    
    //Images of Error conditions
    var networkDisconnectionImage = "networkDisconnectionError.png"
    var noDataAvailableImage = "noDataAvailable.png"
    var someThingWrongImage = "someThingWrong.png"
    var noVenuesAroundImage = "NoVenuesAroundYou.png"
}
