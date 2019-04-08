//
//  SLSleepTrackingPresentationViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/3/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class SLSleepTrackingPresentationViewController: SLViewController, AlarmManagerDelegate, PreBedSurveyViewControllerDelegate, SleepTrackingViewControllerDelegate, PostBedSurveyViewControllerDelegate {

    let motionManager = MotionManager.shared
    let alarmManager = AlarmManager()
    let dailyDataController = DailyDataController()
    
    var preVC: PreBedSurveyViewController?
    var sleepTrackingVC: SleepTrackingViewController?
    var postBedSurveyVC: PostBedSurveyViewController?
    
    private var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        alarmManager.delegate = self
        
        setupCancelButton()
        
        presentSleepTrackingVC()
        
    }
    
    deinit {
        alarmManager.turnOffAlarm()
    }
    
    // MAR: - Actions
    @objc private func cancelAlarm() {
        motionManager.stopTracking()
        dismiss(animated: true)
    }
    
    // MARK: - Alarm Manager Delegate
    func alarmManager(_ alarmManager: AlarmManager, didSoundAlarm: Bool) {
        if let sleepTrackingVC = sleepTrackingVC {
            sleepTrackingVC.configureViewForShowingOptions(true)
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

    }
    
    func sleepTrackingVC(_ sleepTrackingVC: SleepTrackingViewController, didChangeShowButtonsTo: Bool) {
        if didChangeShowButtonsTo {
            sleepTrackingVC.configureViewForShowingOptions(false)
            cancelButton.isHidden = false
        } else {
            sleepTrackingVC.configureViewForSleeping()
            cancelButton.isHidden = true
        }
    }
    
    func sleepTrackingVC(_ sleepTrackingVC: SleepTrackingViewController, didTurnOffAlarm: Bool) {
        alarmManager.turnOffAlarm()
        motionManager.stopTracking()
        dailyDataController.addWakeTime()
        transitionToPostSurvey()
    }
    
    func sleepTrackingVC(_ sleepTrackingVC: SleepTrackingViewController, didSnoozeAlarm: Bool) {
        alarmManager.snoozeAlarm()
        sleepTrackingVC.configureViewForSleeping()
        sleepTrackingVC.configureLabels()
        cancelButton.isHidden = true
    }
    
    // MARK: Post Bed Survey View Controller Delegate
    func postBecSurveyVC(_ postBedSurveryVC: PostBedSurveyViewController, didSubmitSurvey: Bool, with notes: String) {
        dailyDataController.addSleepNotes(notes: notes)
        dailyDataController.postDailyData()
        dismiss(animated: true)
    }
    
    // MARK: - Utility Methods
    private func setupCancelButton() {
        cancelButton = UIButton.customButton(with: "", with: .negative)
        cancelButton.setImage(UIImage(named: "cancel")!, for: .normal)
        cancelButton.constrainToSuperView(view, safeArea: true, top: 24, trailing: 20)
        cancelButton.addTarget(self, action: #selector(cancelAlarm), for: .touchUpInside)
    }
    
    private func presentSleepTrackingVC() {
        cancelButton.isHidden = true
        dailyDataController.addBedTime()
        motionManager.startTracking()
        sleepTrackingVC = SleepTrackingViewController()
        sleepTrackingVC?.delegate = self
        addChild(sleepTrackingVC!)
        sleepTrackingVC!.view.constrainToFill(view)
        view.sendSubviewToBack(sleepTrackingVC!.view)
    }
    
    private func transitionToPostSurvey() {
        if let sleepTrackingVC = sleepTrackingVC {
            let animations = { sleepTrackingVC.view.alpha = 0 }
            let completion: (Bool) -> Void = { _ in
                sleepTrackingVC.removeFromParent()
                self.sleepTrackingVC = nil
                self.presentPostSleepSurvey()
            }
            UIView.animate(withDuration: 0.5, animations: animations, completion: completion)
        }
    }
    
    private func presentPostSleepSurvey() {
        postBedSurveyVC = PostBedSurveyViewController()
        postBedSurveyVC?.delegate = self
        addChild(postBedSurveyVC!)
        postBedSurveyVC!.view.constrainToFill(view)
        view.sendSubviewToBack(postBedSurveyVC!.view)
        cancelButton.isHidden = false
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
