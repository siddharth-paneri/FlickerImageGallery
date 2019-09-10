//
//  PublicPhotosParameters.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 27/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
/** Public Photot Parameter creator */
public struct PublicPhotosParameters {
    var params: [PublicPhotosParameterType: String]
    init(format: String, noJsonCallback: String, tags: String?) {
        params = [:]
        params[.format] = format
        params[.noJsonCallback] = noJsonCallback
        if let t = tags {
            params[.tags] = t
        }
    }
}
