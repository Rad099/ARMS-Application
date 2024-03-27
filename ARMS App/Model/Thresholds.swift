//
//  Thresholds.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/11/24.
//

import Foundation

enum PollutantType: String, CaseIterable {
    case pm1 = "PM1"
    case pm2_5 = "PM2.5"
    case pm10 = "PM10"
    case voc = "VOC"
    case co = "CO"
    case co2 = "CO2"
    case uv = "UV"
}

struct Range: Codable {
    var lowerLimit: UInt16
    var upperLimit: UInt16
}

struct AQIRange: Codable {
    var range: Array<Range>
    var modified: Bool = false
}

struct pollutantThresholds: Codable {
    var pm1: AQIRange
    var pm2_5: AQIRange
    var pm10: AQIRange
    var voc: AQIRange
    var co: AQIRange
    var co2: AQIRange
    
}

func serializeThresholds(_ thresholds: pollutantThresholds) -> Data? {
    try? JSONEncoder().encode(thresholds)
}

func deserializeThresholds(_ data: Data) -> pollutantThresholds? {
    try? JSONDecoder().decode(pollutantThresholds.self, from: data)
}



func limitMod(ranges: Array<Range>) -> (Array<Range>) {
    var modifiedRanges = ranges
        for i in 0..<modifiedRanges.count {
            modifiedRanges[i].lowerLimit -= 20
            modifiedRanges[i].upperLimit -= 20
        }
        return modifiedRanges
    }


