//
//  AlarmManager.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/27/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation
import MediaPlayer

protocol AlarmManagerDelegate: class {
    func alarmManager(_ alarmManager: AlarmManager, didSoundAlarm: Bool)
}

class AlarmManager: AudioPlayerDelegate {

    static let timeFormatter: DateFormatter = {
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = .short
        return timeFormatter
    }()
    
    // MARK: - Properties
    weak var delegate: AlarmManagerDelegate?
    
    private let player = AudioPlayer()
    private var timer: Timer?
    private(set) var date: Date!
    private(set) var isAlarmSounding: Bool = false {
        didSet { delegate?.alarmManager(self, didSoundAlarm: isAlarmSounding)}
    }
    
    var timeString: String {
        if let date = date {
            return AlarmManager.timeFormatter.string(from: date)
        }
        return ""
    }
    
    // MARK: - Initializers
    init() {
        player.delegate = self
    }
    
    deinit {
        turnOffAlarm()
    }
    
    // MARK: - Public API
    func setAlarm(for date: Date) {
        self.date = date
        
        // Get rid of existing alarm
        turnOffAlarm()
        
        // Make a new timer to sound the alarm
        timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(soundAlarm), userInfo: nil, repeats: false)
        // Add the timer to the current run loop.
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.default)
        
    }
    
    func snoozeAlarm() {
        // Get a new date that is 5 minutes from now
        let date = Date(timeIntervalSinceNow: 5 * 60)
        // Set a new alarm with that date
        setAlarm(for: date)
    }
    
    func turnOffAlarm() {
        // Stop the currently playing sound
        player.pause()
        AVSessionHelper.shared.endPlaying()
        
        // Reset the alarm is sounding bool
        isAlarmSounding = false
        
        // Reset the timer
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Audio Player Delegate
    func playerDidChangeState(_ player: AudioPlayer) {
        if !player.isPlaying && isAlarmSounding {
            player.play()
        }
    }
    
    // MARK: - Utility Methods
    @objc private func soundAlarm() {
        AVSessionHelper.shared.setupSessionForAudioPlayback()
        // Load the audio file
        let url = Bundle.main.url(forResource: "shipBell", withExtension: "wav")!
        player.load(file: url)
        
        isAlarmSounding = true
        player.play()
    }
}
