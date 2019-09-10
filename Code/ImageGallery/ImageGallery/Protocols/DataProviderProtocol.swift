//
//  DataProviderProtocol.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 27/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
import CoreData
protocol DataProviderProtocol {
    /**
     This function should be implemented inside Data provider, and called when we need to create a  record for given entity
     - Parameter entity: enity string for which record is to be created.
     - Parameter context: managed object context.
     - Returns: NSManagedObject
     */
    func createRecord(for entity: String, with context: NSManagedObjectContext) -> NSManagedObject?
    /**
     This function should be implemented inside Data provider, and called when we need to fetch the records for given entity
     - Parameter entity: enity string for which record is to be created.
     - Parameter sort: sort descriptor object to sort the fetched data
     - Parameter predicate: add predicate to filter out data
     - Parameter context: managed object context.
     - Returns: array of all NSManagedObjects
     */
    func fetchRecords(for entity: String, sort: NSSortDescriptor?, predicate: NSPredicate?, with context: NSManagedObjectContext) -> [NSManagedObject]
    /**
     This function should be implemented inside Data provider, and called when we need to delete the records for given entity
     - Parameter entity: enity string for which record is to be created.
     - Parameter context: managed object context.
     */
    func deleteAllRecords(for entity: String, with context: NSManagedObjectContext)
}
protocol PublicPhotoDataProvideProtocol: DataProviderProtocol {
    /** This variable needs to be implemented in Public photo data provider,
     set this variable in order to update the sort order
     */
    var sortOrder: PublicPhotosSortOrder { get set }
    /** This variable needs to be implemented in Public photo data provider,
     set this variable in order to update the sort order */
    var commsProvider: PublicPhotosAPIHandlerProtocol {get}
    /**
     This intializer function should be implemented inside Public photos data provider.
     - Parameter commsProvider: Comms provide object of PublicPhotosAPIHandlerProtocol type.
     - Parameter sortOrder: sort order.
     */
    init (with commsProvider: PublicPhotosAPIHandlerProtocol, sortOrder: PublicPhotosSortOrder)
    /**
     This function should be implemented inside Public photos data provider.
     Should be called when we need to fetch public photos from api
     - Parameter tag: filter search result using tag.
     - Parameter completion: completion block returning success and NetworkError object.
     */
    func fetchAllPublicPhotos(with tags: String?,_ completion: @escaping (Bool, NetworkError?) -> ())
    /**
     This function should be implemented inside Public photos data provider.
     Should be called when we need to fetch public photos from db only
     - Parameter tag: filter search result using tag.
     - Parameter completion: completion block returning array of image data models
     */
    func fetchAllPublicPhotosFromDBOnly( with tags: String?, _ completion: @escaping ([ImageDataModel]) -> ())
    /**
     This function should be implemented inside Public photos data provider.
     Should be called when we need delete all the photos from db
     */
    func deleteAllPublicPhotosInDb()
}
