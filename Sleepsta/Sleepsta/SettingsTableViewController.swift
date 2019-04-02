//
//  SettingsTableViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/2/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    // MARK: - Properties
    private var isEditingNotification: Bool = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    private let noNotificationText = "No reminder set (tap to set one)"
    
    private let notificationIndexPath = IndexPath(row: 0, section: 0)
    private let datePickerIndexPath = IndexPath(row: 1, section: 0)
    private let cancelButtonIndexPath = IndexPath(row: 2, section: 0)
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationTimePicker: SLDatePickerView!
    @IBOutlet weak var cancelReminderLabel: UILabel!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()

    }

    // MARK: - UI Actions
    @IBAction func dismissView(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath {
        case datePickerIndexPath:
            let height = isEditingNotification ? notificationTimePicker.frame.height : 0
            return height
        case cancelButtonIndexPath:
            if notificationLabel.text == noNotificationText { return 0 }
        default:
            break
        }
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return UIView.customHeaderView(with: "Notifications")
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath {
        case notificationIndexPath:
            if isEditingNotification { LocalNotificationHelper.shared.scheduleDailySleepReminderNotification(date: notificationTimePicker.date) }
            updateLabels()
            isEditingNotification.toggle()
        case datePickerIndexPath:
            LocalNotificationHelper.shared.requestAuthorization { _ in }
            isEditingNotification.toggle()
        case cancelButtonIndexPath:
            cancelReminder()
        default:
            break
        }
    }
    
    // MARK: - Utility Methods
    private func setupViews() {
        
        let gradientView = GradientView()
        gradientView.setupGradient(startColor: .darkerBackgroundColor, endColor: .lighterBackgroundColor)
        tableView.backgroundView = gradientView
        
        tableView.separatorColor = .darkBlue
        
        notificationLabel.textColor = .customWhite
        cancelReminderLabel.textColor = .pink
        
        let hour = UserDefaults.standard.object(forKey: .notificationHour) as? Int ?? 20
        notificationTimePicker.setHour(to: hour)
        notificationTimePicker.setMinute(to: 0)
        
        doneButton.tintColor = .accentColor
        
        updateLabels()
        
    }
    
    private func updateLabels() {
        if let text = LocalNotificationHelper.shared.stringRepresentation() {
            notificationLabel.text = "Reminder set for: \(text)"
        } else {
            notificationLabel.text = noNotificationText
        }
    }
    
    private func cancelReminder() {
        LocalNotificationHelper.shared.cancelCurrentNotifications()
        updateLabels()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}
