//
//  DailyDataControllerTests.swift
//  SleepstaTests
//
//  Created by Dillon McElhinney on 4/11/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import XCTest
@testable import Sleepsta

class DailyDataControllerTests: XCTestCase {

    let testUser = User(sleepstaID: 1, sleepstaToken: "abcd", email: "test@example.com", accountType: "user")
    
    override func tearDown() {
        DailyDataController.clearCache()
    }
    
    // Test decoding valid JSON
    func testValidDailyDataJSON() {
        let mockLoader = MockLoader(data: validDailyDataJSON, error: nil)
        let dailyDataController = DailyDataController(user: testUser, networkLoader: mockLoader)
        let correctURL = URL(string: "https://sleepsta.herokuapp.com/api/daily/user/1")!
        
        let dailyDataExpectation = expectation(description: "Get Daily Data Expectation")
        dailyDataController.fetchDailyData {
            
            XCTAssertEqual(dailyDataController.dailyDatas.count, 1)
            XCTAssertEqual(mockLoader.url, correctURL)
            
            dailyDataExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
    
    // Test decoding invalid JSON
    func testInvalidDailyDataJSON() {
        let mockLoader = MockLoader(data: invalidDailyDataJSON, error: nil)
        let dailyDataController = DailyDataController(user: testUser, networkLoader: mockLoader)
        let correctURL = URL(string: "https://sleepsta.herokuapp.com/api/daily/user/1")!
        
        XCTAssert(dailyDataController.dailyDatas.count == 0, "Found wrong number of daily datas: \(dailyDataController.dailyDatas.count)")
        
        let dailyDataExpectation = expectation(description: "Get Daily Data Expectation")
        dailyDataController.fetchDailyData {
            
            XCTAssertEqual(dailyDataController.dailyDatas.count, 0)
            XCTAssertEqual(mockLoader.url, correctURL)
            
            dailyDataExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 3)
    }
}
