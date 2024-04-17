import SwiftUI
import CoreData
import Charts

struct GraphView: View {
    @ObservedObject var viewModel: GraphViewModel  // Use ObservedObject if the ViewModel is initialized outside

    init(pollutantType: PollutantType, managedObjectContext: NSManagedObjectContext, timeFrame: String) {
        let frame = TimeFrame(rawValue: timeFrame) ?? .daily
        viewModel = GraphViewModel(context: managedObjectContext, pollutantType: pollutantType, timeFrame: frame)
    }

    var body: some View {
        VStack {
            Text("\(viewModel.pollutantType.rawValue)").bold().font(Font.system(size: 40))
            Text(viewModel.timeFrame.rawValue + " Trend")
            Chart {
                ForEach(viewModel.chartData, id: \.date) { dataPoint in
                    PointMark(
                        x: .value("Time", dataPoint.date),
                        y: .value("Value", dataPoint.value)
                    )
                }
            }
            .frame(height: 300).padding()
            .chartXAxis {
                switch viewModel.timeFrame {
                case .daily:
                    AxisMarks(position: .bottom) {
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.hour())
                    }
                case .weekly:
                    AxisMarks(position: .bottom) {
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.day().month())
                    }
                case .monthly:
                    AxisMarks(position: .bottom) {
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.day().month())
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) {
                    AxisGridLine()
                    AxisValueLabel()
                }
            }
            .navigationTitle(Text(viewModel.timeFrame.rawValue + " Trend"))
        }
    }
}

