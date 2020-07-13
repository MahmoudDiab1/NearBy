//
//  ExploreModel.swift
//  NearBy
//
//  Created by mahmoud diab on 7/7/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

struct ExploreModel:Decodable{
    let meta: Meta
    let response: Response
}

// MARK: - Meta
struct Meta: Decodable {
    let code: Int?
    let requestID: String?
    enum CodingKeys: String, CodingKey {
        case code
        case requestID = "requestId"
    }
}



// MARK: - Response
struct Response: Decodable{
    let suggestedRadius: Int?
    let headerLocation:String?
    let headerFullLocation:String?
    let headerLocationGranularity: String?
    let totalResults: Int?
    let groups: [Group]
}




// MARK: - Groups
struct Group:Decodable {
    let items: [GroupItem]?
}
struct GroupItem: Decodable{
    let venue: Venue?
}




// MARK: - Venue
struct Venue:Decodable {
    let id:String?
    let name: String?
    let location: Location?
    let popularityByGeo: Double?
}




// MARK: - Location
struct Location: Decodable {
    let address, crossStreet: String?
    let lat, lng: Double?
    //  let labeledLatLngs: [LabeledLatLng]?
    let distance: Int?
    let postalCode, cc, city, state: String?
    let country: String?
    let formattedAddress: [String]?
    
} 
