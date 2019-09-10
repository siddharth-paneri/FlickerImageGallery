//
//  AuthorEntity+CoreDataProperties.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 27/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//
//

import Foundation
import CoreData


extension AuthorEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AuthorEntity> {
        return NSFetchRequest<AuthorEntity>(entityName: "AuthorEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: String?
    @NSManaged public var email: String?
    @NSManaged public var images: NSSet?

}

// MARK: Generated accessors for images
extension AuthorEntity {

    @objc(addImagesObject:)
    @NSManaged public func addToImages(_ value: ImageEntity)

    @objc(removeImagesObject:)
    @NSManaged public func removeFromImages(_ value: ImageEntity)

    @objc(addImages:)
    @NSManaged public func addToImages(_ values: NSSet)

    @objc(removeImages:)
    @NSManaged public func removeFromImages(_ values: NSSet)

}
