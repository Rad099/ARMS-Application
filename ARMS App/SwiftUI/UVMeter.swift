//
//  UVMeter.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/30/24.
//

import SwiftUI

struct UVIndexMeter: View {
    var uvIndex: CGFloat

    private struct UVIndexZone {
        var range: ClosedRange<CGFloat>
        var color: Color
    }

    private let zones: [UVIndexZone] = [
        UVIndexZone(range: 9...11, color: .red),
        UVIndexZone(range: 6...8, color: .orange),
        UVIndexZone(range: 4...5, color: .yellow),
        UVIndexZone(range: 0...3, color: .green)
    ]

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20) // Soft edges
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.init(hex: "ED4D4D"), Color.init(hex: "E59148"), Color.init(hex: "EFBF39"), Color.init(hex: "EEED56"), Color.init(hex: "32E1A0")]), // Multiple colors
                        startPoint: .top, // Start of the gradient
                        endPoint: .bottom // End of the gradient
                    )
                )
                .frame(width: 30, height: 300)
                .overlay(
                    Circle()
                        .fill(Color.white)
                        .frame(width: 20, height: 20)
                        .offset(y: calculateCircleOffset(from: uvIndex, for: 300))
            )
        }
    }

    
private func calculateCircleOffset(from uvIndex: CGFloat, for meterHeight: CGFloat) -> CGFloat {
      
        let maxUVIndex: CGFloat = 11
       
        let ratio = uvIndex / maxUVIndex
  
        let offset = (1 - ratio) * (meterHeight - 20) - (meterHeight / 2 - 10)
        return offset
    }
}

struct cutLines: View {
    var text: String
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 2, height: 100, alignment: .center).rotationEffect(.degrees(90)).padding(.leading, 54)
            Text(text).offset(CGSize(width: 60.0, height: 20.0)).frame(width: 100, alignment: .leading).font(Font.system(size: 15)).bold()
            
        }
    }
    
}

struct UVContentView: View {
    @ObservedObject var uv = UVManager.shared.uvObj()
  

    var body: some View {
        let progress = uv.currentValue
        VStack {
            Text("Personalized UV Meter")
                    .font(Font.system(size: 18))
                    .bold()
                    .padding(.top, 25)
                    .padding(.bottom, 20)
            
            ZStack {
                HStack(spacing: 100) {
                    UVIndexMeter(uvIndex: progress).padding(.trailing).overlay(VStack {
                        cutLines(text: "Very high").offset(CGSize(width: 0, height: 35))
                        cutLines(text: "High").offset(CGSize(width: 0, height: 5))
                        
                        cutLines(text: "Mild").offset(CGSize(width: 0, height: -50))
                        cutLines(text: "Safe").offset(CGSize(width: 0, height: -80))
                    }
                )
                    VStack(spacing: 30) {
                        Text("UV Index:").font(Font.system(size: 30))
                            .bold()
                        Text("\(Int(uv.currentValue))")
                            .font(Font.system(size: 60))
                            .bold()
                           .offset(CGSize(width: 0, height: -20))
                           
                        if progress >= 0 && progress <= 2 {
                            Text("Safe UV exposure.")
                                .bold()
                                .foregroundColor(Color.init(hex: "32E1A0"))
                        } else if progress <= 5 && progress > 2 {
                            Text("Mild exposure.")
                                .bold()
                                .foregroundColor(Color.init(hex: "EEED56"))
                        } else if progress > 5 && progress <= 7 {
                            Text("High UV exposure.")
                                .bold()
                                .foregroundColor(Color.init(.yellow))
                            
                        } else if progress > 7 && progress <= 10 {
                            Text("Very high exposure.")
                                .bold()
                                .foregroundColor(Color.init(.orange))
                        } else {
                            Text("Extremely high exposure.")
                                .bold()
                                .foregroundColor(Color.init(.red))
                        }
                    }
                }
            }
        }
        
        Spacer()
    }
}

#Preview {
    UVContentView()
}
