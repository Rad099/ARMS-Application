//
//  NotificationExtensions.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/14/24.
//

import Foundation
import UserNotifications



func messageForPAQR(_ index: Int) -> String {
    switch index {
    case 2:
        return "PAQR score . Avoid heavy exertion or extended periods of time in the area"
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

func titleForPAQR(_ score: Int) -> String {
    switch score {
    case 2:
        return "PAQR score below 80"
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

func titleForConentration(_ score: Double, _ type: PollutantType) -> String {
    switch score {
    //case 0.2:
          //  return "\(type.rawValue) is mild "
   // case 0.4:
          //  return " \(type.rawValue) is high "
    case 0.6:
            return "\(type.rawValue) is very high "
    case 1.0:
            return "\(type.rawValue) is hazardous"
        default:
            return "Unknown Level"
    }
}

func messageForConcentration(_ score: Double, _ type: PollutantType) -> String {
    switch score {
    //case 0.2:
       // return "avoid heavy exertion or leave the area"
   // case 0.4:
       //     return "It is recommended to leave the area"
    case 0.6:
            return "CAUTION: concentartions are very high. You may start to feel symptoms"
    case 1.0:
            return "WARNING: concentrations are extremely high. You will feel symptoms. Move immediatley"
    default:
            return "Unknown Level"
    }
}

func personalizedTitle(_ score: Double, _ type: PollutantType) -> String {
    switch score {
    case 0.2:
        return "sensitive pollutant: \(type.rawValue) mild"
    case 0.4:
           return "sensitive pollutant: \(type.rawValue) is high"
    case 0.6:
            return "sensitive pollutant: \(type.rawValue) is very high"
    case 1.0:
            return "sensitive pollutant: \(type.rawValue) hazardous"
    default:
            return "Unknown Level"
    }
}

func personalizedMessage(_ score: Double, _ type: PollutantType) -> String {
    switch score {
    case 0.2:
        return "avoid heavy exertion or leave the area"
    case 0.4:
           return "It is recommended to leave the area"
    case 0.6:
            return "CAUTION: concentartions are very high. You may start to feel symptoms"
    case 1.0:
            return "WARNING: concentrations are extremely high. You will feel symptoms. Move immediatley"
    default:
            return "Unknown Level"
    }
}


func scheduleNotification(_ score: Double, _ type: PollutantType) {
    print("We got to notifications")
    let content = UNMutableNotificationContent()
    content.title = titleForConentration(score, type)
    content.body = messageForConcentration(score, type)
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

func scheduleUpdateNotification() {
    print("We got to notifications")
    let content = UNMutableNotificationContent()
    content.title = "Average Collection Update"
    content.body = "Check latest values"
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
 
 




    
    
    
    






