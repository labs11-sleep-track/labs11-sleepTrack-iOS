//
//  DailyDataController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/26/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation
import GoogleSignIn

class DailyDataController {
    static var current: DailyData = DailyData(userID: User.current!.sleepstaID)
    
    private let baseURL = URL(string: .baseURLString)!
    
    // MARK: - CRUD Methods
    /// Method to add the time the user gets in bed to an instance of DailyData. Defaults to the instance currently being built and the current time.
    func addBedTime(to dailyData: DailyData = DailyDataController.current, bedTime: Date = Date()) {
        if dailyData.bedTime == nil { dailyData.bedTime = Int(bedTime.timeIntervalSince1970) }
    }

    /// Method to add the time the user wakes up to an instance of DailyData. Defaults to the instance currently being built and the current time. Eventually, it will set the motion data too (if that is the route we go)
    func addWakeTime(to dailyData: DailyData = DailyDataController.current, wakeTime: Date = Date() ) {
        if dailyData.wakeTime == nil { dailyData.wakeTime = Int(wakeTime.timeIntervalSince1970) }
//        if dailyData.motionData.isEmpty { dailyData.motionData = MotionManager.shared.motionDataArray }
    }
    
    /// Method to add the user's sleep notes to an instance of DailyData. Defaults to the instance currently being built and an empty string. Also calculates the sleep quality and sets that.
    func addSleepNotes(to dailyData: DailyData = DailyDataController.current, notes: String = "") {
        dailyData.sleepNotes = notes
        dailyData.quality = calculateSleepQuality()
    }
    
    // MARK: - Networking
    
    func postDailyData() {
        // Check to make sure the current instance of DailyData has all the required fields before posting.
        let dailyData = DailyDataController.current
        guard dailyData.hasRequiredValues else {
            NSLog("Daily data doesn't have all the required values yet.")
            return }
        
        // Build the request
        let requestURL = baseURL.appendingPathComponent("daily")
        
        guard let token = User.current?.sleepstaToken else { return }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.addValue("\(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-type")
        
        do {
            let requestData = try JSONEncoder().encode(dailyData)
            print(String(data: requestData, encoding: .utf8)!)
            request.httpBody = requestData
        } catch {
            NSLog("Unable to encode user: \(dailyData)\nWith error: \(error)")
            return
        }
        
        // Make a datatask
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            // Check for errors
            if let error = error {
                print(error)
            }
            
            // Check if any data was returned
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "Couldn't turn data into String")
                self.resetCurrentDailyData()
            }
        }.resume()
    }
    
    // Utility Methods
    /// Function to calculate the sleep quality. Will be implemented later.
    private func calculateSleepQuality() -> Int {
        // TODO: Actually calculate the sleep quality
        return Int.random(in: 85...100)
    }
    
    private func resetCurrentDailyData() {
        guard let currentUser = User.current else { return }
        DailyDataController.current = DailyData(userID: currentUser.sleepstaID)
    }
    
}
