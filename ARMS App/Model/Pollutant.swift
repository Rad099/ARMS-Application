//
//  Breakpoints.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/6/24.
//
//

import Foundation
import CoreData

protocol PollutantDelegate: AnyObject {
    func didUpdateHourIndex(_ index: Int, _ name: PollutantType)
    func didUpdateIndoorIndex(_ index: Int, _ name: PollutantType)
    func didUpdateUVIndoor(_ index: Double)
    func didUpdateUVHour(_ index: Double)
    func didUpdateConcentration(_ concentration: Int)
}

// pollutant class to populate pollutant values

class Pollutant:  ObservableObject {
    weak var delegate: PollutantDelegate?
    var context: NSManagedObjectContext
    
    
    // properties
    private var average: Array<Int> = []
    var hourbreakpoints: [AQIBreakpoints]?
    var customBreakpoints: [Breakpoints]?
    var weight: Double = 0
   
 
    
   @Published var type: PollutantType
   @Published var currentHourIndex: Int = 0
   @Published var currentIndoorIndex: Int = 0
   @Published var concentration: Int = 0


    

    init(type: PollutantType, context: NSManagedObjectContext) {
        self.type = type
        self.context = context
    }
   
    
    
    // method for storing breakpoints
    func addHourBp(hourbreakpoints: [AQIBreakpoints]) {
        self.hourbreakpoints = hourbreakpoints
    }
    
    
    private func averageHourConcentration()  {
        // check if size is 12
        guard self.average.count == 12 else { return }
            let sum = self.average.reduce(0, +)
            let hourAvg = Int(sum/12)
        if self.type != .voc {
            let currBreakpoint = findAQIBreakpoints(forConcentration: hourAvg)
            let bpDiff = (currBreakpoint!.indexHigh - currBreakpoint!.indexLow)
            let indexDiff = (currBreakpoint!.bpHigh - currBreakpoint!.bpLow)
            let currIndex = indexDiff/bpDiff * (Double(hourAvg) - currBreakpoint!.bpLow) + currBreakpoint!.indexLow
            self.currentHourIndex = Int(currIndex)
        } else {
            self.currentHourIndex = hourAvg
        }
        delegate?.didUpdateHourIndex(Int(self.currentHourIndex), self.type)
        self.average.removeAll()
    }
    

    private func findBreakpoints(forConcentration concentration: Int) -> Breakpoints? {
            guard let breakpoints = customBreakpoints, !breakpoints.isEmpty else {
                return nil
            }
            
            
            return breakpoints.first { concentration >= Int($0.bpLow) && concentration <= Int($0.bpHigh) }
    }
    
    private func findAQIBreakpoints(forConcentration concentration: Int) -> AQIBreakpoints? {
            guard let breakpoints = hourbreakpoints, !breakpoints.isEmpty else {
                return nil
            }
            
            
            return breakpoints.first { concentration >= Int($0.bpLow) && concentration <= Int($0.bpHigh) }

    }
    
    func setWeight(withWeight weight: Double) {
        self.weight = weight
    }
    

    
    // method for setting currentIndex after calculation
    // uses AQI equation and breakpoint search
    private func setIndex(forConcentration concentration: Int) {
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
    
    
    // method for modifying custom breakpoints depending on the user
    func modifyBreakpoints(user: User) {
        
    }
    
    func getData() -> (Int, Double, Double, Double, Double) {
        let currBreakpoint = findBreakpoints(forConcentration: self.concentration)
        //let currScore = currBreakpoint?.score ?? -1
        return (self.concentration, currBreakpoint!.bpLow, currBreakpoint!.bpHigh, currBreakpoint!.lowScore, currBreakpoint!.score)
    }
    

   
}

// special case: uv
class UV: ObservableObject {
    var hourIndex: Double = 0
    var currentValue: Double = 0
    var context: NSManagedObjectContext

    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func setHourIndex(index: Double) {
        self.hourIndex = index
    }
    
    func setValue(index: Double) {
        self.currentValue = index
    }
    
    
    
    
}

// Core Data UV extension
extension UV {
    func saveUV(for value: Double, context: NSManagedObjectContext) {
        let newRecord = UVRecord(context: context)
        newRecord.value = self.currentValue
        newRecord.timestamp = Date()
        do {
            try context.save()
        } catch {
            print("Failed to save uv record: \(error)")
        }
    }
    
    func fetchMostRecentUVRecord(ofType type: PollutantType, context: NSManagedObjectContext) -> UVRecord? {
        let fetchRequest: NSFetchRequest<UVRecord> = UVRecord.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type == %@", type.rawValue)
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \UVRecord.timestamp, ascending: false)]
        fetchRequest.fetchLimit = 1

        do {
            return try context.fetch(fetchRequest).first
        } catch {
            print("Error fetching latest pollutant record: \(error)")
            return nil
        }
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
        do {
            try context.save()
        } catch {
            print("Failed to save pollutant record: \(error)")
        }
        
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
    @Published var concentrationMRD: Date? = nil
    var hourMRD: Date? = nil
    
    @Published private var pollutants: [PollutantType: Pollutant]
    
    private init() {
        pollutants = [.pm1: Pollutant(type: .pm1, context: context), .pm2_5: Pollutant(type: .pm2_5, context: context), .pm10: Pollutant(type: .pm10, context: context),
                      .voc: Pollutant(type: .voc, context: context), .co: Pollutant(type: .co, context: context), .co2: Pollutant(type: .co2, context: context)]
        
        pollutants[.pm1]!.customBreakpoints = defaultPM1Range
        pollutants[.pm2_5]!.customBreakpoints = defaultPM2_5Range
        pollutants[.pm10]!.customBreakpoints = defaultPM10Range
        pollutants[.voc]!.customBreakpoints = defaultVOCRange
        pollutants[.co]!.customBreakpoints = defaultCORange
        pollutants[.co2]!.customBreakpoints = defaultCO2Range
        
    }
    
    func getconcMRD() -> Date? {
        return self.concentrationMRD
    }
    
    func getArray() -> [Pollutant] {
        var array: Array<Pollutant> = []
        for pollutant in pollutants {
            array.append(pollutant.1)
        }
        
        return array
        
    }
    
    func getPollutant(named name: PollutantType) -> Pollutant? {
            return pollutants[name]
    }
    
    func saveAll() {
        for (_, pollutant) in pollutants {
            pollutant.saveConcentration(for: pollutant.concentration, context: context)
            concentrationMRD = Date()
        }
    }
    func fetchAllPollutantData() {
            for (type, pollutant) in pollutants {
                // Assuming fetchMostRecentConcentrationRecord and fetchMostRecentHourIndexRecord are instance methods
                if let recentConcentrationRecord = pollutant.fetchMostRecentConcentrationRecord(ofType: type, context: context) {
                    // Handle the fetched concentration record
                    //print("Most recent concentration for \(type.rawValue): \(recentConcentrationRecord.concentration)")
                    concentrationMRD = recentConcentrationRecord.timestamp ?? nil
                    pollutant.concentration = Int(recentConcentrationRecord.concentration)
                }

                if let recentHourIndexRecord = pollutant.fetchMostRecentHourIndexRecord(ofType: type, context: context) {
                    // Handle the fetched hour index record
                    hourMRD = recentHourIndexRecord.timestamp ?? nil
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


class UVManagaer: ObservableObject {
    let context = PersistenceController.shared.container.viewContext
    static let shared = UVManagaer()
    
    @Published private var uv: UV
    
    private init() {
        uv = UV(context: self.context)
    }
    
    func getUVValue() -> Double {
        return self.uv.currentValue
    }
    
    func getHourIndex() -> Double {
        return self.uv.hourIndex
    }
    
}




