//
//  MotionData.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/25/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

struct MotionData: Codable {
    
    let motion: Double
    let timestamp: Int
    
    var date: Date {
        return Date(timeIntervalSince1970: Double(timestamp))
    }
    
    enum CodingKeys: String, CodingKey {
        case motion = "y"
        case timestamp = "x"
    }
}
