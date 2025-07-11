//
//  BluetoothService.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 11/07/25.
//


// iOS apps only have visibility of BLE devices through Core Bluetooth. In general apps cannot discover or work with classic Bluetooth devices; The exception being MFi Bluetooth devices that are registered against your specific app
// is why the name of BLE devices only printed
// well UNLESS you advertise with nrf connect app, all moderen phone can act as BLE device so



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
    
    var peripheralsList: [CBPeripheral] = []
    
    // This CBUUID is defined by Bluetooth standards by SIG,
    // for example for aa15 search it's UUID value / use LightBlue to see the serivces
    let targetPeripheralService: CBUUID = CBUUID(string: "0000AFAF-0000-1000-8000-00805f9b34fb")
//    let targetPeripheralCharacteristic: CBUUID = CBUUID(string: "")
    
    @Published var connectionStatus: BluetoothStatus = .disconnected
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
    }
    
    
    func searchDevices() {
        connectionStatus = .searching
        centralManager.scanForPeripherals(withServices: nil)
        // so uhh Peripherals usually exihibut services and characteristics, and we use protocol, GATT is for reading, heart rate is a service under this characterisitcs will be bpm, nil here indicates no particular services we looking for on searching
    }
    
    
    func listDevices() -> [CBPeripheral] {
        return peripheralsList
    }
    
    func pairDevice(_ peripheral: CBPeripheral) {
       
        targetPeripheral = peripheral
        centralManager.connect(targetPeripheral!)
        connectionStatus = .pairing
        
    }
    
}


// extension is for splitting specific fucnctionality, more readabilty
extension BluetoothService: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        
//        if central.state == .poweredOn {
//            searchDevices()
//            
//        }
        
    }
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        let peripheral_name: String = peripheral.name ?? ""
        
        if !peripheral_name.isEmpty {
            peripheralsList.append(peripheral)
        }
        
        
        
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        connectionStatus = .connected
        print("Connected \(peripheral.name ?? "")")
        
        peripheral.delegate = self
        peripheral.discoverServices([targetPeripheralService]) // find id with help of nrf app, after paired
        centralManager.stopScan()
    }
    
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: (any Error)?) {
        connectionStatus = .disconnected
    }
    
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: (any Error)?) {
        
        connectionStatus = .error
        print(error?.localizedDescription ?? "Can't read error")
    }
    
}



// Now, Peripheral part (server)
extension BluetoothService: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: (any Error)?) {
        for service in peripheral.services ?? [] {
            if service.uuid == targetPeripheralService {
                peripheral.discoverCharacteristics([], for: service)
               
            }
        }
    }
        
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
        for characteristic in service.characteristics ?? [] {
            print(characteristic)
        }
        
    }
        
}
