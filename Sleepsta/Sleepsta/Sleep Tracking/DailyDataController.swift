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
    
    private let baseURL = URL(string: .baseURLString)!
    
    // MARK: - CRUD Methods
    func addBedTime(to dailyData: DailyData = DailyDataController.current, bedTime: Date = Date()) {
        if dailyData.bedTime == nil { dailyData.bedTime = Int(bedTime.timeIntervalSince1970) }
        if dailyData.userID == nil { dailyData.userID = LoginManager.shared.userID }
    }
    
    func addWakeTime(to dailyData: DailyData = DailyDataController.current, wakeTime: Date = Date() ) {
        if dailyData.wakeTime == nil { dailyData.wakeTime = Int(wakeTime.timeIntervalSince1970) }
//        if dailyData.motionData.isEmpty { dailyData.motionData = MotionManager.shared.motionDataArray }
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
        request.addValue("\(LoginManager.shared.token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        do {
            let requestData = try JSONEncoder().encode(dailyData)
            print(String(data: requestData, encoding: .utf8)!)
            request.httpBody = requestData
        } catch {
            NSLog("Unable to encode user: \(dailyData)\nWith error: \(error)")
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error)
            }
            
            if let response = response {
                print(response)
            }
            
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "Couldn't turn data into String")
            }
        }.resume()
    }
    
    // Utility Methods
    private func calculateSleepQuality() -> Int {
        return 100
    }
    
}
