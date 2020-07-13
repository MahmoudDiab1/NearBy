
//  PersistenceEngine.swift
//  NearBy
//
//  Created by mahmoud diab on 7/11/20.
//  Copyright © 2020 Diab. All rights reserved.


import Foundation
import CoreData
import UIKit
class persistenceEngine {
    
    
    
    //MARK:- Delete All VenueModelRecords
    class  func resetAllRecords(in entity : String,completion:@escaping(Result<Bool,Error>)->()) {  let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
            DispatchQueue.main.async {
                completion(.success(true))
            }
            
        } catch let error as NSError {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
    
    
    
    //MARK:- Save venue record
    class   func save(venue:Venue,venueImage:Data?,completion:@escaping(Result<Bool,Error>)->()) {
         
            let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
            let venueToSave = VenueModel(context: context)
        if let image = venueImage {
            venueToSave.venuePhoto = image
        }
            venueToSave.name = venue.name
            venueToSave.id = venue.id
            venueToSave.address = venue.location?.address
            
            DispatchQueue.main.async {
                do {
                    try  context.save()
                    completion(.success(true))
                    
                } catch let error as NSError {
                    completion(.failure(error))
                    
                }
            }
           
    }
        //MARK:-Fetch all Venues array of NSManagedObject
      class  func fetch (entityName:String,completion:@escaping(Result<[VenueModel],Error>)->())  {
        
        DispatchQueue.main.async {
                let context = ( UIApplication.shared.delegate as! AppDelegate ).persistentContainer.viewContext
                let fetchRequest =  NSFetchRequest<VenueModel>(entityName: entityName)

                do {
                    let  fetchedData = try context.fetch(fetchRequest)
                    completion(.success(fetchedData))
                } catch let error as NSError {
                    completion(.failure(error))
                }
                
            }
        }


}
