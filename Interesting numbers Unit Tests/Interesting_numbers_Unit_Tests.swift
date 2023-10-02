//
//  Interesting_numbers_Unit_Tests.swift
//  Interesting numbers Unit Tests
//
//  Created by AS on 16.09.2023.
//

@testable import Interesting_numbers
import XCTest
import NumberFactsCore

class NumberFactServiceIntegrationTests: XCTestCase {
    
    var service: NumberFactService!

    override func setUpWithError() throws {
        super.setUp()
        service = NumberFactService()
    }

    override func tearDownWithError() throws {
        service = nil
        super.tearDown()
    }

    func testFetchFactWithValidNumber() {
        let expectation = self.expectation(description: "Fetch fact with valid number")
        service.getFact(number: "15", type: "trivia") { result in
            switch result {
            case .success(let fact):
                XCTAssertNotNil(fact, "Fact data should not be nil")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but received failure with error: \(error.localizedDescription)")
            }
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testFetchFactForRandomNumber() {
        let expectation = self.expectation(description: "Fetch fact for random number")
        service.getFact(number: "random", type: "trivia") { result in
            switch result {
            case .success(let fact):
                XCTAssertNotNil(fact, "Fact data should not be nil")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but received failure with error: \(error.localizedDescription)")
            }
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testFetchFactForNumberInRange() {
        let expectation = self.expectation(description: "Fetch fact for number in range")
        service.getFactInRange(min: "10", max: "20") { result in
            switch result {
            case .success(let fact):
                XCTAssertNotNil(fact, "Fact data should not be nil")
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Expected success, but received failure with error: \(error.localizedDescription)")
            }
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func testFetchFactForMultipleNumbers() {
        let expectation = self.expectation(description: "Fetch fact for multiple numbers")
        let numbers = ["10", "15", "20"]
        for number in numbers {
            service.getFact(number: number, type: "trivia") { result in
                switch result {
                case .success(let fact):
                    XCTAssertNotNil(fact, "Fact data for number \(number) should not be nil")
                case .failure(let error):
                    XCTFail("Expected success for number \(number), but received failure with error: \(error.localizedDescription)")
                }
                if number == numbers.last {
                    expectation.fulfill()
                }
            }
        }
        self.waitForExpectations(timeout: 5.0, handler: nil)
    }
}
