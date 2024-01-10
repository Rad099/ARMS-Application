//
//  Breakpoints.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/6/24.
//
//

import Foundation


// store constant breakpoints
struct Breakpoints: Codable {
    var bpLow: Double
    var bpHigh: Double
    var indexHigh: Double
    var indexLow: Double
}

// pollutant class to populate pollutant values
class pollutant: Codable {
    var name: String
    private var hourbreakpoints: [Breakpoints]?
    private var indoorBreakpoints: [Breakpoints]? // TODO: confirm implementation (indoor AQI or concentration) UPDATE: indoorAQI likley
    
    var currentHourIndex = 0
    var currentIndoorIndex = 0
    
    init(name: String) {
        self.name = name
    }
    
    // method for storing breakpoints
    func addHourBp(hourbreakpoints: [Breakpoints]) {
        self.hourbreakpoints = hourbreakpoints
    }
    
    // method for storing breakpoints
    func addIndoorBp(indoorBreakpoints: [Breakpoints]) {
        self.indoorBreakpoints = indoorBreakpoints
    }
    
    
    // method for finding the breakpoints given concentration. Used only within class
    private func findBreakpoints(forConcentration concentration: Double, forAQIType AQIType: String) -> Breakpoints? {
        var breakpoints: [Breakpoints]
        if AQIType == "hour" {
            breakpoints = hourbreakpoints!
        } else if (AQIType == "indoor") {
            breakpoints = indoorBreakpoints!
        } else {
            return nil
        }
        
        if (breakpoints.isEmpty) {
            return nil
        }
        
        for breakpoint in breakpoints {
            if concentration > breakpoint.bpLow && concentration <= breakpoint.bpHigh {
                return breakpoint
            }
        }
        
        return nil
    }
    
    // method for setting currentIndex after calculation
    // uses AQI equation and breakpoint search
    func setIndex(forConcentration concentration: Double, forIndex index: String) {
        let currBreakpoint = findBreakpoints(forConcentration: concentration, forAQIType: index)
        let bpDiff = (currBreakpoint!.indexHigh - currBreakpoint!.indexLow)
        let indexDiff = (currBreakpoint!.bpHigh - currBreakpoint!.bpLow)
        let currIndex = indexDiff/bpDiff * (concentration - currBreakpoint!.bpLow) + currBreakpoint!.indexLow
        
        if index == "hour" {
            self.currentHourIndex = Int(ceil(currIndex))
        } else if (index == "indoor") {
            self.currentIndoorIndex = Int(ceil(currIndex))
        }
    }
    
    // get methods
    func getHourIndex() -> Int {
        return self.currentHourIndex
    }
    
    func getIndoorIndex() -> Int {
        return self.currentIndoorIndex
    }
}


// special case: uv
class UV: pollutant {
    
}

