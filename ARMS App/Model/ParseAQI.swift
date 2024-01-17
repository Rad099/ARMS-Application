//
//  ParseAQI.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/4/24.
//  Used for parsing Bluetooth Characteristic
//  holding all AQI/UVI values
//

import Foundation
import CoreBluetooth

var uv: pollutant?
var pm1: pollutant?
var pm2_5: pollutant?
var pm10: pollutant?
var voc: pollutant?
var co: pollutant?
var averages: Array<Double> = []


/*
func parseCharacteristic(characteristic: CBCharacteristic) {
    // Update your class values
    var value1: UInt16 = 0
    var value2: UInt16 = 0
    var value3: UInt16 = 0
    var value4: UInt16 = 0
    var value5: UInt16 = 0
    var value6: UInt16 = 0
    guard let characteristicData = characteristic.value else { return }

    // Each UInt16 takes 2 bytes, so we expect 12 bytes in total
    guard characteristicData.count == 12 else {
        print("Unexpected data length")
        return
    }

    let values: [UInt16] = characteristicData.withUnsafeBytes { bufferPointer -> [UInt16] in
           let count = bufferPointer.count / MemoryLayout<UInt16>.size
           return bufferPointer.bindMemory(to: UInt16.self).prefix(count).compactMap { $0 }
       }

    guard values.count == 6 else {
        print("Data parsing error")
        return
    }
    
    // Update your class values
    value1 = values[0]
    value2 = values[1]
    value3 = values[2]
    value4 = values[3]
    value5 = values[4]
    value6 = values[5]


    // Here you can call any functions to further process these values or update UI
    updateValues(v1: value1, v2: value2, v3: value3, v4: value4, v5: value5, v6: value6)
}
*/

func averageHourConcentration() -> Double {
    var hourAvg = 0
    // check if size is 12
    if averages.count == 12 {
        let sum = averages.reduce(0, +)
        hourAvg = Int(sum/12)
        averages.removeAll()
        return Double(hourAvg)
    }
    
    return -1
    
}

