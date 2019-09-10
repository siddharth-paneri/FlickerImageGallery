//
//  ImageDataModel.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 27/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation

struct ImageDataModel {
    let title: String
    let link: URL?
    let imageUrl: URL?
    let dateTaken: Date?
    let datePublished: Date?
    let description: String
    let tags: [String]
    let author: AuthorDataModel
    /** Map ImageEntity to ImageDataModel */
    static func map(imageEntities: [ImageEntity]) -> [ImageDataModel] {
        return imageEntities.compactMap { (entity) -> ImageDataModel? in
            let title = entity.title ?? ""
            let link = URL(string: entity.link ?? "")
            let imageUrl = URL(string: entity.imageUrl ?? "")
            let dateTaken = Utils.shared.getDateFrom(dateTaken: entity.dateTaken ?? "")
            let datePublished = Utils.shared.getDateFrom(dateTaken: entity.datePublished ?? "")
            let description = entity.desc ?? ""
            let tags = entity.tags?.split(separator: " ").map{ String($0)} ?? []
            let author = AuthorDataModel.map(author: entity.author)
            return ImageDataModel(title: title, link: link, imageUrl: imageUrl, dateTaken: dateTaken, datePublished: datePublished, description: description, tags: tags, author: author)
            
        }
    }
}
