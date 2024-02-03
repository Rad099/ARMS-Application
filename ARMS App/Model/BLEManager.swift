//
//  BLEManager.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/7/24.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var uv: UV?
    var pm1: Pollutant?
    var pm2_5: Pollutant?
    var pm10: Pollutant?
    var voc: Pollutant?
    var co: Pollutant?
    //weak var delegate: BLEManagerDelegate?
    var centralManager: CBCentralManager!
    var photon: CBPeripheral!
    var AQIChar: CBCharacteristic!
    
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            print("Bluetooth is powered on")
            centralManager.scanForPeripherals(withServices: [CBUUIDs.AQIService], options: nil)
            
        case .poweredOff:
            print("Bluetooth is powered off")
        default:
            print("Unknown state")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Function: \(#function), Line: \(#line)")
        print("p discovered: \(peripheral)")
        photon = peripheral
        photon.delegate = self
        centralManager?.connect(photon, options: nil)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected to \(peripheral.name ?? "unknown device")")
        photon.discoverServices(nil)
    }
    
    // peripheral
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            print("Discovered service: \(service)")
            peripheral.discoverCharacteristics(nil, for: service)
        }
        
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        for characteristic in characteristics {
            if characteristic.uuid.isEqual(CBUUIDs.AQIChar) {
                AQIChar = characteristic
                peripheral.setNotifyValue(true, for: AQIChar)
                peripheral.readValue(for: AQIChar)
                
                print("AQI Characteristic: \(AQIChar.uuid)")
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
               print("Error: \(error!.localizedDescription)")
               return
           }

        if let data = characteristic.value {
            // Assuming the float is in the first 4 bytes of the 8-byte buffer
            let value = data.withUnsafeBytes { $0.load(as: Int.self) }
            print("Received concentration: \(value)")
            let uvData: Double = Double(value)
            //delegate?.didShareClass()
            
            uv!.setIndoorIndex(index: uvData)
            averages.append(uvData)
            let average = averageHourConcentration()
            if average != -1 {
                uv!.setHourIndex(index: average)
                print("recieved hour")

            }
                
        }

    }
    
}
