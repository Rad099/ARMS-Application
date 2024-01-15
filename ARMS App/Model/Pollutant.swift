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

protocol PollutantDelegate: AnyObject {
    func didUpdateHourIndex(_ index: Int, _ name: String)
    func didUpdateIndoorIndex(_ index: Int, _ name: String)
}

// pollutant class to populate pollutant values
class pollutant: Codable {
    weak var delegate: PollutantDelegate?
    var name: String
    private var hourbreakpoints: [Breakpoints]?
    private var indoorBreakpoints: [Breakpoints]? // TODO: confirm implementation (indoor AQI or concentration) UPDATE: indoorAQI likley
    var currentHourIndex: UInt16 = 0
    var currentIndoorIndex: UInt16 = 0
    
    
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
            self.currentHourIndex = UInt16(ceil(currIndex))
            delegate?.didUpdateHourIndex(Int(self.currentHourIndex), self.name)
        } else if (index == "indoor") {
            self.currentIndoorIndex = UInt16(ceil(currIndex))
            delegate?.didUpdateIndoorIndex(Int(self.currentIndoorIndex), self.name)
        }
    }
    
    // get methods
    func getHourIndex() -> UInt16 {
        return self.currentHourIndex
    }
    func getIndoorIndex() -> UInt16 {
        return self.currentIndoorIndex
    }
    
    // MARK: - Codable
       enum CodingKeys: String, CodingKey {
           case name
           case hourbreakpoints
           case indoorBreakpoints
           case currentHourIndex
           case currentIndoorIndex
       }

       // Implement custom init(from:) and encode(to:) if needed
       required init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           name = try container.decode(String.self, forKey: .name)
           hourbreakpoints = try container.decodeIfPresent([Breakpoints].self, forKey: .hourbreakpoints)
           indoorBreakpoints = try container.decodeIfPresent([Breakpoints].self, forKey: .indoorBreakpoints)
           currentHourIndex = try container.decode(UInt16.self, forKey: .currentHourIndex)
           currentIndoorIndex = try container.decode(UInt16.self, forKey: .currentIndoorIndex)
       }

       func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: CodingKeys.self)
           try container.encode(name, forKey: .name)
           try container.encodeIfPresent(hourbreakpoints, forKey: .hourbreakpoints)
           try container.encodeIfPresent(indoorBreakpoints, forKey: .indoorBreakpoints)
           try container.encode(currentHourIndex, forKey: .currentHourIndex)
           try container.encode(currentIndoorIndex, forKey: .currentIndoorIndex)
       }
}




// special case: uv
class UV: pollutant {
    
}

