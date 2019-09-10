//
//  ImageDownloaderProtocol.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 28/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
import UIKit
protocol ImageDownloaderProtocol {
    /**
     This initializer function should be implemented inside ImageDownloader class.
     - Parameter comms: provider object of type CommsProviderProtocol
     */
    init(with commsProvider: CommsProviderProtocol)
    /**
     This function should be implemented inside ImageDownloader class.
     Should be used to download image using url string
     - Parameter urlString: url of object type String for ian image
     - Parameter completionHandler: completion block returning UIImage and ImageDownloaderError object
     */
    func downloadImage(urlString: String, _ completionHandler: @escaping (UIImage?, ImageDownloaderError?) -> Void)
    /**
     This function should be implemented inside ImageDownloader class.
     Should be used to delet all the images from caching directory
     */
    func deleteImagesFromDirectory()
    /**
     This function should be implemented inside ImageDownloader class.
     Should be used to get the caching directory path
     - Returns: URL object
     */
    func getDirectoryPath() -> URL?
    /**
     This function should be implemented inside ImageDownloader class.
     Should be used to save image with given image name
     - Parameter image: UIImage object to save
     - Parameter imageName: String object containing name of image to be saved with
     - Returns: Bool with success or failure
     */
    func save(image: UIImage, with imageName: String) -> Bool
    /**
     This function should be implemented inside ImageDownloader class.
     Should be used to get the image using name
     - Returns: UIImage object
     */
    func getImage(with imageName: String) -> UIImage?
}
