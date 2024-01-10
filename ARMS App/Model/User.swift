//
//  Tresholds.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/6/24.
//  All functions and logic for threshold settings
//  Includes the user class

import Foundation


// thresholds struct
struct thresholds: Codable {
    var pm1Thresh = 0
    var pm2_5Thresh = 0
    var pm10Thresh = 0
    var vocThresh = 0
    var coThresh = 0
    var uvThresh = 0
}

// user class
class user: Codable {
    
    // user properties
    var age: Int
    var heartDisease: Bool
    var asthma: Bool
    var lungDisease: Bool
    var name: String
    
    // threshold instance
    var userThresholds = thresholds()
    
    init(name: String, age: Int, heart: Bool, asthma: Bool, lung: Bool) {
        self.age = age
        self.heartDisease = heart
        self.asthma = asthma
        self.lungDisease = lung
        self.name = name
    }
    
    // SECTION: set thresholds algorithm
    private func setHourThresholds() {
        
    }
 
    private func setIndoorThresholds() {
        
    }
    
    // SECTION: get methods
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


// Manager class for UserDefault store and load
class userManager {
    static func saveUser(user: user) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "SavedUser")
        }
    }
    
    static func loadUser() -> user? {
        if let savedUserData = UserDefaults.standard.object(forKey: "SavedUser") as? Data {
            let decoder = JSONDecoder()
            if let loadedUser = try? decoder.decode(user.self, from: savedUserData) {
                return loadedUser
            }
        }
        
        return nil
    }
}
