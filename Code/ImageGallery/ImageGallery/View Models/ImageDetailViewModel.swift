//
//  ImageDetailViewModel.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 28/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
import UIKit
class ImageDetailViewModel: ImageDetailViewModelProtocol {
    var imageDetailDataModel: ImageDataModel
    // get the title of photo, part of ImageDetailViewModelProtocol
    func getTitle() -> String {
        return imageDetailDataModel.title
    }
    // get the link, part of ImageDetailViewModelProtocol
    func getLink() -> URL? {
        return imageDetailDataModel.link
    }
    // get the image url, part of ImageDetailViewModelProtocol
    func getImageUrl() -> URL? {
        return imageDetailDataModel.imageUrl
    }
    // get the description, part of ImageDetailViewModelProtocol
    func getDescription() -> String {
        return imageDetailDataModel.description
    }
    // get the tags of the photo, part of ImageDetailViewModelProtocol
    func getTags() -> [String] {
        return imageDetailDataModel.tags
    }
    // get the date photo was taken, part of ImageDetailViewModelProtocol
    func getDateTaken() -> Date? {
        return imageDetailDataModel.dateTaken
    }
    // get the date when photo was published, part of ImageDetailViewModelProtocol
    func getDatePublished() -> Date? {
        return imageDetailDataModel.datePublished
    }
    // get the author name, part of ImageDetailViewModelProtocol
    func getAuthorName() -> String {
        return imageDetailDataModel.author.name
    }
    // get the authorid, part of ImageDetailViewModelProtocol
    func getAutorId() -> String {
        return imageDetailDataModel.author.id
    }
    // get the contents to share, part of ImageDetailViewModelProtocol
    func getShareContent() -> [Any]? {
        guard let link = self.getLink() else {
            return nil
        }
        let title = "Checkout this post from flicker"
        let shareContents: [Any] = [title, link]
        return shareContents
    }
    // get downloaded image from given url and cached in directory, part of ImageDetailViewModelProtocol
    func getDownloadedImage(from url: String, _ completion: @escaping (UIImage?) -> ()) {
        if ProcessInfo.processInfo.arguments.contains("USE_MOCK_SERVER") {
            ImageDownloader(with: CommsProviderMock()).downloadImage(urlString: url) { (image, error) in
                completion(image)
            }
        } else {
            ImageDownloader(with: CommsProvider.shared).downloadImage(urlString: url) { (image, error) in
                completion(image)
            }
        }
        
    }
    // initializer, part of ImageDetailViewModelProtocol
    required init(with dataModel: ImageDataModel) {
        self.imageDetailDataModel = dataModel
    }
}
