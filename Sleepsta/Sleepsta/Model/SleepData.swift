//
//  SleepData.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/25/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

class SleepData: Codable {
    var quality: Double?
    var bedTime: TimeInterval?
    var wakeTime: TimeInterval?
    var sleepNotes: String?
    var motionData: [MotionData]
}
