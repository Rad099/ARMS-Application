//
//  Breakpoints.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/6/24.
//
//

import Foundation
import CoreData


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
    func didUpdateUVIndoor(_ index: Double)
    func didUpdateUVHour(_ index: Double)
}

// pollutant class to populate pollutant values
class Pollutant {
    weak var delegate: PollutantDelegate?
    var name: String
    private var hourbreakpoints: [Breakpoints]?
    private var indoorBreakpoints: [Breakpoints]? // TODO: confirm implementation (indoor AQI or concentration) UPDATE: indoorAQI likley
    var currentHourIndex: Int = 0
    var currentIndoorIndex: Int = 0
    
    //let context: NSManagedObjectContext
    init(name: String) {
        self.name = name
    }
    /*
    init(name: String, context: NSManagedObjectContext) {
        self.name = name
        self.context = context
    }
     
     */
    
    
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
            //saveIndexRecord(type: self.name, index: self.currentHourIndex, interval: "hour")
            delegate?.didUpdateHourIndex(Int(self.currentHourIndex), self.name)
        } else if (index == "indoor") {
            self.currentIndoorIndex = Int(ceil(currIndex))
            //saveIndexRecord(type: self.name, index: self.currentIndoorIndex, interval: "indoor")
            delegate?.didUpdateIndoorIndex(Int(self.currentIndoorIndex), self.name)
        }
    }
    
    // get methods
    func getHourIndex() -> Int {
        return self.currentHourIndex
    }
    func getIndoorIndex() -> Int {
        return self.currentIndoorIndex
    }
   
/*
    // Save a new index record
    func saveIndexRecord(type: String, index: UInt16, interval: String) {
            let newRecord = IndexRecord(context: self.context)
            newRecord.indexValue = Int32(index)
            newRecord.timestamp = Date()
            newRecord.type = type
            newRecord.interval = interval

            do {
                try self.context.save()
            } catch {
                print("Failed to save index record: \(error)")
            }
        }

        // Retrieve index history
        func fetchIndexHistory(type: String) -> [IndexRecord] {
            let fetchRequest: NSFetchRequest<IndexRecord> = IndexRecord.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "type == %@", type)

            do {
                return try self.context.fetch(fetchRequest)
            } catch {
                print("Failed to fetch index records: \(error)")
                return []
            }
        }
    


    */
}




 

// special case: uv
class UV: Pollutant {
    var hourIndex: Double = 0
    var indoorIndex: Double = 0
    func setHourIndex(index: Double) {
        self.hourIndex = index
        delegate?.didUpdateUVHour(self.hourIndex)
    }
    
    func setIndoorIndex(index: Double) {
        self.indoorIndex = index
        delegate?.didUpdateUVIndoor(self.indoorIndex)
    }
    
}

class PollutantManager {
    static let shared = PollutantManager()
    
    private var pollutants: [String: Pollutant]
    
    private init() {
        pollutants = ["pm1": Pollutant(name: "pm1"), "pm2_5": Pollutant(name: "pm2_5"), "pm10": Pollutant(name: "pm10"),
                      "voc": Pollutant(name: "voc"), "co": Pollutant(name: "co"), "uv": UV(name: "uv")]
        
    }
    
    func getPollutant(named name: String) -> Pollutant? {
            return pollutants[name]
        }
    

}



