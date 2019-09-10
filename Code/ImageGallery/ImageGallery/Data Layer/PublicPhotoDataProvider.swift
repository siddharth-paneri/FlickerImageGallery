//
//  PublicPhotoDataProvider.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 27/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
import UIKit
/** This class will be used as the data provider for Public photos feed, this will talk to DB and Comms provider if required */
class PublicPhotoDataProvider: DataProvider, PublicPhotoDataProvideProtocol {
    // comms
    var commsProvider: PublicPhotosAPIHandlerProtocol
    // sorting order
    var sortOrder: PublicPhotosSortOrder
    // initalizer part of PublicPhotoDataProvideProtocol
    required init (with commsProvider: PublicPhotosAPIHandlerProtocol, sortOrder: PublicPhotosSortOrder) {
        self.commsProvider = commsProvider
        self.sortOrder = sortOrder
    }
    // method to fetch all public photos, part of PublicPhotoDataProvideProtocol
    func fetchAllPublicPhotos(with tags: String?, _ completion: @escaping (Bool, NetworkError?) -> ()) {
        // perform request using PublicPhotosAPIHandlerProtocol object as a comms provider
        self.commsProvider.requestPublicPhotos(with: tags, { (data, error) in
            if error != nil {
                // in future parse all error object to NetworkError objects
                completion(false, NetworkError.serverFailed)
                return
            }
            guard let responseData = data else {
                // return no data if noting is received
                completion(false, NetworkError.noData)
                return
            }
            do {
                // preform json parsing
                guard let jsonObject = try JSONSerialization.jsonObject(with: responseData, options: .mutableContainers) as? [String: Any] else {
                    // return parsing error
                    completion(false, NetworkError.jsonParseError)
                    return
                }
                // get json object and filterout requred data for public photos
                guard let items = jsonObject["items"] as? [[String: Any]] else {
                    // return parsing error
                    completion(false, NetworkError.jsonParseError)
                    return
                }
                // save the response to local DB
                self.save(publicPhotoItems: items)
                // return successfull response
                completion(true, nil)
            } catch {
                // return error
                completion(false, NetworkError.jsonParseError)
            }
        })
    }
    // fetch all public photos from DB, part of PublicPhotoDataProvideProtocol
    func fetchAllPublicPhotosFromDBOnly(with tags: String?, _ completion: @escaping ([ImageDataModel]) -> ()) {
        // get image modes from DB
        self.getImageModelsFromDb(with: tags, { (models) in
            // return models
            completion(models)
        })
    }
    // delete all stored public photos from local db, part of PublicPhotoDataProvideProtocol
    func deleteAllPublicPhotosInDb() {
        DispatchQueue.main.async {
            // feth the context
            guard let managedContext = AppDelegate.fetchManagedObjectContext() else { return }
            // delete all related objects
            self.deleteAllRecords(for: "ImageEntity", with: managedContext)
            self.deleteAllRecords(for: "AuthorEntity", with: managedContext)
        }
        
    }
    // save the json object to the local DB (using CoreData)
    private func save(publicPhotoItems: [[String: Any]]) {
        DispatchQueue.main.async {
            // fetch context
            guard let managedContext = AppDelegate.fetchManagedObjectContext() else { return }
            // fetch image records
            let imageRecords =  self.fetchRecords(for: "ImageEntity", sort: nil, predicate: nil, with: managedContext) as? [ImageEntity]
            // fetch author records
            let authorRecords =  self.fetchRecords(for: "AuthorEntity", sort: nil, predicate: nil, with: managedContext) as? [AuthorEntity]
            for item in publicPhotoItems {
                // create image entity empty object
                var imageEntity: ImageEntity?
                // convert all links to string
                if let imageIdx = imageRecords?.firstIndex(where: { (image) -> Bool in
                    // check if existing image already exist with given link
                    return image.link == item["link"] as? String
                }) {
                    // populate the object that exists in db
                    let image = imageRecords?[imageIdx]
                    imageEntity = image
                } else {
                    // create a new object and set all attributes
                    imageEntity = self.createRecord(for: "ImageEntity", with: managedContext) as? ImageEntity
                    imageEntity?.title = item["title"] as? String
                    imageEntity?.link = item["link"] as? String
                    imageEntity?.desc = item["description"] as? String
                    imageEntity?.tags = item["tags"] as? String
                    imageEntity?.dateTaken = item["date_taken"] as? String
                    imageEntity?.datePublished = item["published"] as? String
                    if let media = item["media"] as? [String: String] {
                        imageEntity?.imageUrl = media["m"]
                    }
                    
                    if let authorIdx = authorRecords?.firstIndex(where: { (author) -> Bool in
                        return author.id == item["author_id"] as? String
                    }) {
                        let author = authorRecords?[authorIdx]
                        imageEntity?.author = author
                    } else {
                        let authorEntity = self.createRecord(for: "AuthorEntity", with: managedContext) as? AuthorEntity
                        authorEntity?.id = item["author_id"] as? String
                        let authorEmailAndUserName = item["author"] as? String
                        var authorEmail = ""
                        var authorUserName = ""
                        
                        if let emailAndUserName = authorEmailAndUserName {
                            // remove the formatting from author user name and get the email id and  user name seperatley
                            var newstring = emailAndUserName
                            newstring = newstring.replacingOccurrences(of: "(", with: "")
                            newstring = newstring.replacingOccurrences(of: ")", with: "")
                            let comps = newstring.components(separatedBy: CharacterSet(["\"", "\""]))
                            let nonempty = comps.filter { (x) -> Bool in
                                !x.isEmpty
                            }
                            if nonempty.count > 0 {
                                authorEmail = nonempty[0]
                                if nonempty.count >= 2 {
                                    authorUserName = nonempty[1]
                                }
                            }
                        }
                        authorEntity?.email = authorEmail
                        authorEntity?.name = authorUserName
                        imageEntity?.author = authorEntity
                    }
                }
                // save the entity object
                imageEntity?.save()
            }

        }
    }
    // geth the stored image entities from db and convert them to image models
    private func getImageModelsFromDb(with tags: String?,_ completion: @escaping ([ImageDataModel])->()) {
        DispatchQueue.main.async {
            guard let managedContext = AppDelegate.fetchManagedObjectContext() else { return }
            var sortDescriptor: NSSortDescriptor?
            // select sorting option
            switch self.sortOrder {
            case .oldestPublished:
                sortDescriptor = NSSortDescriptor(key: #keyPath(ImageEntity.datePublished), ascending: false)
            case .latestPublished:
                sortDescriptor = NSSortDescriptor(key: #keyPath(ImageEntity.datePublished), ascending: true)
            case .oldestTaken:
                sortDescriptor = NSSortDescriptor(key: #keyPath(ImageEntity.dateTaken), ascending: false)
            case .latestTaken:
                sortDescriptor = NSSortDescriptor(key: #keyPath(ImageEntity.dateTaken), ascending: true)
            }
            // fetch data
            var predicate: NSPredicate?
            if let allTags = tags {
                predicate = NSPredicate(format: "tags contains[c] %@", allTags)
                
            }
            
            guard let imageRecords =  self.fetchRecords(for: "ImageEntity", sort: sortDescriptor, predicate: predicate, with: managedContext) as? [ImageEntity] else {
                completion([])
                return
            }
            // map to image models
            let imageDataModels = ImageDataModel.map(imageEntities: imageRecords)
            // return models
            completion(imageDataModels)
        }
        
    }
}
