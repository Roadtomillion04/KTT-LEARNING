//
//  BluetoothPairingApp.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 09/07/25.
//

import SwiftUI

// note: for sharing variables/properties -> Binding
// for classes -> ObservedObject/EnvironmentObject

@main
struct BluetoothPairingApp: App {
    
    @StateObject var bluetoothService: BluetoothService = BluetoothService()
    @StateObject var realmManager: RealmManager = RealmManager()

    
    var body: some Scene {
        
        WindowGroup {
            
            // only one user can be logged in, so as more user will be created in Realm, check for login==true state
                        
            if realmManager.currentUser?.loginStatus == true  {
                
                HomeView(bluetoothService: bluetoothService, realmManager: realmManager)
                
            }
            
            else {
                
                LoginView(realmManager: realmManager)
                
            }
        }
    }
}
