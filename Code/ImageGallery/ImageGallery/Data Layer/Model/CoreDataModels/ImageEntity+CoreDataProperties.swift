//
//  ImageEntity+CoreDataProperties.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 27/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
//

import Foundation
import CoreData


extension ImageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageEntity> {
        return NSFetchRequest<ImageEntity>(entityName: "ImageEntity")
    }

    @NSManaged public var title: String?
    @NSManaged public var link: String?
    @NSManaged public var imageUrl: String?
    @NSManaged public var dateTaken: String?
    @NSManaged public var datePublished: String?
    @NSManaged public var desc: String?
    @NSManaged public var tags: String?
    @NSManaged public var author: AuthorEntity?

}
