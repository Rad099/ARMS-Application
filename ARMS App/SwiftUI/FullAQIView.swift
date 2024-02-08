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
   // @State var progressValue: Float
    //var degrees: Double

        // Define the maximum Y-coordinate start point for the gesture to be considered as initiated from the top edge
   // let topEdgeThreshold: CGFloat = 100


    var body: some View {
        VStack {
            Rectangle()
                            .frame(width: 40, height: 5)
                            .cornerRadius(2.5)
                            .opacity(0.1)
                            .padding().foregroundColor(.black)
                        
            ScrollView {
                VStack(spacing: 40) {
                    Text("Air Quality Report").font(Font.system(size: 25))
                        .bold()
                    ZStack {
                        ProgressBar(progress: progressData.progressValue)
                            .frame(width: 270.0, height: 260.0)
                        
                        HStack(spacing: 17) {
                            pollutantView(title: "PM1", value: pm1.concentration)
                            pollutantView(title: "PM2.5", value: pm2_5.concentration)
                            pollutantView(title: "PM10", value: pm10.concentration)
                            pollutantView(title: "VOC Index", value: voc.concentration)
                            pollutantView(title: "CO", value: co.concentration)
                            pollutantView(title: "CO2", value: co2.concentration)
                        }
                        .offset(CGSize(width: 3, height: 200))
                    } .padding(.bottom, 30).padding(.top, 40)
                    Text("Particle Pollution").padding()
                        .font(Font.system(size: 30))
                    HStack {
                        VStack(spacing: 20) {
                            Text("")
                            Text("EPA AQI(1-hour)").padding(.trailing, 50)
                            Text("Concentrations(5-min)")
                            
                        } .padding(.trailing, 204)
                        
                        Text("5")
                    }
                    
                    Text("VOCs").padding()
                        .font(Font.system(size: 30))
                    HStack {
                        VStack(spacing: 20) {
                            Text("")
                            Text("EPA AQI(1-hour)").padding(.trailing, 50)
                            Text("Concentrations(5-min)")
                            
                        } .padding(.trailing, 204)
                        
                        Text("5")
                    }
                    
                    Text("CO").padding()
                        .font(Font.system(size: 30))
                    
                    HStack {
                        VStack(spacing: 20) {
                            Text("")
                            Text("EPA AQI(1-hour)").padding(.trailing, 50)
                            Text("Concentrations(5-min)")
                            
                        } .padding(.trailing, 204)
                        
                        Text("5")
                    }
                    
                    Text("CO2").padding()
                        .font(Font.system(size: 30))
                    HStack {
                        VStack(spacing: 20) {
                            Text("")
                            Text("EPA AQI(1-hour)").padding(.trailing, 50)
                            Text("Concentrations(5-min)")
                            
                        } .padding(.trailing, 204)
                        
                        Text("5")
                    }
                    
                    
                    
                    

                    
    
                        //.padding(.top, 10)
                    
                    
                    Spacer()
                    
                } .padding()
            }.frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue.opacity(0.01))
             

            
           
        } .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.blue.opacity(0.01))
        
    }
}

struct FullAQIView_Previews: PreviewProvider {
    static var previews: some View {
        FullAQIView(progressData: ProgressData())
    }
}
