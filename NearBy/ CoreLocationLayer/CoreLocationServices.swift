//
//  CoreLocationServices.swift
//  NearBy
//
//  Created by mahmoud diab on 7/10/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

class CoreLocationService { 
  class  func getLocation(appMode:AppModeEndPoint, completion:@escaping(LocationData)->())   {
        CoreLocationEngine.shared.checkLocationServices(currentAppMode: appMode)
        var locationData = LocationData()
        locationData.latitude = UserDefaults.standard.double(forKey: StaticValues.shared.currentLatitude)
        locationData.longitude  = UserDefaults.standard.double(forKey: StaticValues.shared.currentLongitude)
        completion(locationData)
    }
    
}
