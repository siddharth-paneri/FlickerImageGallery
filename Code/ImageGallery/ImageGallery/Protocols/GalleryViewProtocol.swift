//
//  GalleryViewProtocol.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 27/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
protocol GalleryViewProtocol {
    /**
     This function should be implemented inside Gallery view controller.
     Should be called when we need to fetch public photos
     - Parameter tags: tags to filter data
     */
    func getPublicPhotos(with tags: String?)/**
     This function should be implemented inside Gallery view controller.
     Should be called when we need to fetch public photos from db only
     - Parameter tags: tags to filter data
     */
    func getPublicPhotosFromDb(with tags: String?)
    /**
     This function should be implemented inside Public photos data provider.
     Should be called when an error is encountered
     - Parameter error: NetworkError object
     */
    func show(error: NetworkError?)
}
