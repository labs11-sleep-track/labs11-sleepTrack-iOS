//
//  SleepTrackingViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 3/20/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class SleepTrackingViewController: UIViewController, MotionManagerDelegate {

    // MARK: - Properties
    
    let motionManager = MotionManager.shared

    // These labels are mostly to show that I am getting data, won't be a part of the final design.
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    
    @IBOutlet weak var alarmTimePicker: SLDatePickerView!
    @IBOutlet weak var toggleTrackingButton: UIButton!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    @IBAction func toggleTracking(_ sender: Any) {
        motionManager.toggleTracking()
    }
    
    // MARK: - Motion Manager Delegate
    func motionManager(_ motionManager: MotionManager, didChangeTrackingTo: Bool) {
        updateTrackingButton()
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
        
        alarmTimePicker.setDateTo(8, component: .hour)
        updateTrackingButton()
    }
    
    private func updateTrackingButton() {
        let title = motionManager.isTracking ? "Stop Tracking" : "Start Tracking"
        toggleTrackingButton.setTitle(title, for: .normal)
    }
    
}
