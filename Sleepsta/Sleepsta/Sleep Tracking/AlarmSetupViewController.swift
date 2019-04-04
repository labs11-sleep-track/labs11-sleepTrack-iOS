//
//  AlarmSetupViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit
import MediaPlayer


class AlarmSetupViewController: UIViewController, MotionManagerDelegate, SLDatePickerViewDelegate, AlarmManagerDelegate {

    // MARK: - Properties
    let motionManager = MotionManager.shared
    let dailyDataController = DailyDataController()
    let alarmManager = AlarmManager()
    
    @IBOutlet weak var settingsButton: UIButton!
    
    // These labels are mostly to show that I am getting data, won't be a part of the final design.
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBOutlet weak var hourMinuteLabel: UILabel!
    @IBOutlet weak var alarmTimePicker: SLDatePickerView!
    @IBOutlet weak var goToSleepButton: UIButton!
    @IBOutlet weak var wakeUpButton: UIButton!
    @IBOutlet weak var snoozeButton: UIButton!
    @IBOutlet weak var cancelSlider: SLSlideControl!
    @IBOutlet weak var volumeControlContainer: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
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
//        motionManager.startTracking()
//        dailyDataController.addBedTime()
//        alarmManager.setAlarm(for: alarmTimePicker.date)
//        alarmTimePicker.isEnabled = false
    }
    
    @IBAction func wakeUp(_ sender: Any) {
//        alarmManager.turnOffAlarm()
//        motionManager.stopTracking()
//        dailyDataController.addWakeTime()
//        alarmTimePicker.isEnabled = true
    }
    
    @IBAction func cancelAlarm(_ sender: Any) {
        dailyDataController.resetCurrent()
        alarmManager.turnOffAlarm()
        motionManager.stopTracking()
        alarmTimePicker.isEnabled = true
    }
    
    @IBAction func snoozeAlarm(_ sender: Any) {
//        alarmManager.snoozeAlarm()
//        alarmTimePicker.setDateTo(5, component: .minute)
    }
    
    @IBAction func postData(_ sender: Any) {
        dailyDataController.addSleepNotes(notes: "I guess I slept pretty well.")
        dailyDataController.postDailyData()
    }
    
    // MARK: - Motion Manager Delegate
    func motionManager(_ motionManager: MotionManager, didChangeTrackingTo: Bool) {
        updateButtons()
    }
    
    // MARK: - SL Date Picker View Delegate
    func datePicker(_ datePicker: SLDatePickerView, didChangeDate: Bool) {
        updateHourMinuteLabel()
    }
    
    // MARK: - Alarm Manager Delegate
    func alarmManager(_ alarmManager: AlarmManager, didSoundAlarm: Bool) {
        updateButtons()
    }
    
    // MARK: - Utility Methods
    private func setupViews() {
        let gradientView = view as! GradientView
        gradientView.setupGradient(startColor: .darkerBackgroundColor, endColor: .lighterBackgroundColor)
        
        motionManager.delegate = self
        alarmManager.delegate = self
        
        settingsButton.tintColor = .accentColor
        
        welcomeLabel.textColor = .customWhite
        welcomeLabel.text = "Welcome \(User.current?.firstName ?? "")!"
        
        userIDLabel.textColor = .customWhite
        userIDLabel.text = "" //\(User.current?.email ?? "")"
        
        hourMinuteLabel.textColor = .customWhite
        
        goToSleepButton.setTitleColor(.accentColor, for: .normal)
        wakeUpButton.setTitleColor(.accentColor, for: .normal)
        snoozeButton.setTitleColor(.pink, for: .normal)
        
        let volumeControl = MPVolumeView(frame: volumeControlContainer.bounds)
        volumeControl.showsRouteButton = false
        volumeControl.tintColor = .accentColor
        volumeControlContainer.addSubview(volumeControl)
        
        alarmTimePicker.datePickerDelegate = self
        alarmTimePicker.setDateTo(8, component: .hour)
        updateButtons()
        
    }
    
    private func updateButtons() {
        let tracking = motionManager.isTracking
        goToSleepButton.isHidden = tracking
        wakeUpButton.isHidden = !alarmManager.isAlarmSounding
        snoozeButton.isHidden = !alarmManager.isAlarmSounding
        cancelSlider.reset()
        cancelSlider.isHidden = !tracking || alarmManager.isAlarmSounding
        volumeControlContainer?.isHidden = tracking
    }
    
    private func updateHourMinuteLabel() {
        hourMinuteLabel.text = "\(alarmTimePicker.hoursFromNow) hours and \(alarmTimePicker.minutesFromNow)ish minutes"
    }
}
