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
 // let suggestedBounds: SuggestedBounds?
 // let warning: Warning?
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
    //  let categories: [Category]?
    //  let venuePage: VenuePage?
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

//// MARK: - LabeledLatLng
//struct LabeledLatLng: Decodable {
//    let label: String?
//    let lat, lng: Double?
//}
//
//// MARK: - VenuePage
//struct VenuePage: Decodable {
//    let id: String?
//}
//
//// MARK: - SuggestedBounds
//struct SuggestedBounds: Decodable{
//    let ne, sw: Ne?
//}
//
//// MARK: - Ne
//struct Ne: Decodable{
//    let lat, lng: Double?
//}
//
//// MARK: - Warning
//struct Warning: Decodable {
//    let text: String?
//}


///______________________________________________________________________

//
//// MARK: - Category
//struct Category: Decodable {
//    let id:String?
//    let name:String?
//    let pluralName:String?
//    let shortName: String?
//    let icon: Icon?
//    let primary: Bool?
//}
//
//// MARK: - Icon
//struct Icon:Decodable {
//    let iconPrefix: String?
//    let suffix: String?
//
//    enum CodingKeys: String, CodingKey {
//        case iconPrefix = "prefix"
//        case suffix
//    }
//}
