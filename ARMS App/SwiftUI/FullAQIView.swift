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
                        pollutionStats()
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


struct pollutionStats: View {
    var aqi = 0
    var concentration = 0
    
    var body: some View {
        Text("Particle Pollution").padding()
            .font(Font.system(size: 30))
        HStack {
            VStack(spacing: 20) {
                Text("")
                Text("EPA AQI(1-hour)").padding(.trailing, 50)
                Text("Concentrations(5-min)")
                
            } .padding(.trailing, 150)
            
            Text("5")
        }
    }
}

struct aqiStats: View {
    var type: PollutantType

    var body: some View {
        let pollutant = PollutantManager.shared.getPollutant(named: type)
        Text(String(type.rawValue)).padding()
            .font(Font.system(size: 30))
        HStack {
            VStack(spacing: 20) {
                Text("")
                Text("EPA AQI(1-hour)").padding(.trailing, 50).foregroundColor(.white)
                Text("Concentrations(5-min)")
                
            } .padding(.trailing, 150)
            
            VStack(spacing: 20) {
                Text("\(pollutant!.currentHourIndex)")
                Text("\(pollutant!.concentration)")
                
            }
            
        }
    }
}

struct FullAQIView_Previews: PreviewProvider {
    static var previews: some View {
        FullAQIView(progressData: ProgressData())
    }
}
