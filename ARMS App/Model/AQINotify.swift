//
//  NotificationExtensions.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/14/24.
//

import Foundation
import UserNotifications


func messageForUV(_ index: Int) -> String {
    switch index {
    case 3:
        return "UV index is above the normal range. It is recommended to apply protection or seek shade."
    case 6:
        return "UV index is 6 or above. Apply protection or seek shade."
    case 8:
        return "UV index is 8 or above. You will get skin burn if protection not applied!"
    case 11:
        return "UV index is at maximum value. You will feel skin burn in less than 10 minutes. Apply protection or seek shade immediately!"
    default:
        return "Unknown Level"
    }
}

func titleForUV(_ score: Int) -> String {
    switch score {
    case 3:
        return "UV Levels are mild."
    case 6:
        return "UV Levels are high."
    case 8:
        return "CAUTION: UV Levels are very high!"
    case 11:
        return "WARNING: UV Levels extremely high!"
    default:
        return "Unknown Level"
    }
}

func messageForPAQR(_ index: Int) -> String {
    switch index {
    case 2:
        return "Pollutant concentrations you are sensitive to may be high. Check your AQI Report for details."
    case 4:
        return "Multiple pollutant concentrations may be high. Please check the AQI Report and leave the area"
    case 5:
        return "Leave the Area Immediately!"
    default:
        return "Unknown Level"
    }
}

func titleForPAQR(_ score: Int) -> String {
    switch score {
    case 2:
        return "PAQR score below 80"
    case 4:
        return "CAUTION: PAQR score below 60"
    case 5:
        return "WARNING: PAQR scoe"
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
    let content = UNMutableNotificationContent()
    content.title = "5 minute update"
    content.body = "Check the AQI Report for latest updates"
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
 
 




    
    
    
    






