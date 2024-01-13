//
//  Tresholds.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/6/24.
//  All functions and logic for threshold settings
//  Includes the user class

import Foundation
import CloudKit


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

    
    // threshold instances
    var AmbientThresholds = defaultAmbientThresholds
    var ageType = "Not Set"
    //var IndoorThresholds = thresholds()
    
    init(name: String, age: Int, heart: Bool, asthma: Bool, lung: Bool, resp: Bool) {
        self.age = age
        self.heartDisease = heart
        self.asthma = asthma
        self.lungDisease = lung
        self.name = name
        self.resporatoryDisease = resp
        self.AmbientThresholds = setHourThresholds()
        self.ageType = setAgeRange(age: age)
    }
    
    // SECTION: set thresholds algorithm
    private func setHourThresholds() -> pollutantThresholds {
        var thresholds = defaultAmbientThresholds
        if self.heartDisease {
            decreaseThreshold(thresh: &thresholds, AQItype: .co)
        }
        
        if self.lungDisease {
            decreaseThreshold(thresh: &thresholds, AQItype: .pm1)
            decreaseThreshold(thresh: &thresholds, AQItype: .pm2_5)
        }
        
        return thresholds
        
    }
    
    //private func setIndoorThresholds() {
        
    //}
    
    private func setAgeRange(age: Int) -> String {
        var type: String
        if age < 18 && age > 0 {
            type = "young"
        } else if age > 18 && age < 55 {
            type = "middle"
        } else {
            type = "elderly"
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
        saveAgeRangeToCloud(range: self.ageType)
        
    }
    
    func convertAgeRangeToCkRecord(range: String) -> CKRecord {
        let record = CKRecord(recordType: "AgeRange")
        if range == "young" {
            record["young"] = range as CKRecordValue
        }
        if range ==  "middle" {
            record["middle-aged"] = range as CKRecordValue
        }
        if range == "elderly" {
            record["elderly"] = range as CKRecordValue
        }
        if range == "not set" {
            record["Not Set"] = range as CKRecordValue
        }
        
        return record
       
    }
    
    func saveAgeRangeToCloud(range: String) {
        let record = convertAgeRangeToCkRecord(range: self.ageType)
        CKContainer.default().publicCloudDatabase.save(record) {savedRecord, error in
            if let error = error {
                print("Could not save age range to cloud")
            } else {
                print("Age range saved")
            }
            
        }
    }

    
    func toCKRecord() -> CKRecord {
           let record = CKRecord(recordType: "User", recordID: recordID ?? CKRecord.ID())
           record["name"] = name
           record["age"] = age
           record["heartDisease"] = heartDisease
           record["asthma"] = asthma
           record["lungDisease"] = lungDisease
           // Save thresholds to record
           return record
       }
    
    // SECTION: get methods
    /*
    func getPM() -> (pm1: Int, pm2_5: Int, pm10: Int) {
        print("pm1: \(self.userThresholds.pm1Thresh) pm2.5: \(self.userThresholds.pm2_5Thresh) pm10: \(self.userThresholds.pm10Thresh)")
        return (self.userThresholds.pm1Thresh, self.userThresholds.pm2_5Thresh, self.userThresholds.pm10Thresh)
    }
    
    func getvoc() -> Int {
        print("voc threshold: \(self.userThresholds.vocThresh)")
        return self.userThresholds.vocThresh
    }
    
    func getCo() -> Int {
        print("co threshold: \(self.userThresholds.coThresh)")
        return self.userThresholds.coThresh
    }
    
    func getUv() -> Int {
        print("uv threshold: \(self.userThresholds.uvThresh)")
        return self.userThresholds.uvThresh
    }
     
     */
    
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
    func setUpdates(name: String, age: Int, heart: Bool, lung: Bool, asthma: Bool) {
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
        
    }
    

}

func saveUser(_ user: User) {
    let record = user.toCKRecord()
    CKContainer.default().publicCloudDatabase.save(record) { (savedRecord, error) in
        guard error == nil else {
            print("Error saving user: \(error!.localizedDescription)")
            return
        }
        print("User saved successfully.")
    }
}







