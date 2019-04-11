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
    
    static func clearCache() {
        clearPersistentStore()
    }
    
    private(set) var dailyDatas: [DailyData] = [] {
        didSet { saveToPersistentStore() }
    }
    
    private let baseURL = URL(string: .baseURLString)!
    let networkLoader: NetworkDataLoader
    let user: User?
    
    init(user: User? = User.current, networkLoader: NetworkDataLoader = URLSession.shared) {
        self.networkLoader = networkLoader
        self.user = user
        loadFromPersistentStore()
    }
    
    // MARK: - CRUD Methods
    /// Method to add the time the user gets in bed to an instance of DailyData. Defaults to the instance currently being built and the current time.
    func addBedTime(to dailyData: DailyData = DailyDataController.current, bedTime: Date = Date()) {
        if dailyData.bedTime == nil { dailyData.bedTime = Int(bedTime.timeIntervalSince1970) }
    }

    /// Method to add the time the user wakes up to an instance of DailyData. Defaults to the instance currently being built and the current time. Eventually, it will set the motion data too (if that is the route we go)
    func addWakeTime(to dailyData: DailyData = DailyDataController.current, wakeTime: Date = Date() ) {
        if dailyData.wakeTime == nil { dailyData.wakeTime = Int(wakeTime.timeIntervalSince1970) }
        if dailyData.nightData.isEmpty { dailyData.nightData = MotionManager.shared.motionDataArray }
    }
    
    /// Method to add the user's sleep notes to an instance of DailyData. Defaults to the instance currently being built and an empty string. Also calculates the sleep quality and sets that.
    func addSleepNotes(to dailyData: DailyData = DailyDataController.current, notes: String = "") {
        dailyData.sleepNotes = notes
        dailyData.quality = calculateSleepQuality()
    }
    
    func resetCurrent() {
        resetCurrentDailyData()
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
        
        guard let token = user?.sleepstaToken else { return }
        
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
        networkLoader.loadData(using: request) { (data, error) in
            // Check for errors
            if let error = error {
                print(error)
            }
            
            // Check if any data was returned
            if let data = data {
                print(String(data: data, encoding: .utf8) ?? "Couldn't turn data into String")
                self.resetCurrentDailyData()
            }
        }
    }
    
    func fetchDailyData(completion: @escaping () -> Void ) {
        guard let user = user else { completion(); return }
        
        let requestURL = baseURL.appendingPathComponent("daily")
            .appendingPathComponent("user")
            .appendingPathComponent("\(user.sleepstaID)")
        
        networkLoader.loadData(using: requestURL) { (data, error) in
            if let error = error {
                NSLog("Error GETting user's sleep data: \(error)")
                completion()
                return
            }
            
            guard let data = data else {
                NSLog("No data was returned")
                completion()
                return
            }
            
            do {
                let dailyDatas = try JSONDecoder().decode([DailyData].self, from: data)
                self.dailyDatas = dailyDatas.sorted(by: { ($0.bedTime ?? 0) < ($1.bedTime ?? 1) })
            } catch {
                NSLog("Error decoding daily datas: \(error)")
            }
            
            completion()
        }
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
    
    private static let cacheURL: URL = {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let url = documentsDirectory.appendingPathComponent("cached-sleep-data").appendingPathExtension("json")
        return url
    }()
    
    private func saveToPersistentStore() {
        do {
            let data = try JSONEncoder().encode(dailyDatas)
            try data.write(to: DailyDataController.cacheURL, options: [.atomic])
            print("Saved to persistent store")
        } catch {
            NSLog("Error encoding or saving daily data cache: \(error)")
        }
    }
    
    private func loadFromPersistentStore() {
        do {
            let data = try Data(contentsOf: DailyDataController.cacheURL)
            let loadedDailyDatas = try JSONDecoder().decode([DailyData].self, from: data)
            self.dailyDatas = loadedDailyDatas
            print("Loaded from persistent store")
        } catch {
            NSLog("Error loading or decoding daily data cache: \(error)")
        }
    }
    
    private static func clearPersistentStore() {
        do {
            try FileManager.default.removeItem(at: cacheURL)
        } catch {
            NSLog("Error clearing daily data cache: \(error)")
        }
    }
}
