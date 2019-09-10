//
//  DataProvider.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 28/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
import CoreData
class DataProvider: DataProviderProtocol {
    // create a record in Core data
    func createRecord(for entity: String, with context: NSManagedObjectContext) -> NSManagedObject? {
        var result: NSManagedObject?
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: context)
        if let entityDescription = entityDescription {
            // Create Managed Object
            result = NSManagedObject(entity: entityDescription, insertInto: context)
        }
        return result
    }
    // fetch records from Core data for given entity
    func fetchRecords(for entity: String, sort: NSSortDescriptor?, predicate: NSPredicate?, with context: NSManagedObjectContext) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
                var result = [NSManagedObject]()
        if let sortDescriptor = sort {
            fetchRequest.sortDescriptors = [sortDescriptor]
        }
        fetchRequest.predicate = predicate
        do {
            // Execute Fetch Request
            let records = try context.fetch(fetchRequest)
            if let records = records as? [NSManagedObject] {
                result = records
            }
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        return result
    }
    // delete all records for given entity
    func deleteAllRecords(for entity: String, with context: NSManagedObjectContext) {
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            _ = try context.execute(request)
        } catch {
            print("Unable to delete managed objects for entity \(entity).")
        }

    }
}
