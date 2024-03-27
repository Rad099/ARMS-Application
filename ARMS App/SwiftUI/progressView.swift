//
//  progressView.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/30/24.
//

import SwiftUI
import CoreData

class ProgressData: ObservableObject {
    //static let shared = ProgressData()
    @Published var progressValue: Float = 0
    @Published var degrees: Double = -110

    func setProgressValue(to newValue: Float) {
            withAnimation {
                self.progressValue = newValue
                self.degrees = Double(newValue) * 220.0 - 110.0
  
            }
        }
    
    func updateProgress(fromPAQRValue value: Int) {
        withAnimation {
            let newValue = Float(value) / 100.0 // Assuming PAQR.value ranges from 0 to 100
            setProgressValue(to: newValue)
        }
    }
}

let context = PersistenceController.shared.container.viewContext
 


struct ContentView: View {
    
    @ObservedObject var progressData = ProgressData()
    @ObservedObject var paqr: PAQR
    @State var showingSheet = false
    @ObservedObject var pm1 = PollutantManager.shared.getPollutant(named: .pm1)!
    @ObservedObject var pm2_5 = PollutantManager.shared.getPollutant(named: .pm2_5)!
    @ObservedObject var pm10 = PollutantManager.shared.getPollutant(named: .pm10)!
    @ObservedObject var voc =  PollutantManager.shared.getPollutant(named: .voc)!
    @ObservedObject var co =  PollutantManager.shared.getPollutant(named: .co)!
    @ObservedObject var co2 = PollutantManager.shared.getPollutant(named: .co2)!
    
   
    var body: some View {
        ZStack {
            VStack {
                Text("Personalized Air Quality Range")
                    .font(Font.system(size: 18))
                    .bold()
                    //.foregroundColor(.white)
                    .padding(.top, 25)
                Text(timeSinceUpdateMessage())
                    .padding(.bottom, 8)
                    .padding(.top, 5)
                    .font(Font.system(size: 11))
                   // .foregroundColor(.white)
                
                ZStack {
                    ProgressBar(progress: Float(paqr.value))
                        .frame(width: 270.0, height: 260.0)
                    
                    HStack(spacing: 17) {
                        pollutantView(title: "PM1", value: pm1.concentration, type: .pm1)
                        pollutantView(title: "PM2.5", value: pm2_5.concentration, type: .pm2_5)
                        pollutantView(title: "PM10", value: pm10.concentration, type: .pm10)
                        pollutantView(title: "VOC Index", value: voc.concentration, type: .voc)
                        pollutantView(title: "CO", value: co.concentration, type: .co)
                        pollutantView(title: "CO2", value: co2.concentration, type: .co2)
                    }
                    .offset(CGSize(width: 3, height: 260))
                }
                
                Button("Show AQ Report") {
                    showingSheet = true
                }.offset(CGSize(width: 0, height: -25))
                    .bold().padding(.top, 10)
                
            }
            .background(Color.clear)
            

        }

        
            .sheet(isPresented: $showingSheet) {
            
            FullAQIView(progressData: progressData)
        }
        
        
        
    }
}
    

func timeSinceUpdateMessage() -> String {
    guard let latestRecord = PollutantManager.shared.getconcMRD() else {
            return "No data available"
        }
    
        //print("Latest record we got: \(latestRecord)")
        
        return relativeTimeString(for: latestRecord)
       // return manualRelativeTimeString(for: latestRecord)
    }

func relativeTimeString(for date: Date?) -> String {
    guard let date = date else { return "No timestamp available" }

    // Calculate the time difference between now and the input date
    let timeInterval = Date().timeIntervalSince(date)
    
    // Check if the update occurred within 10 seconds ago
    if timeInterval <= 10 {
        return "Updated just now"
    }

    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full
    let relativeDate = formatter.localizedString(for: date, relativeTo: Date())
    let text = "Updated \(relativeDate)"

    return text
}


func pollutantView(title: String, value: Int, type: PollutantType) -> some View {
            VStack(spacing: 5) {
                Text(title)
                    .font(Font.system(size: 15))
                    //.foregroundColor(Color.init(.white))
                Text("\(value)")
                    .bold()
                    .font(Font.system(size: 25))
                    //.foregroundColor(Color.init(.white))
                Circle()
                    .frame(width: 5, height: 5)
                    .foregroundColor(getColorForValue(value, type))
                    
                Spacer()
            }
    }

private func getColorForValue(_ value: Int, _ type: PollutantType) -> Color {
    guard let ranges = pollutantRanges[type] else { return Color.gray }
    
    let colors = [Color.green, Color.teal, Color.yellow, Color.orange, Color.red]
    for (index, range) in ranges.enumerated() {
        if value >= Int(range.bpLow) && value <= Int(range.bpHigh) {
            let colorIndex = min(index, colors.count - 1)
            return colors[colorIndex]
        }
    }
    
    return Color.gray
}
    
    

    
    struct ProgressBar: View {
         var progress: Float
        
        private var normalizedProgress: CGFloat {
               // Map the progress value (0-100) to a range of 0.3 to 0.9
            let scaledProgress = (progress / 100) * (0.9 - 0.3) + 0.3
          //  let invertedProgress = 100 - progress // Invert the progress value
           // let scaledProgress = (Float(invertedProgress) / 100) * (0.9 - 0.3) + 0.3
            return CGFloat(scaledProgress)
        }
        
        private var angle: Angle {
            // Angle range for the progress: from -180 to 0 degrees
            let startAngle = -197.0
            let endAngle = 18.0
            
            let angleSpan = endAngle - startAngle
            let angleForProgress = startAngle + (Double(progress) / 100.0) * angleSpan
           // let angleForProgress = endAngle - (Double(progress) / 100.0) * angleSpan
            return .degrees(angleForProgress)
        }
        
        
        
        var body: some View {
            ZStack {
                Circle()
                    .trim(from: 0.3, to: 0.9)
                    .stroke(style: StrokeStyle(lineWidth: 30.0, lineCap: .round, lineJoin: .round))
                    .fill(AngularGradient(gradient: Gradient(stops: [
                        .init(color: Color.init(hex: "ED4D4D"), location: 0.39000002),
                        .init(color: Color.init(hex: "E59148"), location: 0.48000002),
                        .init(color: Color.init(hex: "EFBF39"), location: 0.5999999),
                        .init(color: Color.init(hex: "EEED56"), location: 0.7199998),
                        .init(color: Color.init(hex: "32E1A0"), location: 0.8099997)]), center: .center))
                    .rotationEffect(.degrees(54.5))
                

                
                Circle()
                                .fill(Color.white)
                                .frame(width: 20, height: 20) // Adjust the size of the thumb circle as needed
                                .offset(x: 130) // Adjust this to match the radius of your progress bar
                                .rotationEffect(angle)
                                .shadow(radius: 3)
                
                VStack {
                    // Displaying the current progress value
                    Text("\(Int(progress))")
                        .font(Font.system(size: 60))
                        .bold()
                       //.foregroundColor(Color.init(.white))
                       .offset(CGSize(width: 0, height: -20))
                       
                    if progress > 80 && progress <= 100 {
                        Text("Air is good.")
                            .bold()
                            .foregroundColor(Color.init(hex: "32E1A0"))
                    } else if progress <= 80 && progress > 60 {
                        Text("Air is mildy polluted.")
                            .bold()
                            .foregroundColor(Color.init(.mint))
                    } else if progress > 40 && progress <= 60 {
                        Text("Air is polluted.")
                            .bold()
                            .foregroundColor(Color.init(.yellow))
                        
                    } else if progress > 20 && progress <= 40 {
                        Text("Air is very unhealthy.")
                            .bold()
                            .foregroundColor(Color.init(.orange))
                    } else {
                        Text("Air is hazardous.")
                            .bold()
                            .foregroundColor(Color.init(.red))
                    }
                    
                }
            }
        }
    }
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(progressData: ProgressData(), paqr: paqr)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}



