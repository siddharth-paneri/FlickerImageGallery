//
//  ImageDetailViewModelProtocol.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 28/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
import UIKit
protocol ImageDetailViewModelProtocol {
    /**
     This variable should be implemented inside image detail view model.
     Should be used to get image data model
     */
    var imageDetailDataModel: ImageDataModel { get }
    /**
     This function should be implemented inside image detail view model.
     Should be used to get the photo title
     - Returns: string object with photo title
     */
    func getTitle() -> String
    /**
     This function should be implemented inside image detail view model.
     Should be used to get the photo title
     - Returns: URL object with photo link
     */
    func getLink() -> URL?
    /**
     This function should be implemented inside image detail view model.
     Should be used to get the photo image url
     - Returns: URL object with photo image url
     */
    func getImageUrl() -> URL?
    /**
     This function should be implemented inside image detail view model.
     Should be used to get the photo description
     - Returns: String object with photo description
     */
    func getDescription() -> String
    /**
     This function should be implemented inside image detail view model.
     Should be used to get the photo tags
     - Returns: [String], array of strings with tags for photo
     */
    func getTags() -> [String]
    /**
     This function should be implemented inside image detail view model.
     Should be used to get the photo date taken
     - Returns: Date object for date taken of a photo
     */
    func getDateTaken() -> Date?
    /**
     This function should be implemented inside image detail view model.
     Should be used to get the photo date published
     - Returns: Date object with date published of a photo
     */
    func getDatePublished() -> Date?
    /**
     This function should be implemented inside image detail view model.
     Should be used to get the photo's author name
     - Returns: String object with photo author name
     */
    func getAuthorName() -> String
    /**
     This function should be implemented inside image detail view model.
     Should be used to get the photo author id
     - Returns: Stirng object with photo author id
     */
    func getAutorId() -> String
    /**
     This function should be implemented inside image detail view model.
     Should be used to get the share content
     - Returns: [Any], array of content to be shared
     */
    func getShareContent() -> [Any]?
    /**
     This function should be implemented inside image detail view model.
     Should be used to download the image using a url
     - Parameter url: String object containing url
     - Parameter completion: completion block containing image object
     */
    func getDownloadedImage(from url: String, _ completion: @escaping (UIImage?)->())
    /**
     This initializer function should be implemented inside image detail view model.
     Should be used to get the photo title
     - Parameter dateModel: ImageDataModel object
     */
    init(with dataModel: ImageDataModel)
    
}
