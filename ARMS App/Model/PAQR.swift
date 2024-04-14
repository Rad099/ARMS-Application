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


var paqrReady = false

struct PollutantWeights {
    var weights: [PollutantType: Int]
    var sensitive: Set<PollutantType> = []
    var pollutants = PollutantManager.shared.getArray()

    init() {
        weights = [.pm1: 10, .pm2_5: 10, .pm10: 10, .voc: 30, .co: 20, .co2: 20]
    }

    mutating func applyAdjustments(for conditions: [String], with adjustments: [String: [String: Int]]) {
        for condition in conditions {
            guard let conditionAdjustments = adjustments[condition] else { continue }
            
            for (key, adjustment) in conditionAdjustments {
                if let pollutant = PollutantType(rawValue: key) {
                    weights[pollutant, default: 0] += adjustment
                    sensitive.insert(pollutant)  // Mark as sensitive (prioritized)
                    
                    
                }
            }
        }
        
        for pollutant in pollutants {
            pollutant.isSensitive = sensitive.contains(pollutant.type)
        }
        
       
        redistributeWeights()
    }

    private mutating func redistributeWeights() {
        let totalCurrentWeight = weights.values.reduce(0, +)
        var adjustmentNeeded = totalCurrentWeight - 100

        if adjustmentNeeded == 0 { return }

        var attempts = 0
        while adjustmentNeeded != 0 && attempts < 100 {  // Safeguard with attempts to avoid infinite loops
            var totalDecrementThisRound = 0

            for (pollutant, weight) in weights {
                if !sensitive.contains(pollutant) {
                    let decrement = min(weight - 1, adjustmentNeeded)  // Ensure we do not take more than needed or make weights negative
                    weights[pollutant] = weight - decrement
                    totalDecrementThisRound += decrement
                    adjustmentNeeded -= decrement
                    if adjustmentNeeded == 0 {
                        break
                    }
                }
            }

            attempts += 1  // Increment attempts to ensure we do not loop infinitely
        }

        // Final pass to clean up any residual due to rounding issues
        if adjustmentNeeded != 0 {
            finalizeWeights(adjustmentNeeded)
        }
    }

    private mutating func finalizeWeights(_ initialAdjustmentNeeded: Int) {
        var adjustmentNeeded = initialAdjustmentNeeded  // Make it a mutable variable
        for (pollutant, weight) in weights.sorted(by: { $0.value > $1.value }) {
            if !sensitive.contains(pollutant) {
                let adjustment = min(abs(adjustmentNeeded), weight - 1) * (adjustmentNeeded > 0 ? -1 : 1)
                weights[pollutant]! += adjustment
                adjustmentNeeded += adjustment
                if adjustmentNeeded == 0 { break }
            }
        }
    }
    
    func updatePollutants(_ pollutants: [Pollutant]) {
        for pollutant in pollutants {
            pollutant.setWeight(withWeight: Double(weights[pollutant.type, default: 0]))
        }
    }

}

     
// Health condition adjustments
let adjustments: [String: [String: Int]] = [
    "heart disease": ["CO": 20, "PM2.5": 10, "PM1": 10],
    "asthma": ["PM2.5": 15, "PM10": 15],
    "respiratory disease": ["PM10": 10, "PM2.5": 10, "PM1": 10 , "VOC": 10],
    "young": ["PM2.5": 15, "PM1": 15, "VOC": 5],
    "elderly": ["CO": 10, "CO2": 10]
]








class PAQR: ObservableObject {
    @Published var value: Double = 0
    @Published var showCustomNotification: Bool = false
    @Published var notificationMessage: String = ""
    var pollutants: [Pollutant]
    //var user: User
    


    init(pollutants: [Pollutant]) {
        self.pollutants = pollutants
        //defaultWeights()
        self.setValue() // Initialize value
    }
    
    
    
    func applyWeights() {
        var weights = PollutantWeights()
        weights.applyAdjustments(for: User.shared.userConditions, with: adjustments)
        print("Conditions: \(User.shared.userConditions)")
        weights.updatePollutants(pollutants)
        print(weights)
        self.setValue()
    }
    
    func defaultWeights() {
        self.pollutants[0].setWeight(withWeight: 10.0)
        self.pollutants[1].setWeight(withWeight: 10.0)
        self.pollutants[2].setWeight(withWeight: 10.0)
        self.pollutants[3].setWeight(withWeight: 30.0)
        self.pollutants[4].setWeight(withWeight: 20.0)
        self.pollutants[5].setWeight(withWeight: 20.0)
    }
    
    

    
    func setValue() {
        var mod = 100.0
       // self.applyWeights()
        for pollutant in pollutants {
            let (con, min, max, minscore, maxscore) = pollutant.getData()
            var score = calculateScore(value: con, minValue: Int(min), maxValue: Int(max), minScore: minscore, maxScore: maxscore)
            if score == -1 {
                score *= -1
            }
    
            mod -= (score*pollutant.weight)
            print("score: \(score) with weight: \(pollutant.weight) for type \(pollutant.type)")
        }
        print("mod recieved: \(mod)")
        
        DispatchQueue.main.async { [weak self] in
            self?.value = mod
            
        }
    
    }
    
    
   // func setNotify(_ value: Double) {
        
   // }
    func calculateScore(value: Int, minValue: Int, maxValue: Int, minScore: Double, maxScore: Double) -> Double {

        let clampedValue = min(max(value, minValue), maxValue)
        
        
        let proportion = Double(clampedValue - minValue) / Double(maxValue - minValue)
        
        let score = minScore + (maxScore - minScore) * proportion
        
        return score
    }
    /*
    func saveValue(for value: Int?, context: NSManagedObjectContext) {
        guard let v = value, v >= 0 else {
            print("Invalid or nil PAQR value. Skipping save operation.")
            return
        }
        
        let newRecord = PaqrRecord(context: context)
        newRecord.value = Int32(v)
        newRecord.timestamp = Date()
        
        saveContext(context)
        
    }
    
     */
    private func saveContext(_ context: NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
                print("paqr record saved successfully.")
            } catch let saveError as NSError {
                print("Failed to save paqr: \(saveError), \(saveError.userInfo)")
            }
        }
    }
 }

var paqr = PAQR(pollutants: PollutantManager.shared.getArray())



 



