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




// ensures serial execution for updating concentration values
let serialQueue = DispatchQueue(label: "com.yourapp.PollutantSerialQueue")

func parseCharacteristic(characteristic: CBCharacteristic) {
    var values: [UInt16] = []
    guard let characteristicData = characteristic.value, characteristicData.count == 12 else { return }
    
    for i in stride(from: 0, to: 12, by: 2) {
        values.append((UInt16(characteristicData[i]) << 8) | UInt16(characteristicData[i + 1]))
    }
    
    //print("Successfully parsed!")
    //print(values)
    
    updateValues(v1: values[0], v2: values[1], v3: values[2], v4: values[3], v5: values[4], v6: values[5])
}


func updateValues(v1: UInt16, v2: UInt16, v3: UInt16, v4: UInt16, v5: UInt16, v6: UInt16) {
    serialQueue.async {
        pm1.setConcentration(for: Int(v1))
        pm2_5.setConcentration(for: Int(v2))
        pm10.setConcentration(for: Int(v3))
        voc.setConcentration(for: Int(v4))
        co2.setConcentration(for: Int(v5))
        co.setConcentration(for: Int(v6))
        paqr.setValue()
        //uv!.setIndoorIndex(index: Double(v6))
        
        PollutantManager.shared.saveAll()
        
    }
    
    scheduleNotification()
}




