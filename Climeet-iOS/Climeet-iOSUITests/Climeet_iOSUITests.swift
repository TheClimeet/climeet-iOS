//
//  Climeet_iOSUITests.swift
//  Climeet-iOSUITests
//
//  Created by mac on 8/1/24.
//

import XCTest
@testable import Climeet_iOS

final class Climeet_iOSUITests: XCTestCase {
    private var app: XCUIApplication!
    
    override func setUp() {
        continueAfterFailure = false
        // Launch the application
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()
        app = nil
    }
    
    func testShortsUploadAndCheckmarkImgaeChange() throws {

    }
}
