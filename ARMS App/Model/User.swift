//
//  Tresholds.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/6/24.
//  All functions and logic for threshold settings
//  Includes the user class

import Foundation
import CloudKit
import UserNotifications


// user class
class User {
    // user properties
    
    var recordID: CKRecord.ID?
    var age: Int
    var heartDisease: Bool
    var asthma: Bool
    var lungDisease: Bool
    var name: String
    var resporatoryDisease: Bool
    var email: String
    
    //@Published var progressValue: Int = 0
    
    static let shared = User()
    
    
    // threshold instances
    //var AmbientThresholds = defaultAmbientThresholds
    var ageType = "Not Set"
    var userConditions: [String] = []
    //var IndoorThresholds = thresholds()
    
    init(name: String = "", age: Int = 0, heart: Bool = false, asthma: Bool = false, lung: Bool = false, resp: Bool = false, email: String = "") {
        self.age = age
        self.heartDisease = heart
        self.asthma = asthma
        self.lungDisease = lung
        self.name = name
        self.resporatoryDisease = resp
        self.email = email
        self.ageType = User.setAgeRange(age: age)
        self.userConditions = setConditions()
        
        
        
    }
    
    
    func updateUser(user: User) {
        self.age = user.age
        self.heartDisease = user.heartDisease
        self.asthma = user.asthma
        self.lungDisease = user.lungDisease
        self.name = user.name
        self.resporatoryDisease = user.resporatoryDisease
        self.email = user.email
        self.ageType = User.setAgeRange(age: age)
        self.userConditions = setConditions()
        
    }
    

    func setConditions() -> [String] {
        var conditions: [String] = []
        
        if heartDisease {
            print("this is true")
            conditions.append("heart disease")
        }
        if asthma { conditions.append("asthma") }
        if resporatoryDisease { conditions.append("respiratory disease") }
        if ageType != "Not Set" { conditions.append(ageType) }
        
        return conditions
}
  
        
    func findRangeIndexForValue(_ value: UInt16, in aqiType: AQIRange) -> Int? {
        for (index, range) in aqiType.range.enumerated() {
            if value >= range.lowerLimit && value <= range.upperLimit {
                return index + 1  // Adding 1 to make it 1-indexed
            }
        }
        // Return nil if no range contains the value
        return nil
    }
    
    
    static private func setAgeRange(age: Int) -> String {
        var type: String
        if age < 18 && age > 0 {
            type = "young"
        } else if age > 18 && age < 55 {
            type = "middle"
        } else if age > 55 {
            type = "elderly"
        } else {
            type = "Not Set"
        }
        
        return type
        
    }
    
    // CloudKit loading and Storing
    init(record: CKRecord) {
        self.recordID = record.recordID
        self.name = record["name"] as? String ?? ""
        self.age = record["age"] as? Int ?? 0
        self.heartDisease = record["heartDisease"] as? Bool ?? false
        self.asthma = record["asthma"] as? Bool ?? false
        self.lungDisease = record["lungDisease"] as? Bool ?? false
        self.resporatoryDisease = record["lungDisease"] as? Bool ?? false
        self.email = record["email"] as? String ?? ""
    }
    

    func getAge() -> Int {
        return self.age
    }
    
    func getHeartStatus() -> Bool {
        return self.heartDisease
    }
    
    func getAsthmaStatus() -> Bool {
        return self.asthma
    }
    
    // SECTION: put method
    func setUpdates(name: String, age: Int, heart: Bool, lung: Bool, asthma: Bool, resp: Bool) {
        if self.name != name {
            self.name = name
        }
        
        if self.age != age {
            self.age = age
        }
        
        if self.heartDisease != heart {
            self.heartDisease = heart
        }
        
        if self.lungDisease != lung {
            self.lungDisease = lung
        }
        
        if self.asthma != asthma {
            self.asthma = asthma
        }
        
        if self.resporatoryDisease != resporatoryDisease {
            self.resporatoryDisease = resp
        }
        
    }
    
    

}

extension User {
    func toCKRecord() -> CKRecord {
           let record = CKRecord(recordType: "User", recordID: recordID ?? CKRecord.ID())
           record["Name"] = name
           record["Age"] = age
           record["HeartDisease"] = heartDisease
           record["Asthma"] = asthma
           record["LungDisease"] = lungDisease
           record["RespiratoryDisease"] = resporatoryDisease
           record["Email"] = email
        

           return record
       }
    
    // Convert CKRecord to User object
    static func fromCKRecord(_ record: CKRecord) -> User? {
          guard let name = record["Name"] as? String,
                let age = record["Age"] as? Int64,
                let heartDiseaseValue = record["HeartDisease"] as? Int64,
                let asthmaValue = record["Asthma"] as? Int64,
                let lungDiseaseValue = record["LungDisease"] as? Int64,
                let resporatoryDiseaseValue = record["RespiratoryDisease"] as? Int64,
                let email = record["Email"] as? String
           else {
                return nil
           }
         
          let heartDisease = heartDiseaseValue != 0
          let asthma = asthmaValue != 0
          let lungDisease = lungDiseaseValue != 0
          let resp = resporatoryDiseaseValue != 0
          
          let user = User(name: name, age: Int(age), heart: heartDisease, asthma: asthma, lung: lungDisease, resp: resp, email: email)

           user.recordID = record.recordID

    
           return user
       }
    
}








