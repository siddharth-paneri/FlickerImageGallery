
//
//  CommsProviderProtocol.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 27/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
/** This protocol will be used to create an interface for Comms provider */
protocol CommsProviderProtocol {
    /**
     This function should be implemented inside Comms provider, and called when we need to perform data task on given url request
     - Parameter urlRequest: request to get data.
     - Parameter completion: completion block with Data and NetwrokError objects.
     */
    func performDataTask(with urlRequest: URLRequest, _ completion: @escaping (Data?, NetworkError?)->())
    /**
     This function should be implemented inside Comms provider, and called when we need to perform any download task on given url request
     - Parameter urlRequest: request to get download url.
     - Parameter completion: completion block with download url and NetwrokError objects.
     */
    func performDownloadTask(with urlRequest: URLRequest, _ completion: @escaping (URL?, NetworkError?)->())
}
