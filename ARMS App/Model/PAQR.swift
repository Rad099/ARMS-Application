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
    var pm1: Int = 10
    var pm25: Int = 10
    var pm10: Int = 10
    var voc: Int = 30
    var co: Int = 20
    var co2: Int = 20
    
    // Function to apply adjustments
    mutating func applyAdjustments(_ adjustments: [String: Int]) {
        pm1 += adjustments["pm1", default: 0]
        pm25 += adjustments["pm2.5", default: 0]
        pm10 += adjustments["pm10", default: 0]
        voc += adjustments["voc", default: 0]
        co += adjustments["co", default: 0]
        co2 += adjustments["co2", default: 0]
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
        self.pollutants[3].setWeight(withWeight: 20.0)
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
        print("we got here")
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
        self.value = mod
    }
    func updateValueAndCheckForNotification() {
            //self.value = setValue() // Or wherever you calculate the new value

            // Assuming you want to show the notification when value goes over a certain limit
            if self.value > 100 { // Threshold value
                self.notificationMessage = "Value is below 100!"
                self.showCustomNotification = true
                
                // Optionally, hide the notification after some time
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) { // Hide after 5 seconds
                    self.showCustomNotification = false
                }
            }
        }
    
    func calculateScore(value: Int, minValue: Int, maxValue: Int, minScore: Double, maxScore: Double) -> Double {
        // Ensure the value is within the range
        let clampedValue = min(max(value, minValue), maxValue)
        
        // Calculate the proportion of the value within the range
        let proportion = Double(clampedValue - minValue) / Double(maxValue - minValue)
        
        // Use the proportion to find the corresponding score within the score range
        let score = minScore + (maxScore - minScore) * proportion
        print("mini score: \(score)")
        
        return score
    }
 }

var paqr = PAQR(pollutants: PollutantManager.shared.getArray())


 



