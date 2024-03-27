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
    static let UVChar_UUID = "d421e927-9aad-488d-830e-2302b1698432"

    static let statusService_UUID = "64f6bc2a-88e6-4fbe-83cd-2c109a1998ca"
    static let appStatusChar_UUID = "9200dc4d-e3d0-41be-8385-9a1e74540057"
    static let batteryService_UUID = "180F"
    static let batteryChar_UUID = "2A19"
    
    
    static let AQIService = CBUUID(string: AQIService_UUID)
    static let AQIChar = CBUUID(string: AQIChar_UUID)
    
    static let UVChar = CBUUID(string: UVChar_UUID)
    
    static let statusService = CBUUID(string: statusService_UUID)
    static let appStatusChar = CBUUID(string: appStatusChar_UUID)
    
    static let batteryService = CBUUID(string: batteryService_UUID)
    static let batteryChar = CBUUID(string: batteryChar_UUID)
}
