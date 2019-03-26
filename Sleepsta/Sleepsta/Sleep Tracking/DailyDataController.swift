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
    
    private let testToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWJqZWN0Ijo1MDMsImVtYWlsIjoiaW9zdGVzdEBleGFtcGxlLmNvbSIsImlhdCI6MTU1MzYyOTczNiwiZXhwIjoxNTUzNzE2MTM2fQ.HjGmZDunKtlBu0Fp29lk_JQKHu86QrY2QiM-aTuN8VY"
    private let testUserID = 503
    
    private let baseURL = URL(string: .baseURLString)!
    
    // MARK: - CRUD Methods
    func addBedTime(to dailyData: DailyData = DailyDataController.current, bedTime: Date = Date()) {
        dailyData.bedTime = bedTime.timeIntervalSince1970
        dailyData.userID = testUserID
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
    func postDailyData() {
        let dailyData = DailyDataController.current
        guard dailyData.hasRequiredValues else {
            NSLog("Daily data doesn't have all the required values yet.")
            return }
        
        let requestURL = baseURL.appendingPathComponent("daily")
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("Bearer \(testToken)", forHTTPHeaderField: "Authorization")
        
        do {
            let requestData = try JSONEncoder().encode(dailyData)
            print(String(data: requestData, encoding: .utf8)!)
            request.httpBody = requestData
        } catch {
            NSLog("Unable to encode user: \(dailyData)\nWith error: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                print(error)
            }
            
            if let data = data {
                print(data)
            }
        }
    }
    
    // Utility Methods
    private func calculateSleepQuality() -> Double {
        return 100.0
    }
    
}
