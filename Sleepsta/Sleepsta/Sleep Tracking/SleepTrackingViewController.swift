//
//  SleepTrackingViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/4/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

protocol SleepTrackingViewControllerDelegate: class {
    var alarmManager: AlarmManager { get }
    func sleepTrackingVC(_ sleepTrackingVC: SleepTrackingViewController, didCancel: Bool)
    func sleepTrackingVC(_ sleepTrackingVC: SleepTrackingViewController, didChangeShowButtonsTo: Bool)
    func sleepTrackingVC(_ sleepTrackingVC: SleepTrackingViewController, didTurnOffAlarm: Bool)
    func sleepTrackingVC(_ sleepTrackingVC: SleepTrackingViewController, didSnoozeAlarm: Bool)
}

class SleepTrackingViewController: UIViewController {

    // MARK: - Properties
    weak var delegate: SleepTrackingViewControllerDelegate?
    
    private var cancelSlider: SLSlideControl?
    private var stackView: UIStackView?
    private var snoozeButton: UIButton?
    private var titleLabel: UILabel?
    private var subtitleLabel: UILabel?
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        configureLabels()
        configureViewForSleeping()
    }
    
    // MARK: - Public API
    func configureLabels() {
        setupLabels()
    }
    
    func configureViewForShowingOptions(_ isAlarmSounding: Bool) {
        if isAlarmSounding { cancelSlider?.removeFromSuperview() }
        
        if let stackView = stackView {
            stackView.constrainToCenterIn(view)
        } else {
            setupStackView()
        }
        cancelSlider?.reset()
    }
    
    func configureViewForSleeping() {
        stackView?.removeFromSuperview()
        
        if let cancelSlider = cancelSlider {
            cancelSlider.constrainToSuperView(view, bottom: 32, centerX: 0)
        } else {
            setupCancelSlider()
        }
        cancelSlider?.reset()
    }
    
    // MARK: - Actions
    @objc private func cancelAlarm() {
        delegate?.sleepTrackingVC(self, didCancel: true)
    }
    
    @objc private func showOptions() {
        let showButtons = stackView?.superview == nil
        delegate?.sleepTrackingVC(self, didChangeShowButtonsTo: showButtons)
    }
    
    @objc private func turnOffAlarm() {
        delegate?.sleepTrackingVC(self, didTurnOffAlarm: true)
    }
    
    @objc private func snoozeAlarm() {
        delegate?.sleepTrackingVC(self, didSnoozeAlarm: true)
    }
    
    // MARK: - UI Layout
    private func setupLabels() {
        if titleLabel == nil {
            titleLabel = UILabel.titleLabel(with: "Sleep Tracking", and: .darkBlue)
            titleLabel!.constrainToSuperView(view, top: 16, leading: 24)
        }
        
        guard let alarmTime = delegate?.alarmManager.timeString else { return }
        let subtitleString = "Alarm set for: \(alarmTime)"
        
        if let subtitleLabel = subtitleLabel {
            subtitleLabel.text = subtitleString
        } else {
            subtitleLabel = UILabel.subtitleLabel(with: subtitleString, and: .darkBlue)
            subtitleLabel!.textAlignment = .center
            subtitleLabel!.constrainToCenterIn(view)
        }
    }
    
    private func setupCancelSlider() {
        cancelSlider = SLSlideControl()
        cancelSlider!.addTarget(self, action: #selector(showOptions), for: .valueChanged)
        cancelSlider!.constrainToSuperView(view, bottom: 32, centerX: 0)
    }
    
    private func setupStackView() {
        stackView = UIStackView()
        stackView!.axis = .vertical
        stackView!.spacing = 48
        stackView!.constrainToCenterIn(view)
        
        snoozeButton = UIButton.customButton(with: "Add 5 Min", with: .negative)
        snoozeButton?.addTarget(self, action: #selector(snoozeAlarm), for: .touchUpInside)
        stackView?.addArrangedSubview(snoozeButton!)
        
        let wakeUpButton = UIButton.customButton(with: "Wake Up Now!")
        wakeUpButton.addTarget(self, action: #selector(turnOffAlarm), for: .touchUpInside)
        stackView?.addArrangedSubview(wakeUpButton)
    }

}
