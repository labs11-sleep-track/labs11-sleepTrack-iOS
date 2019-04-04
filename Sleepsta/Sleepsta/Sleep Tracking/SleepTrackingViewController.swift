//
//  SleepTrackingViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/4/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

protocol SleepTrackingViewControllerDelegate: class {
    func sleepTrackingVC(_ sleepTrackingVC: SleepTrackingViewController, didCancel: Bool)
    func sleepTrackingVC(_ sleepTrackingVC: SleepTrackingViewController, didTurnOffAlarm: Bool)
    func sleepTrackingVC(_ sleepTrackingVC: SleepTrackingViewController, didSnoozeAlarm: Bool)
}

class SleepTrackingViewController: UIViewController {

    // MARK: - Properties
    weak var delegate: SleepTrackingViewControllerDelegate?
    
    private var cancelSlider: SLSlideControl?
    private var stackView: UIStackView?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        let titleLabel = UILabel()
        titleLabel.text = "Sleep Tracking"
        titleLabel.textColor = .customWhite
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.constrainToSuperView(view, top: 16, leading: 24)
        
        configureViewForSleeping()
    }
    
    // MARK: - Public API
    func configureViewForAlarmSounding() {
        cancelSlider?.removeFromSuperview()
        
        if let stackView = stackView {
            stackView.constrainToCenterIn(view)
        } else {
            setupStackView()
        }
        
    }
    
    func configureViewForSleeping() {
        stackView?.removeFromSuperview()
        
        if let cancelSlider = cancelSlider {
            cancelSlider.constrainToSuperView(view, bottom: 20, centerX: 0)
        } else {
            setupCancelSlider()
        }
    }
    
    // MARK: - Actions
    @objc private func cancelAlarm() {
        delegate?.sleepTrackingVC(self, didCancel: true)
    }
    
    @objc private func turnOffAlarm() {
        delegate?.sleepTrackingVC(self, didTurnOffAlarm: true)
    }
    
    @objc private func snoozeAlarm() {
        delegate?.sleepTrackingVC(self, didSnoozeAlarm: true)
    }
    
    // MARK: - UI Layout
    private func setupCancelSlider() {
        cancelSlider = SLSlideControl()
        cancelSlider!.addTarget(self, action: #selector(cancelAlarm), for: .valueChanged)
        cancelSlider!.constrainToSuperView(view, bottom: 20, centerX: 0)
    }
    
    private func setupStackView() {
        stackView = UIStackView()
        stackView!.axis = .vertical
        stackView!.spacing = 20
        stackView!.constrainToCenterIn(view)
        
        let wakeUpButton = UIButton()
        wakeUpButton.setTitle("Wake Up!", for: .normal)
        wakeUpButton.setTitleColor(.accentColor, for: .normal)
        wakeUpButton.addTarget(self, action: #selector(turnOffAlarm), for: .touchUpInside)
        stackView?.addArrangedSubview(wakeUpButton)
        
        let snoozeButton = UIButton()
        snoozeButton.setTitle("Keep Sleeping", for: .normal)
        snoozeButton.setTitleColor(.pink, for: .normal)
        snoozeButton.addTarget(self, action: #selector(snoozeAlarm), for: .touchUpInside)
        stackView?.addArrangedSubview(snoozeButton)
    }

}
