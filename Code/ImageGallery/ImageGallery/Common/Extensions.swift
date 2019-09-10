//
//  Extensions.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 28/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
import CoreData
/** NSManagedObject extension to save the object */
extension NSManagedObject {
    func save() {
        do {
            // Save Managed Object Context
            try self.managedObjectContext?.save()
        } catch {
            print("Unable to save managed object context.")
        }
    }
}
/** ImageDownloaderError extension to provide error description */
extension ImageDownloaderError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .downloadingError:
            return NSLocalizedString("Unable to download image", comment: "Image Download errors")
        case .cachingError:
            return NSLocalizedString("Unable to cache image in local directory", comment: "Image Cache errors")
        case .invalidUrl:
            return NSLocalizedString("Unable to download image, invalid url", comment: "Image url was invalid.")
        }
    }
}
/** NetworkError extension to provide error description */
extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .jsonParseError:
            return NSLocalizedString("Internal parsing Error, contact customer support", comment: "Json parsing error")
        case .noData:
            return NSLocalizedString("No data available", comment: "No data available")
        case .serverFailed:
            return NSLocalizedString("Connection failed", comment: "Server error")
        }
    }
}
