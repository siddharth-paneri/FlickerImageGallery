//
//  ImageDetailViewProtocol.swift
//  ImageGallery
//
//  Created by Siddharth Paneri (Digital) on 27/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import Foundation
protocol ImageDetailViewProtocol {
    /**
     This function should be implemented inside Image detail view controller.
     Should be called when we need to configure controller with the view model
     - Parameter viewModel: ImageDetailViewModelProtocol object to configure with
     */
    func configure(using viewModel: ImageDetailViewModelProtocol?)
}
