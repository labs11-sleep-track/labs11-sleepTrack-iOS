//
//  AlarmManager.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/27/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation

class AlarmManager: AudioPlayerDelegate {

    private let player = AudioPlayer()
    private var timer: Timer?
    private var isAlarmSounding: Bool = false
    
    init() {
        player.delegate = self
    }
    
    func setAlarm(for date: Date) {
        // Get rid of existing alarm
        turnOffAlarm()
        // Make a new timer to sound the alarm
        timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(soundAlarm), userInfo: nil, repeats: false)
        // Add the timer to the current run loop.
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.default)
    }
    
    func snoozeAlarm() {
        // Get a new date that is 5 minutes from now
        let date = Date(timeIntervalSinceNow: 60 * 5)
        // Set a new alarm with that date
        setAlarm(for: date)
    }
    
    func turnOffAlarm() {
        // Stop the currently playing sound
        player.pause()
        
        // Reset the alarm is sounding bool
        isAlarmSounding = false
        
        // Reset the timer
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Audio Player Delegate
    func playerDidChangeState(_ player: AudioPlayer) {
        if !player.isPlaying && isAlarmSounding {
            playSound()
        }
    }
    
    // MARK: - Utility Methods
    @objc private func soundAlarm() {
        isAlarmSounding = true
        playSound()
    }
    
    private func playSound() {
        let url = Bundle.main.url(forResource: "shipBell", withExtension: "wav")!
        player.play(file: url)
    }
}
