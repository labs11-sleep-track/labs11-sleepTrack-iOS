//
//  DailyData+SampleGenerator.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/1/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

extension DailyData {
    static func generateSample(for date: Date? = nil) -> DailyData {
        let dailyData = DailyData(userID: 504)
        
        dailyData.bedTime = dailyData.generateBedTime(for: date)
        dailyData.wakeTime = dailyData.generateWakeTime()
        dailyData.nightData = dailyData.generateNightData()
        dailyData.quality = dailyData.generateQuality()
        dailyData.sleepNotes = dailyData.generateSleepNotes()
        
        return dailyData
    }
    
    fileprivate func generateBedTime(for date: Date? = nil) -> Int {
        let date = date ?? Date(timeIntervalSinceNow: -60 * 60 * 24)
        let calendar = Calendar.current
        let hour = Int.random(in: 20...23)
        let minute = Int.random(in: 0...59)
        let newDate = calendar.date(bySettingHour: hour, minute: minute, second: 0, of: date)!
        return Int(newDate.timeIntervalSince1970)
    }
    
    fileprivate func generateWakeTime() -> Int? {
        guard let bedTime = bedTime else { return nil }
        let sleepTime = Int.random(in: 19800...30600)
        return bedTime + sleepTime
    }
    
    fileprivate func generateNightData() -> NightData {
        let nightData = NightData()
        
        guard let bedTime = bedTime, let wakeTime = wakeTime else { return nightData }
        var currentTime = bedTime + 300
        // Simulate falling asleep data
        for _ in 1...3 {
            let motionData = MotionData(motion: Double.random(in: 3...6), timestamp: currentTime)
            nightData.motionData.append(motionData)
            currentTime += 600
        }
        
        // Simulate sleeping data
        while currentTime < wakeTime - 4500 {
            let motionData = MotionData(motion: Double.random(in: 0.8...2), timestamp: currentTime)
            nightData.motionData.append(motionData)
            currentTime += 600
        }
        
        // Simulate waking up data
        while currentTime < wakeTime - 300 {
            let motionData = MotionData(motion: Double.random(in: 4...8), timestamp: currentTime)
            nightData.motionData.append(motionData)
            currentTime += 600
        }
        
        return nightData
    }
    
    fileprivate func generateQuality() -> Int {
        guard let bedTime = bedTime, let wakeTime = wakeTime else { return -1 }
        let sleepTime = wakeTime - bedTime
        
        switch sleepTime {
        case 0...21600: return Int.random(in: 40..<70)
        case 21601...27000: return Int.random(in: 70..<90)
        case 27001...36000: return Int.random(in: 90..<100)
        default: return -1
        }
    }
    
    func generateSleepNotes() -> String {
        guard let quality = quality else { return "" }
        
        if quality < 70 {
            return badSleepNotes.randomElement()!
        } else if quality > 90 {
            return goodSleepNotes.randomElement()!
        } else {
            return mediocreSleepNotes.randomElement()!
        }
    }
    
    fileprivate var goodSleepNotes: [String] {
        return [
                "I slept great last night",
                "I went to sleep feeling exhausted, but now I feel like I'm ready for the day!",
                "I feel like I could run a marathon",
                "I'm ready to take on the world after that night's sleep!"
            ]
    }
    
    fileprivate var mediocreSleepNotes: [String] {
        return [
                "I slept alright",
                "Not really ready to be awake yet, but I don't feel too bad",
                "Guess I'm done sleeping for today",
                "I could definitely keep sleeping if I didn't have to get up right now"
            ]
    }
    
    fileprivate var badSleepNotes: [String] {
        return [
                "I slept awfully",
                "I think I feel worse than when I went to sleep",
                "I never really fell asleep, just tossed and turned all night",
                "Maybe the two coffees I had last night weren't a great idea"
            ]
    }
}
