//
//  ImageDownloaderTests.swift
//  ImageGalleryTests
//
//  Created by Siddharth Paneri (Digital) on 08/09/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import XCTest
@testable import ImageGallery

class ImageDownloaderTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        ImageDownloader(with: CommsProviderMock()).deleteImagesFromDirectory()
    }
    
    func testImageDownloaderCanDownloadImages() {
        let commsProviderMock = CommsProviderMock()
        let imageDownloader = ImageDownloader(with: commsProviderMock)
        imageDownloader.downloadImage(urlString: "testImage") { (image, error) in
            if image == nil {
                XCTFail("TestImage not found")
            }
        }
    }
    func testImageDownloaderShowsDownloadError() {
        let commsProviderMock = CommsProviderMock()
        commsProviderMock.networkError = .noData
        let imageDownloader = ImageDownloader(with: commsProviderMock)
        imageDownloader.downloadImage(urlString: "testImage1") { (image, error) in
            if error == nil {
                XCTFail("TestImage not found")
            }
        }
    }
    func testImageDeletion() {
        // cache an image
        let commsProviderMock = CommsProviderMock()
        let imageDownloader = ImageDownloader(with: commsProviderMock)
        imageDownloader.downloadImage(urlString: "testImage") { (image, error) in
            if image == nil {
                XCTFail("TestImage not found")
            }
            // check if image is cached
            let fileManager = FileManager.default
            guard let path = imageDownloader.getDirectoryPath()?.absoluteString else {
                return
            }
            do {
                if try fileManager.fileExists(atPath: path) && fileManager.contentsOfDirectory(atPath: path).count > 0 {
                    // delete the image from directory
                    imageDownloader.deleteImagesFromDirectory()
                    // check image is deleted
                    if try fileManager.fileExists(atPath: path) && fileManager.contentsOfDirectory(atPath: path).count > 0 {
                        // cached image not deleted
                        XCTFail("Images were not deleted")
                    }
                }
            } catch {
                XCTFail("Directory not found")
            }
        }
    }
}
