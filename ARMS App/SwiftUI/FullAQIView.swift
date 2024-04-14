//
//  FullAQIView.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 2/2/24.
//

import SwiftUI

// new view when pressed
struct FullAQIView: View {
    @ObservedObject var progressData = ProgressData()
    @Environment(\.colorScheme) var scheme
   

    var body: some View {
        VStack {
            Rectangle()
                            .frame(width: 40, height: 5)
                            .cornerRadius(2.5)
                            .opacity(0.1)
                            .padding()
                        
            ScrollView {
                VStack(spacing: 40) {
                    Text("Air Quality Report").font(Font.system(size: 25))
                        .bold()
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
                        .offset(CGSize(width: 3, height: 200))
                    } .padding(.bottom, 30).padding(.top, 40)
                    VStack {
                        aqiStats(type: .pm1)
                        aqiStats(type: .pm2_5)
                        aqiStats(type: .pm10)
                        aqiStats(type: .voc)
                        aqiStats(type: .co)
                        aqiStats(type: .co2)
                        
                    }
                
                    
                    
                    
                    

                    
    
                        //.padding(.top, 10)
                    
                    
                    Spacer()
                    
                } .padding()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
               
        

            
           
        }

    }
}


func returnUnit(_ type: PollutantType) -> String {
    
    if type == .pm1 || type == .pm2_5 || type == .pm10 {
       return "ug/m\u{00B3}"
    } else if type == .co || type == .co2 {
        return "ppm"
    } else if type == .voc {
        return "index"
    }
    return ""
}


struct aqiStats: View {
    var type: PollutantType
    var aqi = 0
    var concentration = 0

    @State private var isExpanded = false  // State to manage the disclosure group's expansion

    var body: some View {
        let pollutant = PollutantManager.shared.getPollutant(named: type)
        let concentrationValue = pollutant!.concentration
        VStack {
            if pollutant!.isSensitive {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.title3).foregroundColor(.orange)
                    Text("You Are Sensitive")
                        .font(.title3)
                        .fontWeight(.medium)
                }
                .padding(.bottom, 5)
            }

            HStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 5) {
                    Text(type.rawValue)
                        .font(.system(size: 35))
                        .frame(minWidth: 80, alignment: .leading)
                    Text("\(concentrationValue)")
                        .foregroundColor(getColorForValue(concentrationValue, type))
                        .font(.system(size: CGFloat(adjustFontSize( concentration))))
                        .frame(alignment: .leading)
                    Text(returnUnit(pollutant!.type))
                        .font(.system(size: 20))
                        .frame(alignment: .leading)
                }
                .frame(width: 100, alignment: .leading)

                VStack(alignment: .leading, spacing: 0) {
                    DisclosureGroup("What is \(pollutant!.type.rawValue)?", isExpanded: $isExpanded) {
                        ScrollView {
                            Text(pollutantDetail(type))
                                .padding()
                        }
                        .frame(maxHeight: 100)  // Max height for the ScrollView when expanded
                        
                    }
                    
                    .frame(width: 200)  // Fixed width for the DisclosureGroup
                    .accentColor(.primary).bold()
                    .animation(.easeOut, value: isExpanded)  // Disabling animation to keep the label fixed
                    .padding(.top, 1)  // Minimal padding from the title stack
                    

                    Spacer()  // Pushes everything up
                }
            }
        }
        .padding()
    }
}


private func getColorForValue(_ value: Int, _ type: PollutantType) -> Color {
    guard let ranges = pollutantRanges[type] else { return Color.gray }
    
    let colors = [Color.init(hex: "32E1A0"), Color.teal, Color.yellow, Color.orange, Color.red]
    for (index, range) in ranges.enumerated() {
        if value >= Int(range.bpLow) && value <= Int(range.bpHigh) {
            let colorIndex = min(index, colors.count - 1)
            return colors[colorIndex]
        }
    }
    
    return Color.gray
}



func pollutantDetail(_ type: PollutantType) -> String {
    switch type {
    case .pm1:
        return "PM1 is the smallest known particle pollutant. It originates from many sources, including vapor, and smoke. Young and elderly persons, as well as persons with respiratory diseases are particularly sensitive."
    case .pm2_5:
        return "PM2.5 consists of fine particulate matter less than 2.5 micrometers in diameter. These particles, originating from industrial emissions, vehicle exhaust, and natural sources like wildfires. Young, elderly, and those with heart disease are sensitive."
    case .pm10:
        return "PM10 refers to particulate matter that is 10 micrometers or less in diameter. These coarse particles originate from construction sites, unpaved roads, fields, smokestacks, and fires. Common sources include dust, pollen, and mold. PM10 particles can be inhaled and cause adverse health effects, particularly in the respiratory system, and are a concern for people with asthma and cardiovascular disease."
    case .voc:
        return ""
    case .co:
        return ""
    case .co2:
        return ""
    case .uv:
        return ""
    }
    
}

func adjustFontSize(_ value: Int) -> Int {
    if value < 100 {
        return 80
    } else if value >= 100 && value < 1000 {
        return 55
    } else {
        return 50
    }
}

struct FullAQIView_Previews: PreviewProvider {
    static var previews: some View {
        FullAQIView(progressData: ProgressData())
    }
}
