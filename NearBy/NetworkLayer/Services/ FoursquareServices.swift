//
//  FoursquareServices.swift
//  NearBy
//
//  Created by mahmoud diab on 7/7/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

class FoursquareServices {
    
    //MARK:-  Responsbility :- Works as middle layer between view controllers and NetworkEngine. -
    
    class  func getGroupItems (latitude:Double, longtude:Double , completion:@escaping(Result<ExploreModel?,ErrorHandler>)->()) { 
        NetworkEngine.fetchData(serviceEndPoint: FoursquareEndPoints.getPlaces(lat:latitude, long: longtude)) { (result:Result<ExploreModel?,ErrorHandler>) in
            completion(result) 
        }
    }
    //Get the first image returned from api.
    class  func getVenuePhoto(venueId:String,completion:@escaping(Result<Data?, ErrorHandler>) -> ())
    {
        FoursquareServices.getVenuePhotos(venueId:venueId) { result in
            switch result {
            case .failure(_):
                completion(.failure(.invalidData))
            case .success(let responseData):
                if let photoItem = responseData?.response?.photos{
                    guard  let prefix = photoItem.items[0]?.prefix else {return}
                    guard let suffix = photoItem.items[0]?.suffix else {return}
                    let venuePhotoString =  prefix+"original"+suffix
                    let venuePhotoUrl = URL(string:venuePhotoString)!
                    DispatchQueue.main.async {
                        do {
                            let venuePhotoData = try Data(contentsOf:venuePhotoUrl)
                            completion(.success(venuePhotoData ))
                            
                        } catch {
                            completion(.failure(.invalidData))
                        }
                    }
                    // print(venuePhotoUrl)
                }
            }
        }
    }
    
    class func getVenuePhotos(venueId:String,completion:@escaping(Result<VenuePhotoModel?,ErrorHandler>)->()) {
        NetworkEngine.fetchData(serviceEndPoint: FoursquareEndPoints.getVenueImages(venueId: venueId)) { (result:Result<VenuePhotoModel?, ErrorHandler>) in
            completion(result)
        }
    }
}
