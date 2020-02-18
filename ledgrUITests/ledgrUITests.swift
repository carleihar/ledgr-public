//
//  ledgrUITests.swift
//  ledgrUITests
//
//  Created by Caroline on 11/12/19.
//  Copyright © 2019 carleihar. All rights reserved.
//

import XCTest

class ledgrUITests: XCTestCase {
  
  override func setUp() {
    continueAfterFailure = false
    XCUIApplication().launch()
  }
  
  func testTotalsLabelDefault() {
    XCTAssertTrue(XCUIApplication().staticTexts["monthly"].exists)
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }
  
}
