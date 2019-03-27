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
            try session.setCategory(.playback, mode: .default, options: [.allowBluetooth])
            try session.setActive(true, options: [])
        } catch {
            NSLog("Error setting up audio session: \(error)")
        }
    }
    
    func endPlaying() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false, options: [.notifyOthersOnDeactivation])
        } catch {
            NSLog("Error deactivating audio session: \(error)")
        }
    }
}
