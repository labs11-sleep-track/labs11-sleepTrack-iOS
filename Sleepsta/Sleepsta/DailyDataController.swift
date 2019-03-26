//
//  DailyDataController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/26/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

class DailyDataController {
    static var current: DailyData = DailyData()
    
    // MARK: - CRUD Methods
    func addBedTime(to dailyData: DailyData = DailyDataController.current, bedTime: Date = Date()) {
        dailyData.bedTime = bedTime.timeIntervalSince1970
    }
    
    func addWakeTime(to dailyData: DailyData = DailyDataController.current, wakeTime: Date = Date() ) {
        dailyData.wakeTime = wakeTime.timeIntervalSince1970
        dailyData.motionData = MotionManager.shared.motionDataArray
    }
    
    func addSleepNotes(to dailyData: DailyData = DailyDataController.current, notes: String = "") {
        dailyData.sleepNotes = notes
        dailyData.quality = calculateSleepQuality()
    }
    
    // MARK: - Networking
    
    
    // Utility Methods
    private func calculateSleepQuality() -> Double {
        return 100.0
    }
    
}
