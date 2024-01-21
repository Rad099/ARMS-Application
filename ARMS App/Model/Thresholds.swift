//
//  Thresholds.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/11/24.
//

import Foundation

enum PollutantType {
    case pm1
    case pm2_5
    case pm10
    case voc
    case co
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


// defaults
let defaultRange = [Range(lowerLimit: 0, upperLimit: 50), Range(lowerLimit: 51, upperLimit: 100), Range(lowerLimit: 101, upperLimit: 200), Range(lowerLimit: 201, upperLimit: 300), Range(lowerLimit: 301, upperLimit: 400), Range(lowerLimit: 401, upperLimit: 500)]

let defaultAmbientAQI = AQIRange(range: defaultRange, modified: false)


let defaultAmbientThresholds = pollutantThresholds(pm1: defaultAmbientAQI, pm2_5: defaultAmbientAQI, pm10: defaultAmbientAQI, voc: defaultAmbientAQI, co: defaultAmbientAQI)
