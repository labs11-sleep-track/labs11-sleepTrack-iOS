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
    let dailyDataController = DailyDataController()
    
    @IBOutlet weak var settingsButton: UIButton!
    
    // These labels are mostly to show that I am getting data, won't be a part of the final design.
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBOutlet weak var hourMinuteLabel: UILabel!
    @IBOutlet weak var alarmTimePicker: SLDatePickerView!
    @IBOutlet weak var goToSleepButton: UIButton!
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
        let sleepTrackingPresentationVC = SLSleepTrackingPresentationViewController()
        sleepTrackingPresentationVC.alarmManager.setAlarm(for: alarmTimePicker.date)
        present(sleepTrackingPresentationVC, animated: true)
    }
    
    
    @IBAction func postData(_ sender: Any) {
        dailyDataController.addSleepNotes(notes: "I guess I slept pretty well.")
        dailyDataController.postDailyData()
    }
    
    // MARK: - SL Date Picker View Delegate
    func datePicker(_ datePicker: SLDatePickerView, didChangeDate: Bool) {
        updateHourMinuteLabel()
    }
    
    // MARK: - Utility Methods
    private func setupViews() {        
        settingsButton.tintColor = .accentColor
        
        welcomeLabel.textColor = .customWhite
        welcomeLabel.text = "Welcome \(User.current?.firstName ?? "")!"
        
        userIDLabel.textColor = .customWhite
        userIDLabel.text = "" //\(User.current?.email ?? "")"
        
        hourMinuteLabel.textColor = .customWhite
        
        goToSleepButton.setTitleColor(.accentColor, for: .normal)
        
        let volumeControl = MPVolumeView(frame: volumeControlContainer.bounds)
        volumeControl.showsRouteButton = false
        volumeControl.tintColor = .accentColor
        volumeControlContainer.addSubview(volumeControl)
        
        alarmTimePicker.datePickerDelegate = self
        alarmTimePicker.setDateTo(8, component: .hour)
        
    }
    
    private func updateHourMinuteLabel() {
        hourMinuteLabel.text = "\(alarmTimePicker.hoursFromNow) hours and \(alarmTimePicker.minutesFromNow)ish minutes"
    }
}
