//
//  SettingsTableViewController.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/2/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import UIKit
import GoogleSignIn

class SettingsTableViewController: UITableViewController {

    // MARK: - Properties
    private var isEditingNotification: Bool = false {
        didSet {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    private var notificationsNotAllowed: Bool = false
    private var isNotificationSet: Bool {
        return LocalNotificationHelper.shared.stringRepresentation() != nil
    }
    
    private let noNotificationText = "No reminder set (tap to set one)"
    private let notificationNotAllowedText = "Go to settings to give permission to set reminders."
    
    private let notificationIndexPath = IndexPath(row: 0, section: 0)
    private let datePickerIndexPath = IndexPath(row: 1, section: 0)
    private let cancelButtonIndexPath = IndexPath(row: 2, section: 0)
    private let logoutIndexPath = IndexPath(row: 1, section: 1)
    
    @IBOutlet weak var notificationLabel: UILabel!
    @IBOutlet weak var notificationTimePicker: SLDatePickerView!
    @IBOutlet weak var cancelReminderLabel: UILabel!
    
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var logoutLabel: UILabel!
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkForNotifications()
    }
    
    // MARK: - Table View Delegate
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath {
        case notificationIndexPath:
            if notificationsNotAllowed { return 60 }
        case datePickerIndexPath:
            let height = isEditingNotification ? notificationTimePicker.frame.height : 0
            return height
        case cancelButtonIndexPath:
            if !isNotificationSet {
                return 0
                
            }
        default:
            break
        }
        return 44
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return UIView.customHeaderView(with: "Notifications")
        case 1:
            return UIView.customHeaderView(with: "Account")
        default: return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath {
        case notificationIndexPath:
            UserDefaults.standard.set(true, forKey: .hasTouchedNotificationButton)
            if isEditingNotification {
                LocalNotificationHelper.shared.scheduleDailySleepReminderNotification(date: notificationTimePicker.date) {
                    DispatchQueue.main.async {
                        self.updateLabels()
                        self.isEditingNotification.toggle()
                    }
                }
            } else {
                LocalNotificationHelper.shared.requestAuthorization { (granted) in
                    DispatchQueue.main.async {
                        if granted {
                            self.isEditingNotification.toggle()
                        } else {
                            self.notificationsNotAllowed = true
                        }
                        self.updateLabels()
                    }
                }
            }
            
        case datePickerIndexPath:
            LocalNotificationHelper.shared.requestAuthorization { _ in }
            updateLabels()
            isEditingNotification.toggle()
        case cancelButtonIndexPath:
            cancelReminder()
        case logoutIndexPath:
            logout()
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
        let minute = UserDefaults.standard.object(forKey: .notificationMinute) as? Int ?? 0
        notificationTimePicker.setMinute(to: minute, rounding: false)
        
        accountLabel.textColor = .customWhite
        logoutLabel.textColor = .pink
        
        checkForNotifications()
        
    }
    
    private func checkForNotifications() {
        if UserDefaults.standard.bool(forKey: .hasTouchedNotificationButton) {
            LocalNotificationHelper.shared.requestAuthorization { (granted) in
                DispatchQueue.main.async {
                    self.notificationsNotAllowed = !granted
                    self.updateLabels()
                }
            }
        }
        updateLabels()
    }
    
    private func updateLabels() {
//        tableView.beginUpdates()
        if notificationsNotAllowed {
            notificationLabel.text = notificationNotAllowedText
        } else if let text = LocalNotificationHelper.shared.stringRepresentation() {
            notificationLabel.text = "Reminder set for: \(text)"
        } else {
            notificationLabel.text = noNotificationText
        }
        
        if let currentUser = User.current {
            accountLabel.text = "Signed in as \(currentUser.firstName ?? "") \(currentUser.lastName ?? "")"
        }
//        tableView.endUpdates()
    }
    
    private func cancelReminder() {
        LocalNotificationHelper.shared.cancelCurrentNotifications()
        updateLabels()
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    private func logout() {
        GIDSignIn.sharedInstance()?.disconnect()
        dismiss(animated: true)
    }
}
