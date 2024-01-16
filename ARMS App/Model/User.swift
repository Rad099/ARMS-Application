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
    var email: String

    
    // threshold instances
    var AmbientThresholds = defaultAmbientThresholds
    var ageType = "Not Set"
    //var IndoorThresholds = thresholds()
    
    init(name: String = "", age: Int = 0, heart: Bool = false, asthma: Bool = false, lung: Bool = false, resp: Bool = false, email: String = "") {
        self.age = age
        self.heartDisease = heart
        self.asthma = asthma
        self.lungDisease = lung
        self.name = name
        self.resporatoryDisease = resp
        self.email = email
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
    
    private func storeThresholds(thresholds: pollutantThresholds) {
        //let thresholds = PollutantThresholds(/* initialize with your data */)
        if let thresholdsData = serializeThresholds(thresholds) {
            let record = CKRecord(recordType: "User")
            record["pollutantThresholds"] = thresholdsData as CKRecordValue
            // Save the record to CloudKit as usual
        }

    }
    
 
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
        self.email = record["email"] as? String ?? ""
        //saveAgeRangeToCloud(range: self.ageType)
        storeThresholds(thresholds: self.AmbientThresholds)
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
           //record["AgeType"] = ageType

           //if let thresholdsData = serializeThresholds(AmbientThresholds) {
             //  record["AmbientPollutantThresholds"] = thresholdsData as CKRecordValue
           //}
            

           return record
       }
    
    // Convert CKRecord to User object
    static func fromCKRecord(_ record: CKRecord) -> User? {
           print("check here")
            guard let name = record["Name"] as? String,
                let age = record["Age"] as? Int64,
                let heartDiseaseValue = record["HeartDisease"] as? Int64,
                let asthmaValue = record["Asthma"] as? Int64,
                let lungDiseaseValue = record["LungDisease"] as? Int64,
                let resporatoryDiseaseValue = record["RespiratoryDisease"] as? Int64,
                let email = record["Email"] as? String
           else {
                    print("this happened")
                    return nil
           }
         
          print("here now. heartDisease: \(heartDiseaseValue)")
          let heartDisease = heartDiseaseValue != 0
          let asthma = asthmaValue != 0
          let lungDisease = lungDiseaseValue != 0
          let resp = resporatoryDiseaseValue != 0
          
          let user = User(name: name, age: Int(age), heart: heartDisease, asthma: asthma, lung: lungDisease, resp: resp, email: email)

           user.recordID = record.recordID

           //if let thresholdsData = record["AmbientPollutantThresholds"] as? Data {
            //   user.AmbientThresholds = deserializeThresholds(thresholdsData) ?? defaultAmbientThresholds
           //}

           return user
       }
    
}









