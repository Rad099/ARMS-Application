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



func decreaseThreshold(thresh: inout pollutantThresholds, AQItype: PollutantType) {
    switch AQItype {
    case .pm1:
        if !thresh.pm1.modified {
            thresh.pm1.range = limitMod(ranges: thresh.pm1.range)
            thresh.pm1.modified = true
        }
    case .pm2_5:
        if !thresh.pm2_5.modified {
            thresh.pm2_5.range = limitMod(ranges: thresh.pm2_5.range)
            thresh.pm2_5.modified = true
        }
        
    case .pm10:
        if !thresh.pm10.modified {
            thresh.pm10.range = limitMod(ranges: thresh.pm10.range)
            thresh.pm10.modified = true
        }
    case .voc:
        if !thresh.voc.modified {
            thresh.voc.range = limitMod(ranges: thresh.voc.range)
            thresh.voc.modified = true
        }
    case .co:
        if !thresh.co.modified {
            thresh.co.range = limitMod(ranges: thresh.co.range)
            thresh.co.modified = true
        }
        
    case .co2:
        if !thresh.co2.modified {
            thresh.co2.range = limitMod(ranges: thresh.co2.range)
            thresh.co2.modified = true
        }
    }
    
}

func limitMod(ranges: Array<Range>) -> (Array<Range>) {
    var modifiedRanges = ranges
        for i in 0..<modifiedRanges.count {
            modifiedRanges[i].lowerLimit -= 20
            modifiedRanges[i].upperLimit -= 20
        }
        return modifiedRanges
    }


