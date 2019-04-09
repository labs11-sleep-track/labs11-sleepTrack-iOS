//
//  DailyData.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/25/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

class DailyData: Codable, Equatable {
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
    
    var dateRangeString: String {
        guard let bedDate = bedDate, let wakeDate = wakeDate else { return "" }
        let bedDateString = DailyData.dateFormatter.string(from: bedDate)
        let wakeDateString = DailyData.dateFormatter.string(from: wakeDate)
        if bedDateString == wakeDateString { return bedDateString }
        return "\(bedDateString) - \(wakeDateString)"
    }
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case identifier = "id"
        case quality = "qos_score"
        case bedTime = "sleeptime"
        case wakeTime = "waketime"
        case sleepNotes = "sleep_notes"
        case nightData = "night_data"
    }
    
    init(userID: Int) {
        self.userID = userID
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
}

class NightData: Codable {
    var motionData: [MotionData] = []
    
    enum CodingKeys: String, CodingKey {
        case motionData = "motion_data"
    }
}
