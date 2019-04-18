//
//  LocalNotificationHelper.swift
//  Sleepsta
//
//  Created by Dillon McElhinney on 4/2/19.
//  Copyright © 2019 Dillon McElhinney. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationHelper: NSObject, UNUserNotificationCenterDelegate {
    
    static let shared = LocalNotificationHelper()
    private override init() {}
    
    //Helper method to get the authorization status for notifications
    func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            completion(settings.authorizationStatus)
        }
    }
    
    //Helper method to request notification authorization
    func requestAuthorization(completion: @escaping (Bool) -> Void ) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if let error = error { NSLog("Error requesting authorization status for local notifications: \(error)") }
            
            completion(success)
        }
    }
    
    //Method to create a daily reminder notification
    func scheduleDailySleepReminderNotification(date: Date) {

        cancelCurrentNotifications()
        
        let content = UNMutableNotificationContent()
        content.title = "Go to sleep!"
        content.body = "You asked me to remind you to go to sleep. This is it. The rest is up to you."
        content.sound = .default
        
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = dateComponents.hour
        let minute = dateComponents.minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: .reminderIdentifier, content: content, trigger: trigger)
        
        
        UserDefaults.standard.set(hour, forKey: .notificationHour)
        UserDefaults.standard.set(minute, forKey: .notificationMinute)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    func cancelCurrentNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [.reminderIdentifier])
        UserDefaults.standard.removeObject(forKey: .notificationHour)
        UserDefaults.standard.removeObject(forKey: .notificationMinute)
    }
    
    func stringRepresentation() -> String? {
        guard var hour = UserDefaults.standard.object(forKey: .notificationHour) as? Int,
            let minute = UserDefaults.standard.object(forKey: .notificationMinute) as? Int else { return nil }
        let modifier = hour < 12 ? "a.m." : "p.m."
        
        if hour > 12 { hour -= 12 }
        if hour == 0 { hour += 12 }
        
        let spacer = minute < 10 ? "0" : ""
        
        return "\(hour):\(spacer)\(minute) \(modifier)"
    }
}
