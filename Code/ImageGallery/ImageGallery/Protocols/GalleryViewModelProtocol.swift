//
//  GalleryViewModelProtocol.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 28/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
protocol GalleryViewModelProtocol {
    /** This variable should be implemented inside gallery view model.
     should be used to get and set image view models
     */
    var imageViewModels: [ImageDetailViewModelProtocol] { get set }
    /** This variable should be implemented inside gallery view model.
     should be used to get and set filtered image view models
     */
    var filteredViewModels: [ImageDetailViewModelProtocol] { get set }
    /** This variable should be implemented inside gallery view model.
     should be used to get data provider
     */
    var dataProvider: PublicPhotoDataProvideProtocol { get }
    /**
     This initializer function should be implemented inside gallery view model.
     - Parameter dataProvider:  data provider object of type PublicPhotoDataProvideProtocol
     */
    init(with dataProvider: PublicPhotoDataProvideProtocol)
    /**
     This function should be implemented inside gallery view model.
     Should be used to set sort order to the public photos data
     - Parameter sortOrder:   PublicPhotosSortOrder
     */
    func set(sortOrder: PublicPhotosSortOrder)
    /**
     This function should be implemented inside gallery view model.
     Should be used filter the data using given tag
     - Parameter tag: String object to be used for filtering
     */
    func filterLocally(with tag: String)
    /**
     This function should be implemented inside gallery view model.
     Should be used filter the data using given tag
     - Parameter tag: String object to be used for filtering
     - Parameter completion: completion block with error object
     */
    func filteredFetch(with tags: String, _ completion: @escaping (NetworkError?)->())
    /**
     This function should be implemented inside gallery view model.
     Should be used reset all the filter
     - Parameter completion: completion block
     */
    func resetFilter(_ completion: @escaping ()->())
    /**
     This function should be implemented inside gallery view model.
     Should be used to clear cached data if any
     */
    func clearCache()
    /**
     This function should be implemented inside gallery view model.
     Should be used get all public photots from api
     - Parameter tags: tags to filter data
     - Parameter completion: completion bloack that returns success and NetworkError object
     */
    func getAllPublicPhotos(with tags: String?, _ completion: @escaping (Bool, NetworkError?)->())
    /**
     This function should be implemented inside gallery view model.
     Should be used get all public photots from DB
     - Parameter completion: completion bloack that returns success
     */
    func getAllPublicPhotosFromDB(with tags: String?, _ completion: @escaping (Bool)->())
}
