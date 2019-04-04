//
//  SLSleepTrackingPresentationViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/3/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class SLSleepTrackingPresentationViewController: SLViewController, AlarmManagerDelegate, PreBedSurveyViewControllerDelegate, SleepTrackingViewControllerDelegate {

    let motionManager = MotionManager.shared
    let alarmManager = AlarmManager()
    
    var preVC: PreBedSurveyViewController?
    var sleepTrackingVC: SleepTrackingViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alarmManager.delegate = self
        
        presentSleepTrackingVC()
    }
    
    // MARK: - Alarm Manager Delegate
    func alarmManager(_ alarmManager: AlarmManager, didSoundAlarm: Bool) {
        if let sleepTrackingVC = sleepTrackingVC {
            sleepTrackingVC.configureViewForAlarmSounding()
        } else {
            alarmManager.turnOffAlarm()
        }
    }
    
    func preBedSurveyViewController(_ preBedSurveyViewController: PreBedSurveyViewController, didHitNextButton: Bool) {
        let animations: () -> Void = { self.preVC?.view.alpha = 0 }
        UIView.animate(withDuration: 0.5, animations: animations) { (_) in
            self.preVC?.removeFromParent()
            self.preVC = nil
        }
    }
    
    // MARK: - Sleep Tracking View Controller Delegate
    func sleepTrackingVC(_ sleepTrackingVC: SleepTrackingViewController, didCancel: Bool) {
        dismiss(animated: true)
    }
    
    func sleepTrackingVC(_ sleepTrackingVC: SleepTrackingViewController, didTurnOffAlarm: Bool) {
        alarmManager.turnOffAlarm()
        transitionToPostSurvey()
    }
    
    func sleepTrackingVC(_ sleepTrackingVC: SleepTrackingViewController, didSnoozeAlarm: Bool) {
        alarmManager.snoozeAlarm()
        sleepTrackingVC.configureViewForSleeping()
    }
    
    // MARK: - Utility Methods
    private func presentSleepTrackingVC() {
        //motionManager.startTracking()
        sleepTrackingVC = SleepTrackingViewController()
        sleepTrackingVC?.delegate = self
        addChild(sleepTrackingVC!)
        sleepTrackingVC!.view.constrainToFill(view)
    }
    
    private func transitionToPostSurvey() {
        if let sleepTrackingVC = sleepTrackingVC {
            let animations = { sleepTrackingVC.view.alpha = 0 }
            UIView.animate(withDuration: 0.5, animations: animations) { (_) in
                sleepTrackingVC.removeFromParent()
                self.sleepTrackingVC = nil
                self.dismiss(animated: true)
            }
            
        }
    }
    
}


//        preVC = PreBedSurveyViewController()
//        preVC?.view.translatesAutoresizingMaskIntoConstraints = false
//        preVC?.delegate = self
//
//        if let preVC = preVC {
//            addChild(preVC)
//            view.addSubview(preVC.view)
//            preVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//            preVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//            preVC.view.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//            preVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//            preVC.view.layoutIfNeeded()
//        }
