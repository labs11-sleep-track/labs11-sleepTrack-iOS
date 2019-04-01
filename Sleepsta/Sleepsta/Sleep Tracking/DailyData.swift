//
//  DailyData.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/25/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

class DailyData: Codable {
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
    var quality: Int?
    var bedTime: Int?
    var wakeTime: Int?
    var sleepNotes: String?
    var nightData: NightData
    
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
        // TODO: Change this to only display one date if the bedDate and wakeDate are the same
        guard let bedDate = bedDate, let wakeDate = wakeDate else { return "" }
        return "\(DailyData.dateFormatter.string(from: bedDate)) - \(DailyData.dateFormatter.string(from: wakeDate))"
    }
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case quality = "qos_score"
        case bedTime = "sleeptime"
        case wakeTime = "waketime"
        case sleepNotes = "sleep_notes"
        case nightData = "night_data"
    }
    
    init(userID: Int) {
        self.userID = userID
        self.nightData = NightData()
    }
}

class NightData: Codable {
    var motionData: [MotionData] = []
    
    enum CodingKeys: String, CodingKey {
        case motionData = "motion_data"
    }
}
