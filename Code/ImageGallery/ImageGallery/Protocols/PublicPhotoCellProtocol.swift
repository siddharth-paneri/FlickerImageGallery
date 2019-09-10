//
//  PublicPhotoCellProtocol.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 31/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
protocol PublicPhotoCellProtocol {
    /**
     This function should be implemented inside PublicPhotoCell class.
     Should be used to configure cell using view model
     - Parameter viewModel: ImageDetailViewModelProtocol object to configure with
     */
    func configure(using viewModel: ImageDetailViewModelProtocol)
}
