//
//  DailyData.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/25/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

class DailyData: Codable {
    var userID: Int?
    var quality: Double?
    var bedTime: TimeInterval?
    var wakeTime: TimeInterval?
    var sleepNotes: String?
    var motionData: [MotionData] = []
    
    var hasRequiredValues: Bool {
        return userID != nil && quality != nil && bedTime != nil && wakeTime != nil && sleepNotes != nil
    }
}
