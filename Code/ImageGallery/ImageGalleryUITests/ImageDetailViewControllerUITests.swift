//
//  ImageDetailViewControllerUITests.swift
//  ImageGalleryUITests
//
//  Created by Siddharth Paneri (Digital) on 10/09/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import XCTest

class ImageDetailViewControllerUITests: XCTestCase {
    let app = XCUIApplication()
    override func setUp() {
        continueAfterFailure = false
        app.launchArguments.append("USE_MOCK_SERVER")
        app.launchArguments.append("isUITest")
        app.launchArguments.append("CLEAR_DB")
        app.launch()
    }
    func navigateToImageDetail() {
//        let cell = app.images["PublicPhotoImageView_1"]
//        XCTAssert(cell.exists, "Cell does not exist")
//        cell.tap()
        let cell = app.cells.element(boundBy: 0)
        XCTAssert(cell.exists, "Cell does not exist")
        cell.tap()
    }
    func testIfUserCanNavigateToImageDetail() {
        navigateToImageDetail()
        let screenTitle = app.staticTexts["Detail"]
        if app.waitForExistence(timeout: 3.0) {
            let backButton = app.buttons["Public photos"]
            XCTAssert(backButton.exists, "Back button does not exist")
            backButton.tap()
            return
        }
        XCTAssert(screenTitle.exists, "Could not navigate to detail screen")
    }
    func testCheckPublicPhotosAreLoadedCorrectly() {
        navigateToImageDetail()
        let authorLabel = app.staticTexts["AuthorLabel"]
        XCTAssert(authorLabel.exists, "Author label does not exist in first cell")
        XCTAssert(authorLabel.label == "richiegibbs15", "Athor label value mismatch")
        let titleLabel = app.staticTexts["DescriptionLabel"]
        XCTAssert(titleLabel.exists, "Title label does not exist in first cell")
        XCTAssert(titleLabel.label == "Putting my feet up", "Athor label value mismatch")
        let datePublishedLabel = app.staticTexts["DatePublishedLabel"]
        XCTAssert(datePublishedLabel.exists, "Date published does not exist in first cell")
        XCTAssert(datePublishedLabel.label == "Published on August 27, 2019", "Athor label value mismatch")
        let dateTakenLabel = app.staticTexts["DateTakenLabel"]
        XCTAssert(dateTakenLabel.exists, "Date taken label does not exist in first cell")
        XCTAssert(dateTakenLabel.label == "Taken on August 28, 2019", "Athor label value mismatch")
        let shareButton = app.buttons["ShareButton"]
        XCTAssert(shareButton.exists, "Share button does not exist in first cell")
    }

}
