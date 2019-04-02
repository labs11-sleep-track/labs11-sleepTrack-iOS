//
//  SettingsTableViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/2/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    private var isEditingNotification: Bool = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationTimePicker: SLDatePickerView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()

    }

    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let datePickerIndexPath = IndexPath(row: 1, section: 0)
        if indexPath == datePickerIndexPath {
            let height = isEditingNotification ? notificationTimePicker.frame.height : 0
            return height
        } else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let label = UILabel()
            label.text = "Notifications"
            label.textColor = .customWhite
            return label
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let notificationIndexPath = IndexPath(row: 0, section: 0)
        if indexPath == notificationIndexPath {
            if isEditingNotification {
                LocalNotificationHelper.shared.scheduleDailySleepReminderNotification(date: notificationTimePicker.date)
                updateLabels()
            } else {
                LocalNotificationHelper.shared.requestAuthorization { _ in }
            }
            isEditingNotification.toggle()
        }
    }
    
    // MARK: - Utility Views
    private func setupViews() {
        
        let gradientView = GradientView()
        gradientView.setupGradient(startColor: .darkerBackgroundColor, endColor: .lighterBackgroundColor)
        tableView.backgroundView = gradientView
        
        tableView.separatorColor = .darkBlue
        
        notificationLabel.textColor = .customWhite
        
        doneButton.tintColor = .accentColor
        
        updateLabels()
        
    }
    
    private func updateLabels() {
        if let text = LocalNotificationHelper.shared.stringRepresentation() {
            notificationLabel.text = "Reminder set for: \(text)"
        } else {
            notificationLabel.text = "No reminder set (tap to set one)"
        }
    }
}
