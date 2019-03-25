//
//  SleepTrackingViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class SleepTrackingViewController: UIViewController {

    // MARK: - Properties
    
    let motionManager = MotionManager.shared

    @IBOutlet weak var alarmTimePicker: SLDatePickerView!
    @IBOutlet weak var toggleTrackingButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientView = view as! GradientView
        gradientView.setupGradient(startColor: .darkerBackgroundColor, endColor: .lighterBackgroundColor)
        
        alarmTimePicker.setDateTo(8, component: .hour)
        updateTrackingButton()
    }
    
    @IBAction func toggleTracking(_ sender: Any) {
        motionManager.toggleTracking()
        updateTrackingButton()
    }
    
    private func updateTrackingButton() {
        let title = motionManager.isTracking ? "Stop Tracking" : "Start Tracking"
        toggleTrackingButton.setTitle(title, for: .normal)
    }
    
}
