//
//  GalleryViewModel.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 28/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
// View model for gallery view to display and manipulate data
class GalleryViewModel: GalleryViewModelProtocol {
    // image view models array
    var imageViewModels: [ImageDetailViewModelProtocol]
    // filtered image view modesls array
    var filteredViewModels: [ImageDetailViewModelProtocol] = []
    // data provider for public photos
    var dataProvider: PublicPhotoDataProvideProtocol
    // initializer
    required init(with dataProvider: PublicPhotoDataProvideProtocol) {
        self.dataProvider = dataProvider
        self.imageViewModels = []
    }
    // set sort order, part of GalleryViewModelProtocol
    func set(sortOrder: PublicPhotosSortOrder) {
        self.dataProvider.sortOrder = sortOrder
    }
    // reset the filter, part of GalleryViewModelProtocol
    func resetFilter() {
        filteredViewModels = []
    }
    // filter using tag, part of GalleryViewModelProtocol
    func filter(with tag: String) {
        filteredViewModels = self.imageViewModels.filter({ (viewModel) -> Bool in
            return viewModel.getTags().contains(where: { (storedTag) -> Bool in
                return storedTag.lowercased().contains(tag.lowercased())
            })
        })
        print(tag)
        print(filteredViewModels)
    }
    // get public photos from api and store in db, part of GalleryViewModelProtocol
    func getAllPublicPhotos(_ completion: @escaping (Bool, NetworkError?)->()) {
        dataProvider.fetchAllPublicPhotos(completion)
    }
    // get public photos from DB, part of GalleryViewModelProtocol
    func getAllPublicPhotosFromDB(_ completion: @escaping (Bool) -> ()) {
        dataProvider.fetchAllPublicPhotosFromDBOnly { (imageDataModels) in
            let viewModels = imageDataModels.compactMap({ (imageDataModel) -> ImageDetailViewModel? in
                return ImageDetailViewModel(with: imageDataModel)
            })
            self.imageViewModels = viewModels
            completion(true)
        }
    }
    // clear the cached images, part of GalleryViewModelProtocol
    func clearCache() {
        if ProcessInfo.processInfo.arguments.contains("USE_MOCK_SERVER") {
            ImageDownloader(with: CommsProviderMock()).deleteImagesFromDirectory()
        } else {
            ImageDownloader(with: CommsProvider.shared).deleteImagesFromDirectory()
        }
        
    }
}
