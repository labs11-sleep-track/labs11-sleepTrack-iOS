//
//  DailyData.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/25/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

class DailyData: Codable, Equatable {
    
    // MARK: - Class Methods and Properties
    static func == (lhs: DailyData, rhs: DailyData) -> Bool {
        return lhs.userID == rhs.userID && lhs.bedTime == rhs.bedTime && lhs.wakeTime == rhs.wakeTime
    }
    
    static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
    
    static let timeFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        return timeFormatter
    }()
    
    // MARK: - Properties
    var userID: Int
    var identifier: Int?
    var quality: Int?
    var bedTime: Int?
    var wakeTime: Int?
    var sleepNotes: String?
    var nightData: [MotionData] = []
    
    var hasRequiredValues: Bool {
        return quality != nil && bedTime != nil && wakeTime != nil && sleepNotes != nil
    }
    
    var bedDate: Date? {
        guard let bedTime = bedTime else { return nil }
        return Date(timeIntervalSince1970: Double(bedTime))
    }
    
    var wakeDate: Date? {
        guard let wakeTime = wakeTime else { return nil }
        return Date(timeIntervalSince1970: Double(wakeTime))
    }
    
    var bedTimeString: String {
        guard let bedDate = bedDate else { return "" }
        return DailyData.timeFormatter.string(from: bedDate)
    }
    
    var wakeTimeString: String {
        guard let wakeDate = wakeDate else { return "" }
        return DailyData.timeFormatter.string(from: wakeDate)
    }
    
    var sleepTimeString: String {
        guard let bedDate = bedDate, let wakeDate = wakeDate else { return "" }
        let components = Calendar.current.dateComponents([.hour, .minute], from: bedDate, to: wakeDate)
        guard let hour = components.hour, let minute = components.minute else { return "" }
        return "You slept for \(hour) hours and \(minute) minutes"
    }
    
    var sleepTime: Int {
        guard let bedTime = bedTime, let wakeTime = wakeTime else { return -1 }
        return wakeTime - bedTime
    }
    
    var dateRangeString: String {
        guard let bedDate = bedDate, let wakeDate = wakeDate else { return "" }
        let bedDateString = DailyData.dateFormatter.string(from: bedDate)
        let wakeDateString = DailyData.dateFormatter.string(from: wakeDate)
        if bedDateString == wakeDateString { return bedDateString }
        return "\(bedDateString) - \(wakeDateString)"
    }
    
    
    init(userID: Int) {
        self.userID = userID
    }
    
    // MARK: - Codable
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case identifier = "id"
        case quality = "qos_score"
        case bedTime = "sleeptime"
        case wakeTime = "waketime"
        case sleepNotes = "sleep_notes"
        case nightData = "night_data"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let userID = try container.decode(Int.self, forKey: .userID)
        let identifier = try container.decodeIfPresent(Int.self, forKey: .identifier)
        let quality = try container.decode(Int.self, forKey: .quality)
        let bedTime = try container.decode(Int.self, forKey: .bedTime)
        let wakeTime = try container.decode(Int.self, forKey: .wakeTime)
        let sleepNotes = try container.decodeIfPresent(String.self, forKey: .sleepNotes)
        
        let nightData: [MotionData]
        if let motionDataString = try? container.decode(String.self, forKey: .nightData), let motionDataData = motionDataString.data(using: .utf8) {
            nightData = try JSONDecoder().decode([MotionData].self, from: motionDataData)
        } else {
            nightData = try container.decode([MotionData].self, forKey: .nightData)
        }
        
        self.userID = userID
        self.identifier = identifier
        self.quality = quality
        self.bedTime = bedTime
        self.wakeTime = wakeTime
        self.sleepNotes = sleepNotes
        self.nightData = nightData
    }
    
    func encode (to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        guard let quality = quality else { throw NSError() }
        guard let bedTime = bedTime else { throw NSError() }
        guard let wakeTime = wakeTime else { throw NSError() }
        
        try container.encode(userID, forKey: .userID)
        try container.encode(quality, forKey: .quality)
        try container.encode(bedTime, forKey: .bedTime)
        try container.encode(wakeTime, forKey: .wakeTime)
        try container.encodeIfPresent(sleepNotes, forKey: .sleepNotes)
        let motionData = try JSONEncoder().encode(nightData)
        let motionDataString = String(data: motionData, encoding: .utf8)
        try container.encodeIfPresent(motionDataString, forKey: .nightData)
    }
    
    /// Function to calculate the sleep quality. Right now just calculates the total sleep time divided by 8 hours.
    func calculateSleepQuality() {
        
        guard let wakeTime = wakeTime, let bedTime = bedTime else { return }
        
        let sleepTime = wakeTime - bedTime
        let targetTime = 60 * 60 * 8
        
        let sleepPercentage = Double(sleepTime) / Double(targetTime)
        
        let sleepLength = sleepPercentage < 1 ? Int(sleepPercentage * 100) : 100
        
        let sleepDepthPercentage = deepSleepPercentage()
        
        let sleepDepth = sleepDepthPercentage < 1 ? Int(sleepDepthPercentage * 100) : 100
        
        
        
        self.quality = (sleepLength + sleepDepth) / 2
    }
    
    // MARK: - Utility Methods
    func highestMotion() -> Double {
        return nightData.max(by: { $0.motion < $1.motion })?.motion ?? 0
    }
    
    func lowestMotion() ->  Double {
        return nightData.min(by: { $0.motion < $1.motion })?.motion ?? 0
    }
    
    func deepSleepThreshold() -> Double {
        let highest = highestMotion()
        let lowest = lowestMotion()
        
        return (highest - lowest) / 8 + lowest
    }
    
    func deepSleepPercentage() -> Double {
        let threshold = deepSleepThreshold()
        
        let totalPoints = nightData.count
        let deepSleepPoints = nightData.filter({ $0.motion < threshold }).count
        
        return (Double(deepSleepPoints) / Double(totalPoints)) * 5
    }
}

class NightData: Codable {
    var motionData: [MotionData] = []
    
    enum CodingKeys: String, CodingKey {
        case motionData = "motion_data"
    }
}
