//
//  Notifications.swift
//  Todoex
//
//  Created by Admin on 10/8/20.
//

import Foundation
import UserNotifications

struct Notifications {
    
    func testNotifiaction() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if success {
                self.scheduleTest()
            }
            else {
                print(error!)
            }
        }
    }
    
    func scheduleTest() {
        let content = UNMutableNotificationContent()
        content.title = "Hello"
        content.body = "How are you?"
        content.sound = .default
        
        let targetDate = Date().addingTimeInterval(10)
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        
        let request = UNNotificationRequest(identifier: "some_id", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("Something went wrong")
            }
        }
    }
    
}
