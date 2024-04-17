import Foundation
import CoreData
import Combine

enum TimeFrame: String {
    case daily = "Daily"
    case weekly = "Weekly"
    case monthly = "Monthly"
}

class GraphViewModel: ObservableObject {
    private var managedObjectContext: NSManagedObjectContext
    var pollutantType: PollutantType
    var timeFrame: TimeFrame
    private var cancellables = Set<AnyCancellable>()

    @Published var chartData: [(date: Date, value: Double)] = []

    init(context: NSManagedObjectContext, pollutantType: PollutantType, timeFrame: TimeFrame) {
        self.managedObjectContext = context
        self.pollutantType = pollutantType
        self.timeFrame = timeFrame
        fetchData()

        NotificationCenter.default.publisher(for: .NSManagedObjectContextObjectsDidChange, object: context)
            .sink { [weak self] _ in self?.fetchData() }
            .store(in: &cancellables)
    }

    func fetchData() {
        let fetchRequest: NSFetchRequest<ConcentrationRecord> = ConcentrationRecord.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [NSPredicate(format: "type == %@", pollutantType.rawValue), timeFramePredicate()])
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \ConcentrationRecord.timestamp, ascending: true)]

        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            DispatchQueue.main.async {
                self.chartData = self.aggregateData(results: results)
            }
        } catch {
            print("Failed to fetch data: \(error)")
        }
    }

    private func timeFramePredicate() -> NSPredicate {
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        var startDate: Date?
        var endDate: Date?

        switch timeFrame {
        case .daily:
            startDate = startOfDay
            endDate = calendar.date(byAdding: .day, value: 1, to: startOfDay)
        case .weekly:
            startDate = calendar.date(byAdding: .day, value: -7, to: startOfDay)
            endDate = calendar.date(byAdding: .day, value: 1, to: startOfDay)
        case .monthly:
            startDate = calendar.date(byAdding: .month, value: -1, to: startOfDay)
            endDate = calendar.date(byAdding: .day, value: 1, to: startOfDay)
        }

        return NSPredicate(format: "(timestamp >= %@) AND (timestamp < %@)", argumentArray: [startDate!, endDate!])
    }

    private func aggregateData(results: [ConcentrationRecord]) -> [(date: Date, value: Double)] {
        switch timeFrame {
        case .daily:
            return results.map { (date: $0.timestamp!, value: Double($0.concentration)) }
        case .weekly, .monthly:
            let groupedResults = Dictionary(grouping: results, by: { $0.timestamp!.startOfPeriod(for: timeFrame) })
            return groupedResults.map { (key, values) in
                let average = values.map { Double($0.concentration) }.reduce(0.0, +) / Double(values.count)
                return (date: key, value: average)
            }.sorted(by: { $0.date < $1.date })
        }
    }
}

extension Date {
    func startOfPeriod(for timeFrame: TimeFrame) -> Date {
        let calendar = Calendar.current
        switch timeFrame {
        case .weekly:
            return calendar.startOfWeek(for: self)
        case .monthly:
            return calendar.startOfMonth(for: self)
        default:
            return self
        }
    }
}

extension Calendar {
    func startOfWeek(for date: Date) -> Date {
        return self.date(from: self.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
    }

    func startOfMonth(for date: Date) -> Date {
        return self.date(from: self.dateComponents([.year, .month], from: date))!
    }
}
