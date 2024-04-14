//
//  FullAQIView.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 2/2/24.
//

import SwiftUI

// AQI Report view that offers full insights and warnings for user
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
                            pollutantView(title: "VOC", value: voc.concentration, type: .voc)
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
    @State private var isExpanded = false  // State to manage the disclosure group's expansion
    @ObservedObject private var pollutantManager = PollutantManager.shared
    var body: some View {
        let pollutant = PollutantManager.shared.getPollutant(named: type)!
        let concentrationValue = pollutant.concentration
        
        VStack {
            if pollutant.isSensitive {
                HStack(alignment: .center, spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.title3).foregroundColor(.yellow)
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
                        .font(.system(size: CGFloat(adjustFontSize(concentrationValue))))
                        .frame(alignment: .leading)
                    Text(returnUnit(pollutant.type))
                        .font(.system(size: 20))
                        .frame(alignment: .leading)
                }
                .frame(width: 100, alignment: .leading)

                VStack(alignment: .leading, spacing: 0) {
                    DisclosureGroup("What is \(pollutant.type.rawValue)?", isExpanded: $isExpanded) {
                        ScrollView {
                            Text(pollutantDetail(type))
                                .padding()
                        }
                        .frame(maxHeight: 150)
                    } .bold()
                    .frame(width: 200)
                    .accentColor(.primary)
                    .animation(.easeInOut, value: isExpanded)
                    .padding(.top, 1)
                    
                    Spacer()
                }
            }

            // Clean and organized Status and Warning section
            VStack(alignment: .leading, spacing: 10) {
                Text("Status:")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.blue)
                Text(warningText(type, concentrationValue, pollutant.isSensitive))
                    .padding()
                    .background(getColorForValue(concentrationValue, pollutant.type).opacity(0.2))
                    .cornerRadius(10)
            }
            .padding(.top, 5)
            .frame(maxWidth: .infinity, alignment: .center)
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



func warningText(_ type: PollutantType, _ value: Int, _ sensitive: Bool) -> String {
    var message = ""
    guard let ranges = pollutantRanges[type] else {return ""}
    var breakPoint = -1
    for (index, range) in ranges.enumerated() {
        if value >= Int(range.bpLow) && value <= Int(range.bpHigh) {
            breakPoint = index
        }
    }
    
    switch breakPoint {
    case 0:
        message += "The current concentration is normal. No safety measures needed"
        break
    case 1:
        message += "The current concentraion is above normal. Consider shorter time in the area or limit exertion"
        break
    case 2:
        message += "Concentration levels are a bit high. It is recommended to leave the area or limit exertion."
        break
    case 3:
        message += "Concentration levels are very unhealthy! You may feel symptoms. Leave the area as soon as possible."
        break
    case 4:
        message += "WARNING: LEAVE THE AREA IMMEDIATELY! You will feel symptoms!"
        break
    default:
        message += "not working"
        break
    }
    
    if sensitive && breakPoint > 0 {
        message += " You are especially sensitive to this pollutant. You may feel symptoms faster than most people!"
    }
    
    return message
}


func pollutantDetail(_ type: PollutantType) -> String {
    switch type {
    case .pm1:
        return "PM1 refers to particulate matter that is 1 micrometer or less in diameter. These fine particles are much smaller than PM10 and can originate from various sources including combustion engines, power plants, residential wood burning, forest fires, agricultural burning, and some industrial processes. PM1 particles are tiny enough to penetrate the lungs deeply and can enter the bloodstream, posing serious health risks. Due to their small size, PM1 particles can exacerbate respiratory conditions such as asthma, and increase the risk of heart attacks and strokes. They are also linked to other health problems including decreased lung function, increased respiratory symptoms, and even premature death in people with heart or lung disease. PM1 is of particular concern in urban areas where industrial emissions and traffic congestion contribute significantly to air pollution levels."
    case .pm2_5:
        return "PM2.5 refers to particulate matter that is 2.5 micrometers or less in diameter. These fine particles are produced from all types of combustion, including motor vehicles, power plants, residential wood burning, forest fires, agricultural burning, and some industrial processes. PM2.5 particles are small enough to penetrate deep into the lungs and even enter the bloodstream, posing significant health risks. Exposure to PM2.5 can lead to severe health issues, including aggravated asthma, decreased lung function, lung cancer, and cardiovascular problems, and can also lead to premature death in people with heart or lung disease. The small size of these particles allows them to bypass the body's natural defenses, making them particularly dangerous. PM2.5 is a major concern in urban areas, where their levels are often much higher due to increased combustion sources."
    case .pm10:
        return "PM10 refers to particulate matter that is 10 micrometers or less in diameter. These coarse particles originate from construction sites, unpaved roads, fields, smokestacks, and fires. Common sources include dust, pollen, and mold. PM10 particles can be inhaled and cause adverse health effects, particularly in the respiratory system, and are a concern for people with asthma and cardiovascular disease."
    case .voc:
        return "VOCs, or Volatile Organic Compounds, are a group of organic chemicals that have high vapor pressures at ordinary room temperature. Common sources of VOCs include paints, varnishes, wax, as well as many cleaning, disinfecting, cosmetic, degreasing, and hobby products. In addition, VOCs are emitted by fuels such as gasoline and byproducts produced by factories. VOCs easily become vapors or gases, a significant concern since they can cause respiratory, allergic, or immune effects in infants or children, as well as compounding asthma and other lung disorders. Long-term exposure to high levels of VOCs can also lead to severe health effects including liver, kidney, or central nervous system damage, and some VOCs are suspected or known to cause cancer in humans."
    case .co:
        return "CO, or Carbon Monoxide, is a colorless, odorless, and tasteless gas that is slightly less dense than air. It is produced by the incomplete combustion of carbon-containing materials and is often associated with engine exhaust, residential heating systems, and smoke from fires. Key sources include vehicles operating in enclosed areas, generators, stoves, lanterns, and burning charcoal and wood. Carbon Monoxide interferes with the blood's ability to carry oxygen to body tissues including vital organs such as the heart and brain. At very high levels, CO can cause severe health complications including fatigue, chest pain, impaired vision, and coordination, headaches, dizziness, confusion, nausea, and can be fatal at very high concentrations. This gas is particularly dangerous because it is undetectable without proper equipment, making it a silent and invisible killer."
    case .co2:
        return "CO2, or Carbon Dioxide, is a colorless gas with a slight, sharp odor and a sour taste; it is a minor component of Earth's atmosphere, produced by the combustion of fossil fuels and natural processes such as respiration and volcanic eruptions. Major sources of anthropogenic CO2 emissions include power plants, automobiles, aircraft, and industrial facilities that burn coal, oil, and natural gas. CO2 is also released from cement production and other industrial processes. In indoor environments, high levels of CO2 can arise from inadequate ventilation and are used as an indicator of poor air quality. Prolonged exposure to CO2 can result in significant health issues including headaches, dizziness, restlessness, a tingling or pins or needles feeling, difficulty breathing, sweating, tiredness, increased heart rate, elevated blood pressure, coma, asphyxia, and convulsions. Its global accumulation in the atmosphere also makes it a potent greenhouse gas, significantly contributing to the warming of the planet."
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
