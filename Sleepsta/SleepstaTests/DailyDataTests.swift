//
//  DailyDataTests.swift
//  SleepstaTests
//
//  Created by Dillon McElhinney on 4/16/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import XCTest
@testable import Sleepsta

class DailyDataTests: XCTestCase {
    
    var dailyData: DailyData!
    
    override func setUp() {
        dailyData = sampleDailyData()
    }

    func testHighestAndLowest() {
        XCTAssert(dailyData.highestMotion() == 8.3805624845127277, "Didn't find the right high point: \(dailyData.highestMotion())" )
        XCTAssert(dailyData.lowestMotion() == 1.5174417376518263, "Didn't find the right low point: \(dailyData.lowestMotion())")
        XCTAssertFalse(dailyData.hasRequiredValues)
    }
    
    func testThreshold() {
        XCTAssert(dailyData.deepSleepThreshold() == 2.375331831009439, "Didn't find the right threshold: \(dailyData.deepSleepThreshold())")
        XCTAssertFalse(dailyData.hasRequiredValues)
    }
    
    func testDeepSleepPercentage() {
        XCTAssert(dailyData.deepSleepPercentage() == (Double(13)/Double(41))*5, "Didn't find the right deep sleep percentage found: \(dailyData.deepSleepPercentage())")
        XCTAssertFalse(dailyData.hasRequiredValues)
    }
    
    func testCalculateQuality() {
        XCTAssertFalse(dailyData.hasRequiredValues)
        dailyData.calculateSleepQuality()
        XCTAssert(dailyData.quality == 92, "Didn't find the right quality: \(dailyData.quality ?? -1)")
        XCTAssert(dailyData.hasRequiredValues)
    }
    
}
