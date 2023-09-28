//
//  Interesting_numbers_UITests.swift
//  Interesting numbers UITests
//
//  Created by AS on 16.09.2023.
//

@testable import Interesting_numbers
import XCTest

class InterestingNumbersUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        continueAfterFailure = false
        app.launch()
    }
    
    func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 5) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testUserNumberMode() {
        app.buttons["userNumberModeButton"].tap()
        app.textFields["numberInput"].tap()
        app.textFields["numberInput"].typeText("15")
        app.buttons["displayFactButton"].tap()
        
        let factLabel = app.staticTexts["factLabel"]
        waitForElementToAppear(factLabel)
        XCTAssertTrue(factLabel.exists)
    }
    
    func testRandomNumberMode() {
        app.buttons["randomNumberModeButton"].tap()
        app.buttons["displayFactButton"].tap()
        
        let factLabel = app.staticTexts["factLabel"]
        waitForElementToAppear(factLabel)
        XCTAssertTrue(factLabel.exists)
    }
    
    func testNumberInRangeMode() {
        app.buttons["numberInRangeModeButton"].tap()
        app.textFields["numberInput"].tap()
        app.textFields["numberInput"].typeText("10,20")
        app.buttons["displayFactButton"].tap()
        
        let factLabel = app.staticTexts["factLabel"]
        waitForElementToAppear(factLabel)
        XCTAssertTrue(factLabel.exists)
    }
    
    func testMultipleNumbersMode() {
        app.buttons["multipleNumbersModeButton"].tap()
        app.textFields["numberInput"].tap()
        app.textFields["numberInput"].typeText("10,15,20")
        app.buttons["displayFactButton"].tap()
        
        let factLabel = app.staticTexts["factLabel"]
        waitForElementToAppear(factLabel)
        XCTAssertTrue(factLabel.exists)
    }
}
