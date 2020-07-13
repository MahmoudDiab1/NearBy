//
//  AppModeEndpoint.swift
//  NearBy
//
//  Created by mahmoud diab on 7/10/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation
import  CoreLocation

//MARK:- Responsbility : configure the response for get location function based on appe mode for fancy handeling. -

protocol AppModeEndPoint {
    var locationManager:CLLocationManager {get}
} 

enum appMode:AppModeEndPoint {
    case singleUpdateLocation
    case realTimeUpdate
}

extension appMode {
    var locationManager: CLLocationManager{
        let manager = CLLocationManager()
        manager.distanceFilter = 500
        manager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters
        manager.activityType = .other
        switch self {
        case .realTimeUpdate:
            
            manager.requestAlwaysAuthorization()
            manager.allowsBackgroundLocationUpdates = true
            manager.pausesLocationUpdatesAutomatically = false
            manager.startUpdatingLocation()
            
        case .singleUpdateLocation:
            
            manager.requestWhenInUseAuthorization()
            manager.allowsBackgroundLocationUpdates = false
            manager.pausesLocationUpdatesAutomatically = true
            manager.stopUpdatingLocation()
        }
        return manager
    }
}
