//
//  AuthorDataModel.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 27/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
struct AuthorDataModel {
    let name: String
    let id: String
    let email: String
    /** map AuthorEntity to AuthorDataModel */
    static func map(author: AuthorEntity?) -> AuthorDataModel {
        return AuthorDataModel(name: author?.name ?? "", id: author?.id ?? "", email: author?.email ?? "")
    }
}
