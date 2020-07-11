
//  PersistenceEngine.swift
//  NearBy
//
//  Created by mahmoud diab on 7/11/20.
//  Copyright © 2020 Diab. All rights reserved.


import Foundation
import CoreData
import UIKit

class persistenceEngine {
    static let shared = persistenceEngine()
    let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
    
    //MARK:- Delete All VenueModelRecords
    func resetAllRecords(in entity : String,completion:(Result<Bool,Error>)->()) { // entity = Your_Entity_Name
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
            completion(.success(true))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
    
    
    
    //MARK:- Save venue record
    func save(venue: Venue,completion:(Result<Bool,Error>)->()) {
        let venueToSave = VenueModel(context: context)
        venueToSave.name = venue.name
        venueToSave.id = venue.id
        venueToSave.address = venue.location?.address
        do {
            try  context.save()
            completion(.success(true))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
    
    
    
    //MARK:-Fetch all Venues array of NSManagedObject
    func fetch (entityName:String,completion:(Result<[NSManagedObject],Error>)->()) {
        let fetchRequest =  NSFetchRequest<NSManagedObject>(entityName: entityName)
        do {
            let  fetchedData = try context.fetch(fetchRequest)
            completion(.success(fetchedData))
        } catch let error as NSError {
            completion(.failure(error))
        }
    }
}
