//
//  ErrorHandeling.swift
//  NearBy
//
//  Created by mahmoud diab on 7/11/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation

//MARK:- Responsbility : Encapsulates error types for Network layer -

enum ErrorHandler :Error {
    case offline
    case invalidData
    case requestFailed
    case jsonConversionFail
    case jsonParsinFail
    case responseUnsuccessful
    case error(error:String)
    case APIError(error:APIErrorModel)
    
    var localizedDescription: String{
        switch self {
        case .offline:
            return "Disconnected to the internet."
        case .invalidData:
            return "Invalid data."
        case .requestFailed:
            return "Request faileded."
        case .jsonConversionFail:
            return "Json conversion failed."
        case .jsonParsinFail:
            return "Json parse fail"
        case .responseUnsuccessful:
            return "Response unsuccessful."
        case .error(let error):
            return "\(error)."
        case .APIError(let apiError ):
            return "\(apiError)."
        }
    }
}

struct APIErrorModel : Decodable {
    let code: Int
    let errorType : String?
    let errorDetail : String? 
}
