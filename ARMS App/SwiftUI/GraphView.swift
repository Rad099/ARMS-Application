import SwiftUI
import CoreData
import SwiftUICharts

struct GraphView: View {
        var pollutantType: PollutantType
        var managedObjectContext: NSManagedObjectContext
        var pollutants: [ConcentrationRecord] // Updated to an array of ConcentrationRecord
        var timeFrame: String // "Daily", "Weekly", or "Monthly"

    init(pollutantType: PollutantType, managedObjectContext: NSManagedObjectContext, timeFrame: String) {
        self.pollutantType = pollutantType
        self.managedObjectContext = managedObjectContext
        self.timeFrame = timeFrame
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        var startDate: Date?
        var endDate: Date?

        switch timeFrame {
        case "Daily":
            startDate = startOfDay
            endDate = calendar.date(byAdding: .day, value: 1, to: startOfDay)
        case "Weekly":
            startDate = calendar.date(byAdding: .day, value: -7, to: startOfDay)
            endDate = calendar.date(byAdding: .day, value: 1, to: startOfDay)
        case "Monthly":
            startDate = calendar.date(byAdding: .month, value: -1, to: startOfDay)
            endDate = calendar.date(byAdding: .day, value: 1, to: startOfDay)
        default:
            break
        }

        guard let start = startDate, let end = endDate else {
            self.pollutants = []
            return
        }

        let fetchRequest: NSFetchRequest<ConcentrationRecord> = ConcentrationRecord.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ConcentrationRecord.timestamp, ascending: true)]
        
        let typePredicate = NSPredicate(format: "type == %@", pollutantType.rawValue)
        let datePredicate = NSPredicate(format: "(timestamp >= %@) AND (timestamp < %@)", start as NSDate, end as NSDate)
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [typePredicate, datePredicate])
        
        do {
            self.pollutants = try managedObjectContext.fetch(fetchRequest)
        } catch {
            print("Fetch failed, error: \(error)")
            self.pollutants = [] // Provide an empty array in case of failure
        }
    }


    var body: some View {
        VStack {
            if !prepareData(pollutants).isEmpty {
                LineView(data: prepareData(pollutants), title: "Line chart", legend: "Full screen").padding() // legend is optional, use optional .padding()
            } else {
                Text("No data available")
            }
        }
    }

    private func prepareData(_ pollutants: [ConcentrationRecord]) -> [Double] {
        pollutants.map { Double($0.concentration) }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
