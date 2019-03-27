//
//  AVSessionHelper.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/27/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation
import AVFoundation

class AVSessionHelper {
    static let shared = AVSessionHelper()
    private init () {}
    
    func setupSessionForAudioPlayback() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, options: [.allowBluetooth, .duckOthers, .defaultToSpeaker])
            try session.setActive(true, options: [.notifyOthersOnDeactivation])
        } catch {
            NSLog("Error setting up audio session: \(error)")
        }
    }
}
