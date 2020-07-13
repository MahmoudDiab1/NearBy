//
//  PersistenceService.swift
//  NearBy
//
//  Created by mahmoud diab on 7/11/20.
//  Copyright © 2020 Diab. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//MARK:-  Responsbility :- Works as middle layer between view controllers and PersistenceEngine. -

class persistenceService {
    static let shared = persistenceService()
    var cachedEntity = "VenueModel"
    
    //  Read
    func loadCashedItems ( completion:@escaping(Result<[VenueModel],Error>)->()) {
        persistenceEngine.fetch(entityName: cachedEntity) { result in
            completion(result)
        }
    }
    
    // Delete
    func deleteCashedItems (completion:@escaping(Result<Bool,Error>)->() ) {
        persistenceEngine.resetAllRecords(in: cachedEntity) { result in
            completion(result)
        }
    }
    
    // Add
    func saveData (item:Venue ,venueImage:Data?, completion:@escaping(Result<Bool,Error>)->()) {
        persistenceEngine.save(venue: item, venueImage: venueImage) { result in
            completion(result)
        }
    }
     
}
