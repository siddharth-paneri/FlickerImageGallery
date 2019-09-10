//
//  CommsProvider.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 27/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//  This is a Comms provider class, used tom implement the comms, it uses CommsProviderProtocol to make sure all the methods are implemented and used in a way that it should (protocol oriented)

import Foundation

class CommsProvider: CommsProviderProtocol {
    // singleton
    private static var _shared: CommsProvider? = nil
    class var shared: CommsProvider {
        guard let shared = _shared else {
            _shared = CommsProvider()
            return _shared!
        }
        return shared
    }
    /// session configuration
    var sessionConfiguration: URLSessionConfiguration
    /// Initialzer
    init() {
        self.sessionConfiguration = URLSessionConfiguration.default
    }
    /** This method returns URL session based on session configuration */
    func getURLSession() -> URLSession {
        return URLSession(configuration: sessionConfiguration)
    }
    func performDataTask(with urlRequest: URLRequest, _ completion: @escaping (Data?, NetworkError?)->()) {
        // create url session
        let urlSession = getURLSession()
        // create a data task
        let dataTask = urlSession.dataTask(with: urlRequest) { (data, response, error) in
            // get the response object
            guard let resp = response as? HTTPURLResponse else {
                // return server failure error if no response received
                completion(nil, NetworkError.serverFailed)
                return
            }
            // check response code
            if resp.statusCode == Constants.ResponseStatusCode.success {
                // result ok
                guard let receivedData = data else {
                    // return no data error if data is null
                    completion(nil, NetworkError.noData)
                    return
                }
                // return received data
                completion(receivedData, nil)
                return
            }
            // return server failure
            completion(nil, NetworkError.serverFailed)
            return
        }
        // start the data task
        dataTask.resume()
    }
    func performDownloadTask(with urlRequest: URLRequest, _ completion: @escaping (URL?, NetworkError?) -> ()) {
        // create url session
        let urlSession = getURLSession()
        let downloadTask = urlSession.downloadTask(with: urlRequest) { (url, response, error) in
            guard let resp = response as? HTTPURLResponse else {
                completion(nil, NetworkError.serverFailed)
                return
            }
            if resp.statusCode == Constants.ResponseStatusCode.success {
                completion(url, nil)
                return
            } else if error != nil {
                completion(nil, NetworkError.serverFailed)
                return
            }
            completion(nil, NetworkError.serverFailed)
            return
        }
        downloadTask.resume()
    }
}
//MARK:- PublicPhotosAPIHandlerProtocol implemetation
extension CommsProvider: PublicPhotosAPIHandlerProtocol {
    func requestPublicPhotos(_ completion: @escaping (Data?, NetworkError?)->()) {
        // get the request URL
        let stringUrl = Constants.Feeds.publicPhotosBaseUrl
        // get the parameters and respective values
        let parameters = PublicPhotosParameters(format: Constants.Parameters.responseFormat, noJsonCallback: Constants.Parameters.noAllowJsonCallback)
        // create url components to restructure the URL
        var urlComponents = URLComponents(string: stringUrl)
        urlComponents?.queryItems = parameters.params.map { URLQueryItem(name: $0.key.rawValue, value: $0.value)}
        guard let url = urlComponents?.url else { return }
        // create url request
        let urlRequest = URLRequest(url: url)
        // preform data task on the goven url
        self.performDataTask(with: urlRequest, completion)
    }
}
