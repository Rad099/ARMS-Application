//
//  BreakpointDataCollection.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 2/9/24.
//

import Foundation

// store constant breakpoints
struct Breakpoints: Codable {
    var bpLow: Double
    var bpHigh: Double
    var lowScore: Double
    var score: Double
}

struct AQIBreakpoints: Codable {
    var bpLow: Double
    var bpHigh: Double
    var indexHigh: Double
    var indexLow: Double
}

// defaults for the PAQR Implementation
// TODO: fix the numbers of the score for the 'good' range to be less heavy
//let defaultPM1Range = [Breakpoints(bpLow: 0, bpHigh: 10, lowScore: 0.0, score: 0.20), Breakpoints(bpLow: 11, bpHigh: 31, lowScore: 0.21, score: 0.40), Breakpoints(bpLow: 32, bpHigh: 59, lowScore: 0.41, score: 0.60), Breakpoints(bpLow: 60, bpHigh: 94, lowScore: 0.61, score: 0.80), Breakpoints(bpLow: 95, bpHigh: 500, lowScore: 81.0, score: 1.0)]

let defaultPM1Range = [
    Breakpoints(bpLow: 0, bpHigh: 10, lowScore: 0.0, score: 0.10), // Good
    Breakpoints(bpLow: 11, bpHigh: 31, lowScore: 0.11, score: 0.20), // Mild, adjusted for clarity
    Breakpoints(bpLow: 32, bpHigh: 59, lowScore: 0.21, score: 0.40), // Average
    Breakpoints(bpLow: 60, bpHigh: 94, lowScore: 0.41, score: 0.60), // Unhealthy
    Breakpoints(bpLow: 95, bpHigh: 500, lowScore: 0.61, score: 1.0) // Hazardous, allowing for a full range up to 1.0
]

// TODO: review above score range for the following ranges
let defaultPM2_5Range = [Breakpoints(bpLow: 0, bpHigh: 20, lowScore: 0.0, score: 0.20), Breakpoints(bpLow: 21, bpHigh: 50, lowScore: 0.21, score: 0.40), Breakpoints(bpLow: 51, bpHigh: 90, lowScore: 0.41, score: 0.60), Breakpoints(bpLow: 91, bpHigh: 140, lowScore: 0.61, score: 0.80), Breakpoints(bpLow: 141, bpHigh: 500, lowScore: 0.81, score: 1.0)]

let defaultPM10Range = [Breakpoints(bpLow: 0, bpHigh: 25, lowScore: 0.0, score: 0.20), Breakpoints(bpLow: 26, bpHigh: 75, lowScore: 0.21, score: 0.40), Breakpoints(bpLow: 76, bpHigh: 125, lowScore: 0.41, score: 0.60), Breakpoints(bpLow: 126, bpHigh: 200, lowScore: 0.61, score: 0.80), Breakpoints(bpLow: 201, bpHigh: 500, lowScore: 0.81, score: 1.0)]

let defaultVOCRange = [Breakpoints(bpLow: 0, bpHigh: 50, lowScore: 0.0, score: 0.20), Breakpoints(bpLow: 51, bpHigh: 100, lowScore: 0.21, score: 0.40), Breakpoints(bpLow: 101, bpHigh: 150, lowScore: 0.41, score: 0.60), Breakpoints(bpLow: 151, bpHigh: 200, lowScore: 0.61, score: 0.80), Breakpoints(bpLow: 201, bpHigh: 500, lowScore: 0.81, score: 1.0)]

let defaultCORange = [Breakpoints(bpLow: 0, bpHigh: 30, lowScore: 0.0, score: 0.20), Breakpoints(bpLow: 31, bpHigh: 70, lowScore: 0.21, score: 0.40), Breakpoints(bpLow: 71, bpHigh: 150, lowScore: 0.41,  score: 0.60), Breakpoints(bpLow: 151, bpHigh: 300, lowScore: 0.61, score: 0.80), Breakpoints(bpLow: 301, bpHigh: 1000, lowScore: 0.81, score: 1.0)]

let defaultCO2Range = [Breakpoints(bpLow: 0, bpHigh: 500, lowScore: 0.0, score: 0.20), Breakpoints(bpLow: 501, bpHigh: 750, lowScore: 0.21, score: 0.40), Breakpoints(bpLow: 751, bpHigh: 1000, lowScore: 0.41, score: 0.60), Breakpoints(bpLow: 1001, bpHigh: 3000, lowScore: 0.61, score: 0.80), Breakpoints(bpLow: 3001, bpHigh: 5000, lowScore: 0.81, score: 1.0)]

// used in SwiftUI for color changes
let pollutantRanges: [PollutantType: [Breakpoints]] = [.pm1: defaultPM1Range, .pm2_5: defaultPM2_5Range, .pm10: defaultPM10Range, .voc: defaultVOCRange, .co2: defaultCO2Range, .co: defaultCORange]


/*
// defaults for 1-hour AQI
let defaultPM1Range = [Breakpoints(bpLow: 0, bpHigh: 10, lowScore: 0.0, score: 0.20), Breakpoints(bpLow: 11, bpHigh: 31, lowScore: 0.21, score: 0.40), Breakpoints(bpLow: 32, bpHigh: 59, lowScore: 0.41, score: 0.60), Breakpoints(bpLow: 60, bpHigh: 94, lowScore: 0.61, score: 0.80), Breakpoints(bpLow: 95, bpHigh: 500, lowScore: 81.0, score: 1.0)]

let defaultPM2_5Range = [Breakpoints(bpLow: 0, bpHigh: 25, lowScore: 0.0, score: 0.20), Breakpoints(bpLow: 26, bpHigh: 50, lowScore: 0.21, score: 0.40), Breakpoints(bpLow: 51, bpHigh: 100, lowScore: 0.41, score: 0.60), Breakpoints(bpLow: 101, bpHigh: 300, lowScore: 0.61, score: 0.80), Breakpoints(bpLow: 301, bpHigh: 500, lowScore: 0.81, score: 1.0)]

let defaultPM10Range = [Breakpoints(bpLow: 0, bpHigh: 40, lowScore: 0.0, score: 0.20), Breakpoints(bpLow: 41, bpHigh: 80, lowScore: 0.21, score: 0.40), Breakpoints(bpLow: 81, bpHigh: 120, lowScore: 0.41, score: 0.60), Breakpoints(bpLow: 121, bpHigh: 300, lowScore: 0.61, score: 0.80), Breakpoints(bpLow: 301, bpHigh: 500, lowScore: 0.81, score: 1.0)]

let defaultVOCRange = [Breakpoints(bpLow: 0, bpHigh: 50, lowScore: 0.0, score: 0.20), Breakpoints(bpLow: 51, bpHigh: 100, lowScore: 0.21, score: 0.40), Breakpoints(bpLow: 101, bpHigh: 150, lowScore: 0.41, score: 0.60), Breakpoints(bpLow: 151, bpHigh: 200, lowScore: 0.61, score: 0.80), Breakpoints(bpLow: 201, bpHigh: 500, lowScore: 0.81, score: 1.0)]

let defaultCORange = [Breakpoints(bpLow: 0, bpHigh: 30, lowScore: 0.0, score: 0.20), Breakpoints(bpLow: 31, bpHigh: 70, lowScore: 0.21, score: 0.40), Breakpoints(bpLow: 71, bpHigh: 150, lowScore: 0.41,  score: 0.60), Breakpoints(bpLow: 151, bpHigh: 300, lowScore: 0.61, score: 0.80), Breakpoints(bpLow: 301, bpHigh: 1000, lowScore: 0.81, score: 1.0)]

let defaultCO2Range = [Breakpoints(bpLow: 0, bpHigh: 500, lowScore: 0.0, score: 0.20), Breakpoints(bpLow: 501, bpHigh: 750, lowScore: 0.21, score: 0.40), Breakpoints(bpLow: 751, bpHigh: 1000, lowScore: 0.41, score: 0.60), Breakpoints(bpLow: 1001, bpHigh: 3000, lowScore: 0.61, score: 0.80), Breakpoints(bpLow: 3001, bpHigh: 5000, lowScore: 0.81, score: 1.0)]
*/
