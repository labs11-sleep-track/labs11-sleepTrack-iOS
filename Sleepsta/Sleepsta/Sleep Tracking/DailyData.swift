//
//  DailyData.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/25/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

class DailyData: Codable {
    var userID: Int
    var quality: Int?
    var bedTime: Int?
    var wakeTime: Int?
    var sleepNotes: String?
//    var motionData: [MotionData] = []
    
    var hasRequiredValues: Bool {
        return quality != nil && bedTime != nil && wakeTime != nil && sleepNotes != nil
    }
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case quality = "qos_score"
        case bedTime = "sleeptime"
        case wakeTime = "waketime"
        case sleepNotes = "sleep_notes"
    }
    
    init(userID: Int) {
        self.userID = userID
    }
}
