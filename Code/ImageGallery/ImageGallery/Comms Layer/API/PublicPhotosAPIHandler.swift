//
//  PublicPhotosAPIHandler.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 27/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
/** Use this protocol to enable a class to perform API operations related to Public photos */
public protocol PublicPhotosAPIHandlerProtocol {
    /**
     This method is to get public photos.
     - Parameter tag: filter search result using tag.
     - Parameter completion: completion block with Data and NetwrokError objects.
     */
    func requestPublicPhotos(with tag: String?, _ completion: @escaping (Data?, NetworkError?)->())
}
