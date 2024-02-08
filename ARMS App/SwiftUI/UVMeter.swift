//
//  UVMeter.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/30/24.
//

import SwiftUI

struct UVIndexMeter: View {
    var uvIndex: CGFloat // Assuming uvIndex is between 0 and 11

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
                            gradient: Gradient(colors: [Color.init(hex: "ED4D4D"), Color.init(hex: "E59148"), Color.init(hex: "EFBF39"),  Color.init(hex: "EEED56"), Color.init(hex: "32E1A0")]), // Multiple colors
                            startPoint: .top, // Start of the gradient
                            endPoint: .bottom // End of the gradient
                        )
                    )
                    .frame(width: 30, height: 300) // Specific dimensions
        }
                
                
        }
    }

struct cutLines: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 2, height: 100, alignment: .center).rotationEffect(.degrees(90)).padding(.leading, 54)
            
        }
    }
    
}

struct UVContentView: View {
    @State private var uvIndex: CGFloat = 0
    var progress: Int = 9

    var body: some View {
        VStack {
            Text("Personalized UV Meter")
                    .font(Font.system(size: 18))
                    .bold()
                    .foregroundColor(.white)
                    .padding(.top, 25)
                    .padding(.bottom, 20)
            
            ZStack {
                HStack(spacing: 100) {
                        UVIndexMeter(uvIndex: uvIndex).padding(.trailing).overlay(VStack {
                            cutLines().offset(CGSize(width: 0, height: 50))
                            cutLines().offset(CGSize(width: 0, height: 10))
 
                            cutLines().offset(CGSize(width: 0, height: -20))
                            cutLines().offset(CGSize(width: 0, height: -60))
                        }
                )
                    VStack(spacing: 30) {
                        Text("UV Index:").font(Font.system(size: 30))
                            .bold()
                            .foregroundColor(.white)
                        Text("\(Int(progress))")
                            .font(Font.system(size: 60))
                            .bold()
                           .foregroundColor(Color.init(.white))
                           .offset(CGSize(width: 0, height: -20))
                           
                        if progress >= 0 && progress <= 2 {
                            Text("Safe UV exposure.")
                                .bold()
                                .foregroundColor(Color.init(hex: "32E1A0"))
                        } else if progress <= 5 && progress > 2 {
                            Text("Mild exposure.")
                                .bold()
                                .foregroundColor(Color.init(.mint))
                        } else if progress > 5 && progress <= 7 {
                            Text("unsafe UV exposure.")
                                .bold()
                                .foregroundColor(Color.init(.yellow))
                            
                        } else if progress > 7 && progress <= 10 {
                            Text("UV exposure is high.")
                                .bold()
                                .foregroundColor(Color.init(.orange))
                        } else {
                            Text("UV exposure too high.")
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
