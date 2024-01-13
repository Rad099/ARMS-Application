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

struct AQIRange {
    var lowerLimit1: Int
    var upperLimit1: Int
    var lowerLimit2: Int
    var upperLimit2: Int
    var lowerLimit3: Int
    var upperLimit3: Int
    var lowerLimit4: Int
    var upperLimit4: Int
    var lowerLimit5: Int
    var upperLimit5: Int
    var lowerLimit6: Int
    var upperLimit6: Int
}

struct pollutantThresholds {
    var pm1: AQIRange
    var pm2_5: AQIRange
    var pm10: AQIRange
    var voc: AQIRange
    var co: AQIRange
}

func decreaseThreshold(thresh: inout pollutantThresholds, AQItype: PollutantType) {
    switch AQItype {
        case .pm1:
            thresh.pm1 = limitMod(range: thresh.pm1)
        case .pm2_5:
            thresh.pm2_5 = limitMod(range: thresh.pm2_5)
        case .pm10:
            thresh.pm10 = limitMod(range: thresh.pm10)
        case .voc:
            thresh.voc = limitMod(range: thresh.voc)
        case .co:
            thresh.co = limitMod(range: thresh.co)
    }
}

func limitMod(range: AQIRange) -> AQIRange {
    var mod = range
    mod.upperLimit1 -= 20
    mod.lowerLimit2 -= 20
    mod.upperLimit2 -= 20
    mod.lowerLimit3 -= 20
    mod.upperLimit3 -= 20
    mod.lowerLimit4 -= 20
    mod.upperLimit4 -= 20
    mod.lowerLimit5 -= 20
    mod.upperLimit5 -= 20
    mod.lowerLimit6 -= 20
    
    return mod
}

let defaultAmbientAQI = AQIRange(lowerLimit1: 0, upperLimit1: 50, lowerLimit2: 51, upperLimit2: 100, lowerLimit3: 101, upperLimit3: 200, lowerLimit4: 201, upperLimit4: 300, lowerLimit5: 301, upperLimit5: 400, lowerLimit6: 401, upperLimit6: 500)


let defaultAmbientThresholds = pollutantThresholds(pm1: defaultAmbientAQI, pm2_5: defaultAmbientAQI, pm10: defaultAmbientAQI, voc: defaultAmbientAQI, co: defaultAmbientAQI)

