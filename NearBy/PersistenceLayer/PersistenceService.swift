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

class persistenceService {
    var cachedEntity = "VenueModel"
    
    //  Read
    func getCashedItems ( completion:(Result<[NSManagedObject],Error>)->()) {
        persistenceEngine.shared.fetch(entityName: cachedEntity) { result in
            completion(result)
        }
    }
    
    // Delete
    func deleteCashedItems (completion:(Result<Bool,Error>)->()) {
        persistenceEngine.shared.resetAllRecords(in: cachedEntity) { result in
            completion(result)
        }
    }
    
    // Add
    func casheOneItem (item:Venue , completion:(Result<Bool,Error>)->()) {
        persistenceEngine.shared.save(venue:item) { result in
            completion(result)
        }
    }
}
