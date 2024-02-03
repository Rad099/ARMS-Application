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
        GeometryReader { geometry in
            VStack(spacing: 0) {
                ForEach(zones, id: \.range) { zone in
                    Rectangle()
                        .fill(zone.color)
                        .frame(height: geometry.size.height * (zone.range.upperBound - zone.range.lowerBound + 1) / 11)
                       // .overlay(
                          //  uvIndex >= zone.range.lowerBound && uvIndex <= zone.range.upperBound
                           //     ? Rectangle().stroke(Color.black, lineWidth: 2)
                          //      : nil
                       // )
                    
                }
                
                .overlay(
                        Circle()
                            .fill(Color.white)
                            .frame(height: 2)
                            .offset(y: -(geometry.size.height * (1 - (uvIndex / 11))))
                                , alignment: .bottom
                            )
                
            }
        
        }
        .frame(width: 50, height: 400)
        .border(Color.black, width: 1)
        .cornerRadius(10)
    }
}

struct UVContentView: View {
    @State private var uvIndex: CGFloat = 0

    var body: some View {
        VStack {
            UVIndexMeter(uvIndex: uvIndex)

            Slider(value: $uvIndex, in: 0...11)
        }
        .padding()
    }
}

#Preview {
    UVIndexMeter(uvIndex: 11.0)
}
