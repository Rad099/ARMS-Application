//
//  Breakpoints.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/6/24.
//
//

import Foundation
import CoreData


// pollutant class to populate pollutant values
protocol updateHomeNotify: AnyObject {
    func didUpdateNotify(typez: PollutantType, message: String)
}

class Pollutant:  ObservableObject {
   
    var context: NSManagedObjectContext

    
    
    // properties
    private var average: Array<Int> = []
    var hourbreakpoints: [AQIBreakpoints]?
    var customBreakpoints: [Breakpoints]?
    var weight: Double = 0
    var lastNotifyTime: Date? = nil
   
 
    
   @Published var type: PollutantType
   @Published var currentHourIndex: Int = 0
   @Published var currentIndoorIndex: Int = 0
   @Published var concentration: Int = 0
   var isHigh = false
   var isSensitive = false


    

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
        DispatchQueue.main.async {
            self.concentration = concentration
            //setIndex(forConcentration: concentration, forIndex: "hour")
            //delegate?.didUpdateConcentration(self.concentration)
        }

        
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
        let defaultBreakpoint = Breakpoints(bpLow: 0, bpHigh: 0, lowScore: 0.0, score: 0.0) // Provide suitable default values
        var currBreakpoint = findBreakpoints(forConcentration: self.concentration) ?? defaultBreakpoint
        if (currBreakpoint.bpLow.isNaN || currBreakpoint.bpLow.isInfinite) {
            currBreakpoint = defaultBreakpoint
        }
        return (self.concentration, currBreakpoint.bpLow, currBreakpoint.bpHigh, currBreakpoint.lowScore, currBreakpoint.score)
    }

    

   
}

// special case: uv
class UV: ObservableObject {
    @Published var hourIndex: Double = 0
    @Published var currentValue: Double = 0
    var type = PollutantType.uv
    var context: NSManagedObjectContext

    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func setHourIndex(index: Double) {
        DispatchQueue.main.async {
            self.hourIndex = index
        }
        
    }
    
    func setValue(index: Double) {
        DispatchQueue.main.async {
            self.currentValue = index
        }
    }
    
    
    
    
}

// Core Data UV extension
extension UV {
    func saveUV(for value: Double, context: NSManagedObjectContext) {
        guard value >= 0 else {
            print("Invalid uv value. Skipping save operation.")
            return
        }
        let newRecord = UVRecord(context: context)
        newRecord.value = self.currentValue
        newRecord.timestamp = Date()
        newRecord.type = self.type.rawValue
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
    
    func saveConcentration(for concentration: Int?, context: NSManagedObjectContext) {
        guard let concentration = concentration, concentration >= 0 else {
            print("Invalid or nil concentration value. Skipping save operation.")
            return
        }

        let newRecord = ConcentrationRecord(context: context)
        newRecord.type = self.type.rawValue
        newRecord.concentration = Int32(concentration)
        newRecord.timestamp = Date()

        // Avoid nesting performAndWait blocks
        saveContext(context)
    }

    private func saveContext(_ context: NSManagedObjectContext) {
        context.perform {
            do {
                try context.save()
                print("Concentration record saved successfully.")
            } catch let saveError as NSError {
                print("Failed to save pollutant record: \(saveError), \(saveError.userInfo)")
            }
        }
    }


    func saveHourIndex(for index: Int, context: NSManagedObjectContext) {
        // Validate the index value before proceeding.
        guard index >= 0 else {
            print("Invalid hour index value. Skipping save operation.")
            return
        }

        let newRecord = HourIndexRecord(context: context)
        newRecord.type = self.type.rawValue
        newRecord.hourIndex = Int32(index)
        newRecord.timestamp = Date()
        do {
            try context.save()
        } catch {
            print("Failed to save pollutant record: \(error)")
            self.handleError(error, context: context)
        }
    }
    
    private func handleError(_ error: Error, context: NSManagedObjectContext) {
            print("Handling error: \(error)")
            if let nsError = error as NSError? {
                // Analyze error codes and decide on next steps
                switch nsError.code {
                case NSManagedObjectValidationError, NSValidationMultipleErrorsError, NSValidationMissingMandatoryPropertyError:
                    print("Validation error: \(error)")
                case Int(NSCocoaErrorDomain) where nsError.code == NSManagedObjectConstraintValidationError:
                    print("Constraint violation: \(error)")
                default:
                    print("Unresolved error \(nsError), \(nsError.userInfo)")
                    if context.hasChanges {
                        context.rollback()  // Roll back changes in the context
                        print("Changes rolled back due to error.")
                    }
                }
            }
        }

    
    func fetchMostRecentConcentrationRecord(ofType type: PollutantType, context: NSManagedObjectContext) -> ConcentrationRecord? {
        let fetchRequest: NSFetchRequest<ConcentrationRecord> = ConcentrationRecord.fetchRequest()
        // Combine predicates to both match the pollutant type and exclude the invalid concentration value
        let typePredicate = NSPredicate(format: "type == %@", type.rawValue)
        let validConcentrationPredicate = NSPredicate(format: "concentration != %d", 65535)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [typePredicate, validConcentrationPredicate])
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
    weak var delegate: updateHomeNotify?
    static let shared = PollutantManager()
    @Published var concentrationMRD: Date? = nil
    var hourMRD: Date? = nil
    var lastNotifyTime: Date? = nil
    
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
    
    func monitorPollutants() {
        
        /*
         NotificationCenter.default.post(name: .highPollutant, object: nil, userInfo: ["highPollutant": selectedType!])
         */
    }
    
    func checkHighest() {
        var highPollutant: Pollutant?
        var highestValue = 0
      
        for (type, pollutant) in self.pollutants {
            let max = pollutant.concentration
            if max > highestValue {
                highestValue = max
                highPollutant = pollutant
            }
        }
        
    
    
        guard let highPollutant = highPollutant else { return }
        let (con, min, max, minscore, maxscore) = highPollutant.getData()

        if canScheduleNotificationFor(pollutant: highPollutant) && maxscore >= 0.6 {
            scheduleNotification(maxscore, highPollutant.type)
            highPollutant.lastNotifyTime = Date()
        }
    }
    
    // Function to check if enough time has passed since the last notification for this pollutant
        private func canScheduleNotificationFor(pollutant: Pollutant) -> Bool {
            guard let lastNotificationTime = pollutant.lastNotifyTime else { return true }
            let currentTime = Date()
            let timePassed = Calendar.current.dateComponents([.minute], from: lastNotificationTime, to: currentTime).minute ?? 0
     
            return timePassed >= 1 // minute
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
                    if (recentConcentrationRecord.concentration == 65535 ) {
                        pollutant.concentration = 0
                    }
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

extension Notification.Name {
    static let isHigh = Notification.Name("isHigh")
    static let highPollutant = Notification.Name("highPollutant")
    

}


class UVManager: ObservableObject {
    let context = PersistenceController.shared.container.viewContext
    static let shared = UVManager()
    
    @Published private var uv: UV
    
    private init() {
        uv = UV(context: self.context)
    }
    
    func uvObj() -> UV {
        return self.uv
    }
    
    func fetchUVData() {
        if let recentUVRecord = uv.fetchMostRecentUVRecord(ofType: .uv, context: context) {
            self.uv.currentValue = recentUVRecord.value
        }
    }
    
    func getUVValue() -> Double {
        return self.uv.currentValue
    }
    
    func getHourIndex() -> Double {
        return self.uv.hourIndex
    }
    
    func saveIndex() {
        self.uv.saveUV(for: uv.currentValue, context: self.context)
    }
    
}


// Globally Defined
var pm1 = PollutantManager.shared.getPollutant(named: .pm1)!
var pm2_5 = PollutantManager.shared.getPollutant(named: .pm2_5)!
var pm10 = PollutantManager.shared.getPollutant(named: .pm10)!
var voc =  PollutantManager.shared.getPollutant(named: .voc)!
var co =  PollutantManager.shared.getPollutant(named: .co)!
var co2 = PollutantManager.shared.getPollutant(named: .co2)!
var uv = UVManager.shared.uvObj()






