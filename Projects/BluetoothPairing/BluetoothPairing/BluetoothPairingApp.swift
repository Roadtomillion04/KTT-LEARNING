//
//  BluetoothPairingApp.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 09/07/25.
//

import SwiftUI

@main
struct BluetoothPairingApp: App {
    
    @StateObject var bluetoothService: BluetoothService = BluetoothService()
    
    var body: some Scene {
        
        WindowGroup {
            
            ContentView(centralManager: bluetoothService)
            
        }
    }
}
