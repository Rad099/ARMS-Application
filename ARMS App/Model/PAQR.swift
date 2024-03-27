//
//  PAQR.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 2/9/24.
//  File for paqr equation

import Foundation
import Combine
import CoreData

var progressData = ProgressData()
var user: User?

struct PollutantWeights {
    var pm1Weight: Int = 10
    var pm25Weight: Int = 10
    var pm10Weight: Int = 10
    var vocWeight: Int = 30
    var coWeight: Int = 20
    var co2Weight: Int = 20
    
    // Function to apply adjustments
    mutating func applyAdjustments(_ adjustments: [String: Int]) {
        pm1Weight += adjustments["pm1", default: 0]
        pm25Weight += adjustments["pm2.5", default: 0]
        pm10Weight += adjustments["pm10", default: 0]
        vocWeight += adjustments["voc", default: 0]
        coWeight += adjustments["co", default: 0]
        co2Weight += adjustments["co2", default: 0]
    }
}

// Health condition adjustments
let adjustments: [String: [String: Int]] = [
    "heart disease": ["co": 20],
    "asthma": ["pm2.5": 15, "pm10": 15],
    "respiratory disease": ["pm10": 20, "voc": 10],
    "children": ["pm2.5": 10, "voc": 5],
    "elderly": ["co": 10, "co2": 10]
]


class PAQR: ObservableObject {
    @Published var value: Double = 0
    @Published var showCustomNotification: Bool = false
    @Published var notificationMessage: String = ""
    var pollutants: [Pollutant]
    //var user: User
    


    init(pollutants: [Pollutant]) {
        self.pollutants = pollutants
        //self.user = user

        self.setValue() // Initialize value
    }
    
    func defaultWeights() {
        self.pollutants[0].setWeight(withWeight: 10.0)
        self.pollutants[1].setWeight(withWeight: 10.0)
        self.pollutants[2].setWeight(withWeight: 10.0)
        self.pollutants[3].setWeight(withWeight: 30.0)
        self.pollutants[4].setWeight(withWeight: 20.0)
        self.pollutants[5].setWeight(withWeight: 20.0)
    }
    
    func calculateWeights(forConditions conditions: [String]) -> PollutantWeights {
        var finalWeights = PollutantWeights()
        for condition in conditions {
            if let conditionAdjustments = adjustments[condition] {
                finalWeights.applyAdjustments(conditionAdjustments)
            }
        }
        return finalWeights
    }

    
    func setValue() {
        var mod = 100.0
        defaultWeights()
        for pollutant in pollutants {
            let (con, min, max, minscore, maxscore) = pollutant.getData()
            var score = calculateScore(value: con, minValue: Int(min), maxValue: Int(max), minScore: minscore, maxScore: maxscore)
            if score == -1 {
                score *= -1
            }
    
            mod -= (score*pollutant.weight)
           // print("we are getting: \(score*pollutant.weight)")
            //print("score: \(score) with weight: \(pollutant.weight) for type \(pollutant.type)")
        }
        print("mod recieved: \(mod)")
        
        // TODO: add the paqr notification here
        
        DispatchQueue.main.async { [weak self] in
            self?.value = mod
        }
    
    }
    
    func calculateScore(value: Int, minValue: Int, maxValue: Int, minScore: Double, maxScore: Double) -> Double {

        let clampedValue = min(max(value, minValue), maxValue)
        
        
        let proportion = Double(clampedValue - minValue) / Double(maxValue - minValue)
        
        let score = minScore + (maxScore - minScore) * proportion
        
        return score
    }
    
    func saveValue(for value: Int, context: NSManagedObjectContext) {
        
        let newRecord = PaqrRecord(context: context)
        newRecord.value = Int32(value)
        newRecord.timestamp = Date()
        
        do {
            try context.save()
        } catch {
            print("Failed to store paqr value: \(error)")
            
        }
        
    }
 }

var paqr = PAQR(pollutants: PollutantManager.shared.getArray())


 



