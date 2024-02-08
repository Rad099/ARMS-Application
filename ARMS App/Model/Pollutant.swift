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
    func didUpdateHourIndex(_ index: Int, _ name: PollutantType)
    func didUpdateIndoorIndex(_ index: Int, _ name: PollutantType)
    func didUpdateUVIndoor(_ index: Double)
    func didUpdateUVHour(_ index: Double)
    func didUpdateConcentration(_ concentration: Int)
}

// pollutant class to populate pollutant values

class Pollutant: ObservableObject {
    weak var delegate: PollutantDelegate?
    var context: NSManagedObjectContext
    
    @Published var type: PollutantType
    
    // properties
    private var average: Array<Int> = []
    private var hourbreakpoints: [Breakpoints]?
    private var customBreakpoints: [Breakpoints]?
    
   @Published var currentHourIndex: Int = 0
   @Published var currentIndoorIndex: Int = 0 {
        didSet {
            saveHourIndex(for: self.currentHourIndex, context: context)
        }
    }
    
    
    @Published var concentration: Int = 0 {
        didSet {
            saveConcentration(for: self.concentration, context: context)
        }
    }

    

    init(type: PollutantType, context: NSManagedObjectContext) {
        self.type = type
        self.context = context
    }
   
    
    
    // method for storing breakpoints
    func addHourBp(hourbreakpoints: [Breakpoints]) {
        self.hourbreakpoints = hourbreakpoints
    }
    
    
    private func averageHourConcentration()  {
        var hourAvg = 0
        // check if size is 12
        if self.average.count == 12 {
            let sum = self.average.reduce(0, +)
            hourAvg = Int(sum/12)
            let currBreakpoint = findBreakpoints(forConcentration: hourAvg)
            let bpDiff = (currBreakpoint!.indexHigh - currBreakpoint!.indexLow)
            let indexDiff = (currBreakpoint!.bpHigh - currBreakpoint!.bpLow)
            let currIndex = indexDiff/bpDiff * (Double(hourAvg) - currBreakpoint!.bpLow) + currBreakpoint!.indexLow
            self.currentHourIndex = Int(currIndex)
            delegate?.didUpdateHourIndex(Int(self.currentHourIndex), self.type)
            self.average.removeAll()
        }
    }
    
    
    // method for finding the breakpoints given concentration. Used only within class
    private func findBreakpoints(forConcentration concentration: Int) -> Breakpoints? {
        var breakpoints: [Breakpoints]
        breakpoints = hourbreakpoints!
        
        if (breakpoints.isEmpty) {
            return nil
        }
        
        for breakpoint in breakpoints {
            if concentration > Int(breakpoint.bpLow) && concentration <= Int(breakpoint.bpHigh) {
                return breakpoint
            }
        }
        
        return nil
    }
    
    // method for setting currentIndex after calculation
    // uses AQI equation and breakpoint search
    func setIndex(forConcentration concentration: Int) {
        average.append(concentration)
        averageHourConcentration()
    }
    
    func setConcentration(for concentration: Int) {
        self.concentration = concentration
        //setIndex(forConcentration: concentration, forIndex: "hour")
        //delegate?.didUpdateConcentration(self.concentration)
    }
    
    // get methods
    func getHourIndex() -> Int {
        return self.currentHourIndex
    }
    func getIndoorIndex() -> Int {
        return self.currentIndoorIndex
    }
    
    func getConcentration() -> Int {
        return self.concentration
    }
   
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

// Core Data Section
extension Pollutant {
    // Assume this function replaces your existing setConcentration method
    func saveConcentration(for concentration: Int, context: NSManagedObjectContext) {
        let newRecord = ConcentrationRecord(context: context)
        newRecord.type = self.type.rawValue // Assuming PollutantType conforms to RawRepresentable
        newRecord.concentration = Int32(concentration)
        newRecord.timestamp = Date()
        do {
            try context.save()
        } catch {
            print("Failed to save pollutant record: \(error)")
        }
    }
    
    func saveHourIndex(for index: Int, context: NSManagedObjectContext) {
        let newRecord = HourIndexRecord(context: context)
        newRecord.type = self.type.rawValue
        newRecord.hourIndex = Int32(index)
        newRecord.timestamp = Date()
        
    }
    
    func fetchMostRecentConcentrationRecord(ofType type: PollutantType, context: NSManagedObjectContext) -> ConcentrationRecord? {
        let fetchRequest: NSFetchRequest<ConcentrationRecord> = ConcentrationRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type == %@", type.rawValue)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ConcentrationRecord.timestamp, ascending: false)]
        fetchRequest.fetchLimit = 1

        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching latest pollutant record: \(error)")
            return nil
        }
    }
    
    func fetchMostRecentHourIndexRecord(ofType type: PollutantType, context: NSManagedObjectContext) -> HourIndexRecord? {
        let fetchRequest: NSFetchRequest<HourIndexRecord> = HourIndexRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type == %@", type.rawValue)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \HourIndexRecord.timestamp, ascending: false)]
        fetchRequest.fetchLimit = 1
        
        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching latest pollutant record: \(error)")
            return nil
        }
    }
}



// Singleton Class Manager
class PollutantManager: ObservableObject {
    let context = PersistenceController.shared.container.viewContext
    static let shared = PollutantManager()
    
   @Published private var pollutants: [PollutantType: Pollutant]
    
    private init() {
        pollutants = [.pm1: Pollutant(type: .pm1, context: context), .pm2_5: Pollutant(type: .pm2_5, context: context), .pm10: Pollutant(type: .pm10, context: context),
                      .voc: Pollutant(type: .voc, context: context), .co: Pollutant(type: .co, context: context), .co2: Pollutant(type: .co2, context: context)]
        
    }
    
    func getPollutant(named name: PollutantType) -> Pollutant? {
            return pollutants[name]
    }
    
    func fetchAllPollutantData() {
            for (type, pollutant) in pollutants {
                // Assuming fetchMostRecentConcentrationRecord and fetchMostRecentHourIndexRecord are instance methods
                if let recentConcentrationRecord = pollutant.fetchMostRecentConcentrationRecord(ofType: type, context: context) {
                    // Handle the fetched concentration record
                    print("Most recent concentration for \(type.rawValue): \(recentConcentrationRecord.concentration)")
                }

                if let recentHourIndexRecord = pollutant.fetchMostRecentHourIndexRecord(ofType: type, context: context) {
                    // Handle the fetched hour index record
                    print("Most recent hour index for \(type.rawValue): \(recentHourIndexRecord.hourIndex)")
                }
            }
        }
    

}

// Globally Defined
var pm1 = PollutantManager.shared.getPollutant(named: .pm1)!
var pm2_5 = PollutantManager.shared.getPollutant(named: .pm2_5)!
var pm10 = PollutantManager.shared.getPollutant(named: .pm10)!
var voc =  PollutantManager.shared.getPollutant(named: .voc)!
var co =  PollutantManager.shared.getPollutant(named: .co)!
var co2 = PollutantManager.shared.getPollutant(named: .co2)!




