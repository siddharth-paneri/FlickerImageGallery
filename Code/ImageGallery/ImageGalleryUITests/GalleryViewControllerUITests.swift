//
//  GalleryViewControllerUITests.swift
//  ImageGalleryUITests
//
//  Created by Siddharth Paneri (Digital) on 27/08/19.
//  Copyright © 2019 Siddharth Paneri. All rights reserved.
//

import XCTest
class GalleryViewControllerUITests: XCTestCase {
    let app = XCUIApplication()
    override func setUp() {
        continueAfterFailure = false
        app.launchArguments.append("USE_MOCK_SERVER")
        app.launchArguments.append("isUITest")
        app.launchArguments.append("CLEAR_DB")
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCheckAllUIElementsExist() {
        let sortButton = app.buttons["Sort button"]
        let displayTypeButton = app.buttons["Display type button"]
        let searchBar = app.otherElements["Search Bar"]
        XCTAssert(sortButton.exists, "Sort button does not exist on UI")
        XCTAssert(displayTypeButton.exists, "Change display type button does not exist on UI")
        XCTAssert(searchBar.exists, "Search bar does not exist on UI")
        XCTAssert(app.collectionViews.cells.count > 0, "No data displayed on UI")
    }
    func testCheckPublicPhotosAreLoadedCorrectly() {
        let authorLabel = app.staticTexts["AuthorLabel_1"]
        XCTAssert(authorLabel.exists, "Author label does not exist in first cell")
        XCTAssert(authorLabel.label == "richiegibbs15", "Athor label value mismatch")
        let titleLabel = app.staticTexts["TitleLabel_1"]
        XCTAssert(titleLabel.exists, "Title label does not exist in first cell")
        XCTAssert(titleLabel.label == "Putting my feet up", "Athor label value mismatch")
        let datePublishedLabel = app.staticTexts["DatePublishedLabel_1"]
        XCTAssert(datePublishedLabel.exists, "Date published does not exist in first cell")
        XCTAssert(datePublishedLabel.label == "Published on August 27, 2019", "Athor label value mismatch")
        let dateTakenLabel = app.staticTexts["DateTakenLabel_1"]
        XCTAssert(dateTakenLabel.exists, "Date taken label does not exist in first cell")
        XCTAssert(dateTakenLabel.label == "Taken on August 28, 2019", "Athor label value mismatch")
        let shareButton = app.buttons["ShareButton_1"]
        XCTAssert(shareButton.exists, "Share button does not exist in first cell")
    }
}
