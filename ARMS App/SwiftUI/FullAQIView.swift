//
//  FullAQIView.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 2/2/24.
//

import SwiftUI

// new view when pressed
struct FullAQIView: View {
    @ObservedObject var progressData: ProgressData

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
                //.background(Color.blue.opacity(0.5))
             

            
           
        } .frame(maxWidth: .infinity, maxHeight: .infinity)
            //.background(Color.blue.opacity(0.5))
        
    }
}

#Preview {
   FullAQIView(progressData: ProgressData())
}
