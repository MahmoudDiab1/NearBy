//
//   FoursquareEndPoints.swift
//  NearBy
//
//  Created by mahmoud diab on 7/7/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

//MARK:- Responsbility : Responsible for configuring the request parts(scheme/base/path/parameter/method) -

enum  FoursquareEndPoints:Endpoint {
    case getPlaces(lat:Double, long:Double)
    case getVenueImages(venueId:String)
}

extension FoursquareEndPoints {
    var scheme:String {
        switch self {
        default:
            return "https"
        }
    }
    
    var base: String {
        switch self {
        default:
            return "api.foursquare.com"
        }
    }
    
    var path : String {
        switch self {
        case .getPlaces  :
            return "/v2/venues/explore"
        case .getVenueImages(let id):
            return "/v2/venues/\(id)/photos"
        } 
    }
    
    var parameter: [URLQueryItem] {
        switch self {
        case .getPlaces(let lat,let long ):
            let letLongValue = "\(lat),\(long)"
            let currentDate = getCurrentDate()
            
            return [
                URLQueryItem(name: "client_id", value:"EL3PLU05YWWHUURZBZS0EJQ24E5H3KCE3JBM1JZKAQ50T3I2"),
                URLQueryItem(name: "client_secret" ,value: "0Z5ULLCBFSNV0ED1K4U4SV3I1WTQ0Y1LUFE3KPKCC03W30MH"),
                URLQueryItem(name: "ll", value: letLongValue),
                URLQueryItem(name: "v", value: currentDate),
                URLQueryItem(name: "limit", value: "5"),
                URLQueryItem(name: "radius", value: "1000"),
                URLQueryItem(name: "sortByDistance", value: "1")
            ]
        case .getVenueImages:
            let currentDate = getCurrentDate()
            return [
                URLQueryItem(name: "client_id", value:"EL3PLU05YWWHUURZBZS0EJQ24E5H3KCE3JBM1JZKAQ50T3I2"),
                URLQueryItem(name: "client_secret" ,value: "0Z5ULLCBFSNV0ED1K4U4SV3I1WTQ0Y1LUFE3KPKCC03W30MH"),
                URLQueryItem(name: "v", value: currentDate),
                URLQueryItem(name: "limit", value: "1"),
            ]
        }
    }
    var method: String {
        switch self {
        case .getPlaces, .getVenueImages  :
            return "GET"
        }
    }
}

//Get current Date
func getCurrentDate()-> String { return Date().string(format: "yyyyMMDD")  }

