//
//  BLEManager.swift
//  ARMS App
//
//  Created by Radwan Alrefai on 1/7/24.
//

import Foundation
import CoreBluetooth
import BackgroundTasks
import UIKit


class BLEManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var photon: CBPeripheral!
    var AQIChar: CBCharacteristic!
    var batteryChar: CBCharacteristic!
    var uvChar: CBCharacteristic!
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var savedPhotonuuid: UUID?
    var appStatusChar: CBCharacteristic!
    static let shared = BLEManager()
    
    var isConnected: Bool = false {
            didSet {
                NotificationCenter.default.post(name: .bleManagerConnectionChanged, object: nil, userInfo: ["isConnected": isConnected])
            }
        }
    
    var batteryLevel: Int = -1 {
        didSet {
            NotificationCenter.default.post(name: .bleManagerBatteryUpdate, object: nil, userInfo: ["batteryUpdate": batteryLevel])
        }
    }
    
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionRestoreIdentifierKey: "myCentralManagerIdentifier"] )
    }
    
    func customLog(_ message: String) {
            #if DEBUG
            print("MyAppDebug: \(message)")
            #endif
    }
    func startScanning() {
        guard centralManager.state == .poweredOn else {
            customLog("Bluetooth is not powered on")
            return
        }
        
        // if let savedUUIDString = UserDefaults.standard.string(forKey: "savedPhotonUUID"),
        //   let uuid = UUID(uuidString: savedUUIDString) {
        // A saved UUID exists, prepare to connect to the device with this UUID
        //   savedPhotonuuid = uuid
    //} else {
            // No saved UUID, scan for devices advertising the specific service
        let serviceUUIDs: [CBUUID]? = [CBUUIDs.AQIService, CBUUIDs.statusService]
            centralManager.scanForPeripherals(withServices: serviceUUIDs, options: [CBCentralManagerScanOptionAllowDuplicatesKey: NSNumber(value: false)])
       // }
    }
    
    private func restartScanning() {
            print("Restarting BLE Scanning")
            centralManager.stopScan()
            startScanning()
        }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            startScanning()
            
        case .poweredOff:
            print("Bluetooth is powered off")
        default:
            print("Unknown state")
        }
    }
    
    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
        // Retrieve the saved UUID string from UserDefaults
        if let savedUUIDString = UserDefaults.standard.string(forKey: "savedPhotonUUID"),
           let savedUUID = UUID(uuidString: savedUUIDString) {
            
            // Handle state restoration
            if let restoredPeripherals = dict[CBCentralManagerRestoredStatePeripheralsKey] as? [CBPeripheral] {
                // Find the peripheral that matches the saved UUID
                if let restoredPhoton = restoredPeripherals.first(where: { $0.identifier == savedUUID }) {
                    photon = restoredPhoton
                    photon.delegate = self
                    
                    // Optionally, if your app logic requires immediate interaction with the peripheral,
                    // you might start by discovering services, reading characteristics, or any other action here.
                    //centralManager?.connect(photon, options: nil)
                }
            }
        }
    }

    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // If scanning for the first time and found a device advertising the AQIService
        if savedPhotonuuid == nil {
            central.stopScan()
        customLog("Discovered Photon advertising AQIService. Connecting...")
            photon = peripheral
            photon.delegate = self
            central.connect(photon, options: nil)
            
            
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        UserDefaults.standard.set(peripheral.identifier.uuidString, forKey: "savedPhotonUUID")
        isConnected = true
        customLog("Connected to \(peripheral.name ?? "unknown device")")
        photon.discoverServices(nil)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnect peripheral: CBPeripheral) {
        isConnected = false
        batteryLevel = -1
        ensureConnectionToPhoton()
    }
    
    func ensureConnectionToPhoton() {
        if photon == nil || photon.state != .connected {
            // Your scanning logic here
            startScanning()
        }
    }

    
    // peripheral
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
           for service in services {
               print("Discovered service: \(service.uuid)")
               if service.uuid == CBUUIDs.AQIService || service.uuid == CBUUIDs.batteryService || service.uuid == CBUUIDs.statusService {
                   peripheral.discoverCharacteristics(nil, for: service)
               }
           }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
            for characteristic in characteristics {
                if service.uuid == CBUUIDs.AQIService && characteristic.uuid.isEqual(CBUUIDs.AQIChar) {
                    AQIChar = characteristic
                    peripheral.setNotifyValue(true, for: AQIChar)
                    peripheral.readValue(for: AQIChar)
                    
                    customLog("AQI Characteristic: \(AQIChar.uuid)")
                } else if service.uuid == CBUUIDs.AQIService && characteristic.uuid.isEqual(CBUUIDs.UVChar) {
                    uvChar = characteristic
                    peripheral.setNotifyValue(true, for: uvChar)
                    peripheral.readValue(for: uvChar)
                    
                    customLog("UV Characeristic")
                    
                } else if service.uuid == CBUUIDs.batteryService && characteristic.uuid.isEqual(CBUUIDs.batteryChar) {
                    batteryChar = characteristic
                    peripheral.setNotifyValue(true, for: batteryChar)
                    peripheral.readValue(for: batteryChar)
                    
                    print("Battery Characteristic: \(batteryChar.uuid)")
                } else if service.uuid == CBUUIDs.statusService && characteristic.uuid.isEqual(CBUUIDs.appStatusChar) {
                    appStatusChar = characteristic
                    customLog("App State Characteristic: \(appStatusChar.uuid)")
                }
            }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
               print("Error: \(error!.localizedDescription)")
               return
           }
        if characteristic == AQIChar {
            customLog("AQI Recieved")
            parseCharacteristic(characteristic: characteristic)
        } else if characteristic == uvChar {
            customLog("UV Recieved")
            parseUV(characteristic: characteristic)
        } else if characteristic == batteryChar {
            batteryLevel = parseBatteryLevel(fromCharacteristic: characteristic)
        }
    }
    
    func updateAppState(isForeground: Bool) {
        guard let appStatusChar = appStatusChar else {
            customLog("App State Characteristic is not discovered yet")
            return
        }
        
        customLog("we are writing to the photon")
        let value: UInt8 = isForeground ? 1 : 0
        let data = Data([value])
        photon.writeValue(data, for: appStatusChar, type: .withoutResponse)
    }
    
    func handleBluetoothDataInBackground(characteristic: CBCharacteristic) {
        backgroundTask = UIApplication.shared.beginBackgroundTask(withName: "UpdatePollutants") {
            // End the task if time expires.
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        }
        
        DispatchQueue.global(qos: .background).async {
            parseCharacteristic(characteristic: characteristic)
        
            UIApplication.shared.endBackgroundTask(self.backgroundTask)
            self.backgroundTask = .invalid
        }
    }
}

extension Notification.Name {
    static let bleManagerConnectionChanged = Notification.Name("isConnected")
    static let bleManagerBatteryUpdate = Notification.Name("batteryUpdate")
}
