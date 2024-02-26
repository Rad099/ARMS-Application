//
//  NotificationExtensions.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/14/24.
//

import Foundation
import UserNotifications



func messageForRangeIndex(_ index: Int) -> String {
    switch index {
    case 2:
        return "index levels are a bit high. Avoid heavy exertion or extended periods of time in the area"
    case 3:
        return "index level are high. It is advisable to leave the area "
    case 4:
        return "CAUTION: index level is very high. You may start to feel symptoms"
    case 5:
        return "WARNING: index level is extremely high. You will feel symptoms. Move immediatley"
    default:
        return "Unknown Level"
    }
}

func scheduleNotification() {
    let content = UNMutableNotificationContent()
    content.title = "Notification Test"
    content.body = "The Values were updated."
    content.sound = UNNotificationSound.default

    // Trigger the notification in 5 seconds
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

    // Unique identifier for each notification
    let identifier = UUID().uuidString

    // Create the request
    let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

    // Add the request to the notification center
    UNUserNotificationCenter.current().add(request) { error in
        if let error = error {
            print("Error scheduling notification: \(error)")
        }
    }
}




    
    
    
    






