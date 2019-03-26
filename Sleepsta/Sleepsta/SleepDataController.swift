//
//  SleepDataController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/26/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

class SleepDataController {
    static var current: SleepData = SleepData()
    
    func addBedTime(to sleepData: SleepData = SleepDataController.current, bedTime: Date = Date()) {
        sleepData.bedTime = bedTime.timeIntervalSince1970
    }
    
    func addWakeTime(to sleepData: SleepData = SleepDataController.current, wakeTime: Date = Date() ) {
        sleepData.wakeTime = wakeTime.timeIntervalSince1970
        sleepData.motionData = MotionManager.shared.motionDataArray
    }
    
    func addSleepNotes(to sleepData: SleepData = SleepDataController.current, notes: String = "") {
        sleepData.sleepNotes = notes
        sleepData.quality = calculateSleepQuality()
    }
    
    
    private func calculateSleepQuality() -> Double {
        return 100.0
    }
    
}
