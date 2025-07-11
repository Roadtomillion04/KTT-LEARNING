//
//  ContentView.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 09/07/25.
//

import SwiftUI




struct ContentView: View {
    
    // sending the @StateObject from @main as Observed or Environment object
    
    @ObservedObject var centralManager: BluetoothService
    
    @State private var show_peripheral_list: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            ScrollView {
                
                VStack {
                    
                    Button(action: {
                        centralManager.searchDevices(); show_peripheral_list.toggle() }) {
                            Text("Search Devices")
                        }
                    
                    if show_peripheral_list {
                        ForEach(centralManager.listDevices(), id: \.self) { peripheral in
                            
                            HStack {
                                Text(peripheral.name!)
                                
                                Spacer()
                                
                                Button("Pair") {
                                    centralManager.pairDevice(peripheral)
                                }
                            }
                            .padding(.horizontal)
                            
                        }
                        
                    }
                    
                }
            }
        }
        
    }
}

#Preview {
//    ContentView()
}
