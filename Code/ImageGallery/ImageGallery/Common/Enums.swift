//
//  Enums.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 28/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
/** NetworkError enum, used when we need to identify the type of error during comms */
public enum NetworkError: Error {
    case noData
    case jsonParseError
    case serverFailed
}
/** ImageDownloaderError enum, used when we need to identify the type of error during image download */
public enum ImageDownloaderError: Error {
    ///throw error when image unable to save in directory
    case downloadingError
    case cachingError
    case invalidUrl
}
/** PublicPhotosSortOrder enum, used when we need to set the sort order of the feeds */
public enum PublicPhotosSortOrder {
    case oldestPublished
    case latestPublished
    case oldestTaken
    case latestTaken
}
/** PublicPhotosParameterType enum, All the parameters that needs to be passed for Public photos api */
enum PublicPhotosParameterType: String {
    case format = "format"
    case noJsonCallback = "nojsoncallback"
}




