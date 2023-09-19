//
//  Interesting_numbers_Unit_Tests.swift
//  Interesting numbers Unit Tests
//
//  Created by AS on 16.09.2023.
//


import XCTest
@testable import Interesting_numbers

class MainViewControllerTests: XCTestCase {
    
    var viewController: MainViewController!
    
    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        viewController = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        viewController.loadView()
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func testUserNumberButtonTapped() {
        viewController.userNumberButtonTapped(self)
        XCTAssertEqual(viewController.selectedMode, "userNumber")
    }
    
    func testRandomNumberButtonTapped() {
        viewController.randomNumberButtonTapped(self)
        XCTAssertEqual(viewController.selectedMode, "randomNumber")
    }
    
    func testNumberInARangeButtonTapped() {
        viewController.numberInARangeButtonTapped(self)
        XCTAssertEqual(viewController.selectedMode, "numberInARange")
    }
    
    func testMultipleNumbersButtonTapped() {
        viewController.multipleNumbersButtonTapped(self)
        XCTAssertEqual(viewController.selectedMode, "multipleNumbers")
    }
    
    func testTextFieldShouldChangeCharactersInUserNumberMode() {
        viewController.selectedMode = "userNumber"
        
        XCTAssertTrue(viewController.textField(viewController.numberTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 1), replacementString: "5"))
        XCTAssertFalse(viewController.textField(viewController.numberTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 1), replacementString: "a"))
    }
    
    func testTextFieldShouldChangeCharactersInRandomNumberMode() {
        viewController.selectedMode = "randomNumber"
        
        XCTAssertTrue(viewController.textField(viewController.numberTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 1), replacementString: "5"))
        XCTAssertFalse(viewController.textField(viewController.numberTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 1), replacementString: "a"))
    }
    
    func testTextFieldShouldChangeCharactersInNumberInARangeMode() {
        viewController.selectedMode = "numberInARange"
        
        XCTAssertTrue(viewController.textField(viewController.numberTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 1), replacementString: "5"))
        XCTAssertTrue(viewController.textField(viewController.numberTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 1), replacementString: ","))
        XCTAssertFalse(viewController.textField(viewController.numberTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 1), replacementString: "a"))

        XCTAssertTrue(viewController.textField(viewController.numberTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 5), replacementString: "1,2,3,4,5"))
        XCTAssertFalse(viewController.textField(viewController.numberTextField, shouldChangeCharactersIn: NSRange(location: 0, length: 6), replacementString: "1,2,3,4,5,"))

    }
}

