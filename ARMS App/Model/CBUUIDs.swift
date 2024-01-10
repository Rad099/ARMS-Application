//
//  CBUUIDs.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 12/31/23.
//

import Foundation
import CoreBluetooth

enum CBUUIDs {
    static let AQIService_UUID = "38bdd4ec-fee9-4e99-b045-a3911a7171cd"
    static let AQIChar_UUID = "d6eedc89-58c6-4d64-8120-f31737032cd0"
    static let ThresholdService_UUID = ""
    static let ThresholdChar_UUID = ""
    static let statusSerice_UUID = ""
    static let statusChar_UUID = ""
    
    
    static let AQIService = CBUUID(string: AQIService_UUID)
    static let AQIChar = CBUUID(string: AQIChar_UUID)
    static let ThresholdService = CBUUID(string: ThresholdService_UUID)
    static let statusService = CBUUID(string: statusSerice_UUID)
    static let statusChar = CBUUID(string: statusChar_UUID)
}
