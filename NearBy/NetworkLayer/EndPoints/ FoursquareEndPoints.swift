//
//  FoursquareEndPoints.swift
//  NearBy
//
//  Created by mahmoud diab on 7/7/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

//MARK:- Responsbility : Responsible for configuring the request parts(scheme/base/path/parameter/method) by conforming to (EndPoint) protocol -



/*Add your  CLIENTID and CLIENTSECRET data to be able to run app using API features
 - Note: Getting photos for places is premium features that means you have 50
 times to request for Venue photo in free mode */

//"KS2K5RHOUT5VH4OJIZ4JQ4OIDOUXZ0XKVHD20E203TSKVYWL"
// "R32CW3S4PA34OBGS5QOT2ZWWVPHPN1ACHP2RCM2HFFOZYQ4L"

private let CLIENTID = "Y2AZWEJZNENVWOL0GLZJ1BIWCCQXCTBWPJEQA5V4LBPQVVF1"
private let CLIENTSECRET = "3L4QLQVTSCJAMSPIIYGE0E1P5NY1PWT11KKNHOBAFEACBD5N"
private let resultLimit = "20"

//Configure url in different cases (designed and  seperated to keep it easy to change and update  )

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
                URLQueryItem(name: "client_id", value:CLIENTID),
                URLQueryItem(name: "client_secret" ,value: CLIENTSECRET),
                URLQueryItem(name: "ll", value: letLongValue),
                URLQueryItem(name: "v", value: currentDate),
                URLQueryItem(name: "limit", value: resultLimit),
                URLQueryItem(name: "radius", value: "1000"),
                URLQueryItem(name: "sortByDistance", value: "1")
            ]
        case .getVenueImages:
            let currentDate = getCurrentDate()
            return [
                URLQueryItem(name: "client_id", value:CLIENTID),
                URLQueryItem(name: "client_secret" ,value: CLIENTSECRET),
                URLQueryItem(name: "v", value: currentDate),
                URLQueryItem(name: "limit", value: "1")
            ]
        }
    }
    var method: String {
        switch self {
        case .getPlaces, .getVenueImages:
            return "GET"
        }
    }
}

//Get current Date
func getCurrentDate()-> String { return Date().string(format: "yyyyMMDD")  }

