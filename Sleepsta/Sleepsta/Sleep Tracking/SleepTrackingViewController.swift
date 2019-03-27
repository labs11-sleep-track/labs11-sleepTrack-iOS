//
//  SleepTrackingViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit
import MediaPlayer


class SleepTrackingViewController: UIViewController, MotionManagerDelegate {

    // MARK: - Properties
    
    let motionManager = MotionManager.shared
    let dailyDataController = DailyDataController()
    let alarmManager = AlarmManager()
    
    // These labels are mostly to show that I am getting data, won't be a part of the final design.
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBOutlet weak var alarmTimePicker: SLDatePickerView!
    @IBOutlet weak var goToSleepButton: UIButton!
    @IBOutlet weak var wakeUpButton: UIButton!
    @IBOutlet weak var volumeControlContainer: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    @IBAction func goToSleep(_ sender: Any) {
        motionManager.startTracking()
        dailyDataController.addBedTime()
        alarmManager.setAlarm(for: Date(timeIntervalSinceNow: 5))
    }
    
    @IBAction func wakeUp(_ sender: Any) {
        alarmManager.turnOffAlarm()
        motionManager.stopTracking()
        dailyDataController.addWakeTime()
        
    }
    
    @IBAction func postData(_ sender: Any) {
        dailyDataController.addSleepNotes(notes: "I guess I slept pretty well.")
        dailyDataController.postDailyData()
    }
    
    // MARK: - Motion Manager Delegate
    func motionManager(_ motionManager: MotionManager, didChangeTrackingTo: Bool) {
        updateButtons()
    }
    
    // MARK: - Utility Methods
    private func setupViews() {
        let gradientView = view as! GradientView
        gradientView.setupGradient(startColor: .darkerBackgroundColor, endColor: .lighterBackgroundColor)
        
        motionManager.delegate = self
        
        welcomeLabel.textColor = .white
        welcomeLabel.text = "Welcome \(User.current?.firstName ?? "")!"
        
        userIDLabel.textColor = .white
        userIDLabel.text = "\(User.current?.email ?? "")"
        
        let volumeControl = MPVolumeView(frame: volumeControlContainer.bounds)
        volumeControl.showsRouteButton = false
        volumeControlContainer.addSubview(volumeControl)
        
        alarmTimePicker.setDateTo(8, component: .hour)
        updateButtons()
    }
    
    private func updateButtons() {
        let tracking = motionManager.isTracking
        goToSleepButton.isHidden = tracking
        wakeUpButton.isHidden = !tracking
    }
}
