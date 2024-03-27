import SwiftUI
import CoreData
import Charts

struct GraphView: View {
    @StateObject var viewModel: GraphViewModel

    init(pollutantType: PollutantType, managedObjectContext: NSManagedObjectContext, timeFrame: String) {
        let frame = TimeFrame(rawValue: timeFrame) ?? .daily
        _viewModel = StateObject(wrappedValue: GraphViewModel(context: managedObjectContext, pollutantType: pollutantType, timeFrame: frame))
    }

    var body: some View {
        VStack {
            Text(viewModel.timeFrame.rawValue + " Trend")
            Chart {
                ForEach(viewModel.chartData, id: \.date) { dataPoint in
                    LineMark(
                        x: .value("Time", dataPoint.date),
                        y: .value("Value", dataPoint.value)
                    )
                }
            } .frame(height: 300).padding()
            .chartXAxis {
                AxisMarks(values: .automatic) {
                    AxisGridLine()
                    AxisValueLabel(format: .dateTime.hour().minute(), centered: true)
                }
            }
            .chartYAxis {
                AxisMarks()
            }
            .navigationTitle(Text(viewModel.timeFrame.rawValue + " Trend"))
        }
    }
    
    
}



