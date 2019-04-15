//
//  AlarmSetupViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit
import MediaPlayer


class AlarmSetupViewController: SLViewController, SLDatePickerViewDelegate {

    // MARK: - Properties
    private var songSelectVC: SongSelectViewController!
    
    // These labels are mostly to show that I am getting data, won't be a part of the final design.
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBOutlet weak var hourMinuteLabel: UILabel!
    @IBOutlet weak var alarmTimePicker: SLDatePickerView!
    @IBOutlet weak var goToSleepButton: UIButton!
    @IBOutlet weak var songSelectContainer: UIView!
    @IBOutlet weak var volumeControlContainer: UIView!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        alarmTimePicker.setDateTo(8, component: .hour)
    }
    
    // MARK: - UI Actions
    @IBAction func goToSleep(_ sender: Any) {
        let sleepTrackingPresentationVC = SleepTrackingPresentationViewController()
        sleepTrackingPresentationVC.alarmManager.mediaItem = songSelectVC.mediaItem
        sleepTrackingPresentationVC.alarmManager.setAlarm(for: Date(timeIntervalSinceNow: 5))
        present(sleepTrackingPresentationVC, animated: true)
    }
    
    // MARK: - SL Date Picker View Delegate
    func datePicker(_ datePicker: SLDatePickerView, didChangeDate: Bool) {
        updateLabels()
    }
    
    // MARK: - Utility Methods
    private func setupViews() {
        
        welcomeLabel.textColor = .customWhite
        
        userIDLabel.textColor = .customWhite
        userIDLabel.text = "" //\(User.current?.email ?? "")"
        
        hourMinuteLabel.textColor = .customWhite
        
        goToSleepButton.setTitleColor(.accentColor, for: .normal)
        
        let volumeControl = MPVolumeView(frame: volumeControlContainer.bounds)
        volumeControl.showsRouteButton = false
        volumeControl.tintColor = .accentColor
        volumeControlContainer.addSubview(volumeControl)
        volumeControlContainer.backgroundColor = .clear
        
        alarmTimePicker.datePickerDelegate = self
        alarmTimePicker.setDateTo(8, component: .hour)
        
        songSelectVC = SongSelectViewController()
        add(songSelectVC, toView: songSelectContainer)
        
    }
    
    private func updateLabels() {
        welcomeLabel.text = "Set Alarm"
        
        hourMinuteLabel.text = "Sleep for \(alarmTimePicker.hoursFromNow) hours and \(alarmTimePicker.minutesFromNow)ish minutes"
    }
    
}
