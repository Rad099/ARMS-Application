//
//  ParseAQI.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/4/24.
//  Used for parsing Bluetooth Characteristic
//  holding all AQI/UVI values and storing in classes
//

import Foundation
import CoreBluetooth

var uv: UV?
var user: User?
var progressData = ProgressData()



func parseCharacteristic(characteristic: CBCharacteristic) {
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

    // Manually reconstruct each UInt16 from two bytes
    value1 = (UInt16(characteristicData[0]) << 8) | UInt16(characteristicData[1])
    value2 = (UInt16(characteristicData[2]) << 8) | UInt16(characteristicData[3])
    value3 = (UInt16(characteristicData[4]) << 8) | UInt16(characteristicData[5])
    value4 = (UInt16(characteristicData[6]) << 8) | UInt16(characteristicData[7])
    value5 = (UInt16(characteristicData[8]) << 8) | UInt16(characteristicData[9])
    value6 = (UInt16(characteristicData[10]) << 8) | UInt16(characteristicData[11])

    print("Successfully parsed!")
    print("\(value1) - \(value2) - \(value3) - \(value4) - \(value5) - \(value6)")

    // Here you can call any functions to further process these values or update UI
    updateValues(v1: value1, v2: value2, v3: value3, v4: value4, v5: value5, v6: value6)
}


func updateValues(v1: UInt16, v2: UInt16, v3: UInt16, v4: UInt16, v5: UInt16, v6: UInt16) {
    print("updating values")
    pm1.setConcentration(for: Int(v1))
    pm2_5.setConcentration(for: Int(v2))
    pm10.setConcentration(for: Int(v3))
    voc.setConcentration(for: Int(v4))
    co.setConcentration(for: Int(v5))
    co2.setConcentration(for: Int(v6))
    progressData.setProgressValue(to: Float(v3))
    //uv!.setIndoorIndex(index: Double(v6))
}




