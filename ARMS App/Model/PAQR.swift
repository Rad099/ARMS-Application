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


class PAQR: ObservableObject {
    //static let shared = PAQR(pollutants: PollutantManager.shared.getArray())
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
    

    
    func setValue() {
        print("we got here")
        var mod = 100.0
        defaultWeights()
        for pollutant in pollutants {
            let (con, min, max, minscore, maxscore) = pollutant.getData()
            var score = calculateScore(value: con, minValue: Int(min), maxValue: Int(max), minScore: minscore, maxScore: maxscore)
            if score == -1 {
                score *= -1
                print("Score was negative, find out why")
            }
            mod -= (score*pollutant.weight)
            print("we are getting: \(score*pollutant.weight)")
            print("score: \(score) with weight: \(pollutant.weight) for type \(pollutant.type)")
            //if mod < 100 {
              //  scheduleNotification(whenValueis: 100)
          //  }
            
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


 



