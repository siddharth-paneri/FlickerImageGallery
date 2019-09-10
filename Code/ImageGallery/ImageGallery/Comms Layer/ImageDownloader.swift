//
//  ImageDownloader.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 28/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.


import Foundation
import UIKit

/** This class is used to download and cache the image from a given URL */
class ImageDownloader: ImageDownloaderProtocol {
    // download queue
    private let downloadQueue = DispatchQueue(label: "ImageDownloadQueue")
    // comms provider object
    var commsProvider: CommsProviderProtocol
    // initializer
    required init(with commsProvider: CommsProviderProtocol) {
        self.commsProvider = commsProvider
    }
    // download an image and cache it
    func downloadImage(urlString: String, _ completionHandler: @escaping (UIImage?, ImageDownloaderError?) -> Void) {
        // create URL
        guard let url = URL(string: urlString) else {
            // ir invalid url return
            completionHandler(nil, .invalidUrl)
            return
        }
        // create url request
        let urlRequest = URLRequest(url: url)
        // create the image name using the hash value of the url to get a unique name
        let imageName = String(urlString.hashValue)
        // perform download in the download queue and not block main thread
        downloadQueue.sync { [weak self] in
            guard let weakSelf = self else { return }
            // check and get existing cached image if exists
            if let cachedImage = weakSelf.getImage(with: imageName) {
                // return cached image
                completionHandler(cachedImage, nil)
            } else {
                // get download url of the image from given url request
                weakSelf.commsProvider.performDownloadTask(with: urlRequest) { (downloadUrl, error) in
                    // use given download url and convert to data
                    if let dowloadedUrl = downloadUrl, let data = try? Data(contentsOf: dowloadedUrl), let image = UIImage(data: data) {
                        // save the given image to caching directory
                        if weakSelf.save(image: image, with: imageName) {
                            // return cached image
                            completionHandler(image, nil)
                        } else {
                            // return caching error
                            completionHandler(nil, ImageDownloaderError.cachingError)
                        }
                    } else {
                        // return downloading error
                        completionHandler(nil, ImageDownloaderError.downloadingError)
                    }
                }
            }
        }
    }
    // delete all the images from cache directory
    func deleteImagesFromDirectory() {
       
        let fileManager = FileManager.default
        guard let path = self.getDirectoryPath()?.absoluteString else {
            return
        }
        // check if caching directory exists at given path
        if fileManager.fileExists(atPath: path) {
            // remove the caching directory and all its contents
            try? fileManager.removeItem(atPath: path)
        }
    }
    // get cache directory path
    func getDirectoryPath() -> URL? {
        // cgeth the directory path for caching directory
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(Constants.catchedImagesFolder)
        let url = URL(string: path)
        return url
    }
    // save image to the caching directory
    func save(image: UIImage, with imageName: String) -> Bool {
        let fileManager = FileManager.default
        guard let path = self.getDirectoryPath()?.absoluteString, let url = URL(string: path) else {
            return false
        }
        let imagePath = url.appendingPathComponent(imageName)
        // check if directory exists
        if !fileManager.fileExists(atPath: path) {
            // create a directory if not already created
            try? fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        // get image path
        let urlString: String = imagePath.absoluteString
        // use image data
        let imageData = image.jpegData(compressionQuality: 1.0)
        // create a cached image file using image data at provided path
        return fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
    }
    // get the image based on name from caching directoiry
    func getImage(with imageName: String) -> UIImage? {
        
        let fileManager = FileManager.default
        guard let path = self.getDirectoryPath()?.absoluteString, let url = URL(string: path) else {
            return nil
        }
        let imagePath = url.appendingPathComponent(imageName)
        // get directory path
        let urlString: String = imagePath.absoluteString
        if fileManager.fileExists(atPath: urlString) {
            // return image if the file is found
            return UIImage(contentsOfFile: urlString)
        } else {
            return nil
        }
    }
}
