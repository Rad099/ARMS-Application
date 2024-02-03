//
//  progressView.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/30/24.
//

import SwiftUI

class ProgressData: ObservableObject {
    @Published var progressValue: Float = 75.0
    @Published var degrees: Double = -110
    @Published var pollutantData: Array<Int> = [50, 100, 0, 200, 0, 300]


    func setProgressValue(to newValue: Float) {
        withAnimation {
            self.progressValue = newValue
            self.degrees = Double(newValue) * 220.0 - 110.0
        }
    }
    
    func setPollutantData(to array: Array<Int>) {
        withAnimation {
            self.pollutantData = array
        }
    }
}

struct ContentView: View {
    @ObservedObject var progressData: ProgressData
    @State private var showingSheet = false

    var body: some View {
        //NavigationStack {
            VStack {
                Text("Personalized Air Quality Range")
                    .font(Font.system(size: 18))
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom, 20)
                    .padding(.top, 25)
                
                ZStack {
                    ProgressBar(progress: self.$progressData.progressValue)
                        .frame(width: 270.0, height: 260.0)
                    
                    HStack(spacing: 17) {
                        pollutantView(title: "PM1", value: $progressData.pollutantData[0])
                        pollutantView(title: "PM2.5", value: $progressData.pollutantData[1])
                        pollutantView(title: "PM10", value: $progressData.pollutantData[2])
                        pollutantView(title: "VOC Index", value: $progressData.pollutantData[3])
                        pollutantView(title: "CO", value: $progressData.pollutantData[4])
                        pollutantView(title: "CO2", value: $progressData.pollutantData[5])
                    }
                    .offset(CGSize(width: 3, height: 260))
                }
                
                Button("Show Details") {
                        showingSheet = true
                }.offset(CGSize(width: 0, height: -25))
                    .foregroundColor(.white).bold()
    
            //.navigationDestination(isPresented: $isShowingExtendedContentView) {
            //   FullAQIView()
           // }
        }
            .background(Color.clear)
            .sheet(isPresented: $showingSheet) {
                        // Content of the sheet goes here
                        FullAQIView(progressData: progressData)
            }
    }
}
    
    
    
    
    func pollutantView(title: String, value: Binding<Int>) -> some View {
            VStack(spacing: 5) {
                Text(title)
                    .font(Font.system(size: 15))
                    .foregroundColor(Color.init(.white))
                Text("\(value.wrappedValue)")
                    .bold()
                    .font(Font.system(size: 25))
                    .foregroundColor(Color.init(.white))
                Circle()
                    .frame(width: 5, height: 5)
                    .foregroundColor(getColorForValue(value.wrappedValue))
                    
                Spacer()
            }
        }

private func getColorForValue(_ value: Int) -> Color {
    switch value {
    case ..<0:
        return Color.init(hex: "32E1A0") // Consider handling negative values if needed
    case 0..<50:
        return Color.green
    case 50..<80:
        return Color.yellow
    default:
        return Color.red
    }
}
    
    

    
    struct ProgressBar: View {
        @Binding var progress: Float
        
        private var normalizedProgress: CGFloat {
               // Map the progress value (0-100) to a range of 0.3 to 0.9
               let scaledProgress = (progress / 100) * (0.9 - 0.3) + 0.3
               return CGFloat(scaledProgress)
        }
        
        private var angle: Angle {
            // Angle range for the progress: from -180 to 0 degrees
            let startAngle = -197.0
            let endAngle = 18.0
            
            let angleSpan = endAngle - startAngle
            let angleForProgress = startAngle + (Double(progress) / 100.0) * angleSpan
            return .degrees(angleForProgress)
        }
        
        
        
        var body: some View {
            ZStack {
                Circle()
                    .trim(from: 0.3, to: 0.9)
                    .stroke(style: StrokeStyle(lineWidth: 30.0, lineCap: .round, lineJoin: .round))
                    .fill(AngularGradient(gradient: Gradient(stops: [
                        .init(color: Color.init(hex: "32E1A0"), location: 0.39000002),
                        .init(color: Color.init(hex: "EEED56"), location: 0.48000002),
                        .init(color: Color.init(hex: "EFBF39"), location: 0.5999999),
                        .init(color: Color.init(hex: "E59148"), location: 0.7199998),
                        .init(color: Color.init(hex: "ED4D4D"), location: 0.8099997)]), center: .center))
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
                       .foregroundColor(Color.init(.white))
                       .offset(CGSize(width: 0, height: -20))
                       
                    if progress >= 0 && progress <= 20 {
                        Text("Air is good.")
                            .bold()
                            .foregroundColor(Color.init(hex: "32E1A0"))
                    } else if progress <= 40 && progress > 20 {
                        Text("Air is mildy polluted.")
                            .bold()
                            .foregroundColor(Color.init(.mint))
                    } else if progress > 40 && progress <= 60 {
                        Text("Air is polluted.")
                            .bold()
                            .foregroundColor(Color.init(.yellow))
                        
                    } else if progress > 60 && progress <= 80 {
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
        ContentView(progressData: ProgressData())
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



