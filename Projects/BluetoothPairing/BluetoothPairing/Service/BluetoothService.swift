//
//  BluetoothService.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 11/07/25.
//


// iOS apps only have visibility of BLE devices through Core Bluetooth. In general apps cannot discover or work with classic Bluetooth devices; The exception being MFi Bluetooth devices that are registered against your specific app
// is why the name of BLE devices only printed
// well UNLESS you advertise with nrf connect app, all moderen phone can act as BLE device so yeah


import CoreBluetooth


enum BluetoothStatus {
    case searching
    case pairing
    case connected
    case disconnected
    case error
}


// NSObject is used because we are calling some old api
class BluetoothService: NSObject, ObservableObject {
    
    var centralManager: CBCentralManager!
    
    var targetPeripheral: CBPeripheral?
    
    // okay so Publish refresh the view when changed real time, so it works as intended in my view
    @Published var peripheralsList: [CBPeripheral] = []

    var commandExecutionResult: String = ""
    
    var peripheralSubscribedCharacteristics: [CBCharacteristic] = []
    
    // This CBUUID is defined by Bluetooth standards by SIG,
    // for example for aa15 search it's UUID value / use LightBlue/nrfConnect to see the serivces
//    let targetPeripheralService: CBUUID = CBUUID(string: "49535343-FE7D-4AE5-8FA9-9FAFD205E455")
    
    // this is the characteristic that is executing commands
    let targetPeripheralCharacteristic: CBUUID = CBUUID(string: "49535343-1E4D-4BD9-BA61-23C647249616")
    
    @Published var connectionStatus: BluetoothStatus = .disconnected
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue.main)
        
    }
    
    func searchDevices() {
        connectionStatus = .searching // commented for case .none in HomeView
        centralManager.scanForPeripherals(withServices: [], options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        // so uhh Peripherals usually exihibut services and characteristics, and we use protocol, GATT is for reading, heart rate is a service under this characterisitcs will be bpm, nil here indicates no particular services we looking for on searching
    }
    
    
    func listDevices() -> [CBPeripheral] {
        return peripheralsList
    }
    
    func pairDevice(_ peripheral: CBPeripheral) {
       
        targetPeripheral = peripheral
        centralManager.connect(targetPeripheral!)
        
    }
    
    // let's refresh the list on View disappear, sorta fix for disconnection when app is active
    func stop() {
        peripheralsList.removeAll()
        centralManager.stopScan()
    }
    
    func disconnectPeripheral() {
        centralManager.cancelPeripheralConnection(targetPeripheral!)
    }
    
}


// extension is for splitting specific fucnctionality, more readabilty
extension BluetoothService: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
        if central.state == .poweredOn {
            searchDevices()
            
//            centralManager.retrieveConnectedPeripherals(withServices: [])

        }
        
        if central.state == .poweredOff {
            stop()
        }
        
    }
    
    
    // this call when new peripheral found
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        let peripheral_name: String = peripheral.name ?? ""
        
        // using this list has one issue, which is when ble device disconnect on searching, and im not sure how to capture that peripheral to remove that device name from the list
        if !peripheral_name.isEmpty && !peripheralsList.contains(peripheral) /*&& peripheral_name.uppercased().starts(with: "KTT")*/ {
            // filter KTT products only
            peripheralsList.append(peripheral)
        }
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectionStatus = .connected
        
        print("Connected \(peripheral.name ?? ""), \(peripheral.identifier.uuidString)")
        

        peripheral.delegate = self
        peripheral.discoverServices([]) // nil or [], both works
        centralManager.stopScan()
    }
    
  
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        connectionStatus = .disconnected
        
        print(peripheral.name ?? "No name")
        print("is disconnected")
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        
        connectionStatus = .error
//        print(error?.localizedDescription ?? "Can't read error")
        
        // so it's called when pairing is canceled and it's paired with another device
//        peripheralsList.remove(at: peripheralsList.firstIndex(of: peripheral) ?? 0)
        
        print(peripheral.name ?? "no_name")
        print("failed")
    }
    
}


// Now, Peripheral part (server)
extension BluetoothService: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        
        for service in peripheral.services ?? [] {
//            if service.uuid == targetPeripheralService {
                
            peripheral.discoverCharacteristics([], for: service)
//            }
//            print()
//            print(service)
            
        }
        
    }
        
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        for characteristic in service.characteristics ?? [] {
            //            print("")
            //            print(characteristic)
            //            print()
            
            
            // okay, so according to stackoverflow answers, when you try to read Charactersictics value, the bonding happens -> Pairing requests pop up, until that it doesn't
            
            
//            if characteristic.uuid == targetPeripheralCharacteristic {
                
                
                peripheral.setNotifyValue(true, for: characteristic)
            
                
//            }
            
        }
        
    }
    
    
    // for setNotifyValue, this delegate will be triggered
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: (any Error)?) {
        
        if characteristic.properties.contains(.write) && characteristic.isNotifying { // only for the true
        
            print("Subscribed: \(characteristic.uuid)")
            
            if characteristic.uuid == targetPeripheralCharacteristic {
                
                peripheralSubscribedCharacteristics.append(characteristic)
                
            }
            
        }
        
    }
    
    
    func write(commandText: String) {

//        peripheralSubscribedCharacteristics.forEach { characteristic in
            
        targetPeripheral?.writeValue(commandText.data(using: .ascii)!, for: peripheralSubscribedCharacteristics.first!, type: .withResponse)
                
//        }
        
    }
    
    
    // okay so reading in didWriteValueFor produces returned value of all Subscribed characteristics
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: (any Error)?) {
    
//        print("Reading in didWriteValueFor \(characteristic.uuid): \(String(decoding: characteristic.value ?? Data(), as: UTF8.self))")
        
        // 10 Bit ASCII Text Format? mentioned in manual
        
        // okay, so the answer to get this thing working is adding new line or return carrigage at end of each commands
        
        print("out")
        print(characteristic.value ?? Data())
        
    }
    
    
    // and this delegate will be called, when new data arrive from characteristic
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: (any Error)?) {
        
//        print("Reading \(characteristic.uuid): \(String(decoding: characteristic.value ?? Data(), as: UTF8.self))")
        
        print("in")
        print(characteristic.value ?? Data())
        
        commandExecutionResult = String(decoding: characteristic.value ?? Data(), as: UTF8.self)
        
    }
    
}
