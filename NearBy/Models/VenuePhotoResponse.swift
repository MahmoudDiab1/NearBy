//
//  getVenuePhotoResponse.swift
//  NearBy
//
//  Created by mahmoud diab on 7/8/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation
 
struct VenuePhotoModel: Decodable {
    let meta: PhotoMeta?
    let response: PhotoResponse?
}

// MARK: - Meta
struct PhotoMeta: Decodable {
    let code: Int?
    let requestID: String?

    enum CodingKeys: String, CodingKey {
        case code
        case requestID = "requestId"
    }
}

// MARK: - Response
struct PhotoResponse: Decodable {
    let photos: Photos?
}

// MARK: - Photos
struct Photos: Decodable {
    let count: Int?
    let items: [Item?]
    let dupesRemoved: Int?
}

// MARK: - Item
struct Item: Codable {
    let id: String?
    let createdAt: Int?
    let source: Source?
    let prefix: String?
    let suffix: String?
    let width, height: Int?
    let user: User?
    let checkin: Checkin?
    let visibility: String?
 
}

// MARK: - Checkin
struct Checkin: Codable {
    let id: String?
    let createdAt: Int?
    let type: String?
    let timeZoneOffset: Int?
}

// MARK: - Source
struct Source: Codable {
    let name: String?
    let url: String?
}

// MARK: - User
struct User: Codable {
    let id, firstName, lastName: String?
    let photo: Photo?
}

// MARK: - Photo
struct Photo: Codable {
    let prefix: String?
    let suffix: String?
 
}
