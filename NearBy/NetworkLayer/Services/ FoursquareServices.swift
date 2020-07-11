//
//  FoursquareServices.swift
//  NearBy
//
//  Created by mahmoud diab on 7/7/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

class FoursquareServices {
    
    //MARK:- Responsible for getting group items (each item contains reasons item struct and Venue struct) -
    
    class  func getGroupItems (latitude:Double, longtude:Double , completion:@escaping(Result<ExploreModel?,ErrorHandler>)->()) { 
        NetworkEngine.fetchData(serviceEndPoint: FoursquareEndPoints.getPlaces(lat:latitude, long: longtude)) { (result:Result<ExploreModel?,ErrorHandler>) in
            completion(result) 
        }
    } 
    class func getVenuePhotos(venue:Venue?,completion:@escaping(Result<VenuePhotoModel?,ErrorHandler>)->()) {
        guard let venueId = venue?.id else {return}
        NetworkEngine.fetchData(serviceEndPoint: FoursquareEndPoints.getVenueImages(venueId: venueId)) { (result:Result<VenuePhotoModel?, ErrorHandler>) in
            completion(result)
        }
    }
}