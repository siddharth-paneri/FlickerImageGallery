//
//  PublicPhotoDataProviderTests.swift
//  ImageGalleryTests
//
//  Created by Siddharth Paneri (Digital) on 08/09/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import XCTest
@testable import ImageGallery

class PublicPhotoDataProviderTests: XCTestCase {
    var publicPhotoProvider: PublicPhotoDataProvider!
    var commsProvier: CommsProviderMock!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        commsProvier = CommsProviderMock()
        publicPhotoProvider =  PublicPhotoDataProvider(with: commsProvier, sortOrder: .latestPublished)
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        publicPhotoProvider.deleteAllPublicPhotosInDb()
        ImageDownloader(with: commsProvier).deleteImagesFromDirectory()
        
    }
    
    func testFetchAllPublicPhotos() {
        publicPhotoProvider.fetchAllPublicPhotos { (recevied, error) in
            if !recevied {
                XCTFail("Error in fetching data, test failed")
            }
        }
    }
    
    func testErrorInFetchAllPublicPhotos() {
        commsProvier.networkError = .serverFailed
        publicPhotoProvider.fetchAllPublicPhotos { (recevied, error) in
            if error == nil {
                XCTFail("Did not receive error, test failed")
            }
        }
    }
    
    func testFetchallPublicPhotosFromDB() {
        publicPhotoProvider.fetchAllPublicPhotos { (recevied, error) in
            if recevied {
                self.publicPhotoProvider.fetchAllPublicPhotosFromDBOnly({ (imageDataModel) in
                    if imageDataModel.count == 0 {
                        XCTFail("No data avialeble, test failed")
                    }
                })
            } else {
                XCTFail("Error in fetching data, test failed")
            }
            
        }
    }

}
