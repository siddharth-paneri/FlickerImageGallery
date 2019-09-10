//
//  Constants.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 27/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
public struct Constants {
    /** Feeds related constants */
    struct Feeds {
        static let baseUrl = "https://www.flickr.com/services/feeds"
        static let publicPhotosBaseUrl = Constants.Feeds.baseUrl + "/photos_public.gne"
    }
    /** Response Code */
    struct ResponseStatusCode {
        static let success = 200
    }
    /** Cached image folder name */
    static let catchedImagesFolder = "CatchedImages"
    /** Request parameters, default values */
    struct Parameters {
        static let responseFormat = "json"
        static let noAllowJsonCallback = "1"
    }
    /** default sort order */
    static let defaultSortOrder = PublicPhotosSortOrder.oldestPublished
    /** Default text value */
    static let takenPrefix = "Taken on "
    static let publishedPrefix = "Published on "
}
