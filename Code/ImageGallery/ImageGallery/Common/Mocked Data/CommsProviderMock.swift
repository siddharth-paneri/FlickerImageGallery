//
//  CommsProviderMock.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 09/09/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//  This class will be used to mock the CommsProvider

import Foundation
class CommsProviderMock: CommsProviderProtocol, PublicPhotosAPIHandlerProtocol {
    /// Set network error in case we need to test error conditions
    var networkError: NetworkError?
    /**
     This method is used to perform data task on given url request.
     - Parameter urlRequest: request to get data.
     - Parameter completion: completion block with Data and NetwrokError objects.
     */
    func performDataTask(with urlRequest: URLRequest, _ completion: @escaping (Data?, NetworkError?) -> ()) {
        // check if error is set
        if networkError != nil {
            // return error
            completion(nil, networkError)
            return
        }
        // return empty mock data
        completion(Data(), nil)
    }
    /**
     This method is used to perform download task on given url request.
     - Parameter urlRequest: request to downlaod data.
     - Parameter completion: completion block with url to download data and NetwrokError objects.
     */
    func performDownloadTask(with urlRequest: URLRequest, _ completion: @escaping (URL?, NetworkError?) -> ()) {
        // check if error is set
        if networkError != nil {
            // return error
            completion(nil, networkError)
            return
        }
        // return test image mock data url
        let url = Bundle.main.url(forResource: "testImage", withExtension: "png")
        completion(url, nil)
    }
    /**
     This method is used to request public photos.
     - Parameter tags: filter using tags.
     - Parameter completion: completion block with Data and NetwrokError objects.
     */
    func requestPublicPhotos(with tag: String?, _ completion: @escaping (Data?, NetworkError?) -> ()) {
        if networkError != nil {
            completion(nil, networkError)
            return
        }
        // prepare mocked json object
        var jsonObject = [String: Any]()
        jsonObject["title"] = "Uploads from everyone"
        jsonObject["link"] = "https://www.flickr.com/photos/"
        jsonObject["description"] = ""
        jsonObject["modified"] = "2019-08-27T11:38:04Z"
        jsonObject["generator"] = "https://www.flickr.com"
        
        var item = [String: Any]()
        item["title"] = "Putting my feet up"
        item["link"] = "https://www.flickr.com/photos/142660757@N02/48629223238/"
        item["media"] = ["m": "https://live.staticflickr.com/65535/48629223238_8ae6742a14_m.jpg"]
        item["date_taken"] = "2019-08-27T12:36:19-08:00"
        item["description"] = ""
        item["published"] = "2019-08-27T11:38:04Z"
        item["author"] = "nobody@flickr.com (\"richiegibbs15\")"
        item["author_id"] = "142660757@N02"
        item["tags"] = "tag1 tag2 tag3"
        
        jsonObject["items"] = [item]
        
        do {
            // prepare json data
            let jsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            // return mocked json data
            completion(jsonData, nil)
        } catch {
            
        }
    }
}
