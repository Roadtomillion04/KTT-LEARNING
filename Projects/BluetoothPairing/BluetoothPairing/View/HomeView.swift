//
//  ContentView.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 09/07/25.
//

import SwiftUI


struct HomeView: View {
    
    // sending the @StateObject from @main as Observed or Environment object
    
    @ObservedObject var bluetoothService: BluetoothService
    @ObservedObject var realmManager: RealmManager
    
    @State private var command: String = ""
    
    @State private var selectedPeripheral: PairedPeripherals?
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationStack {
            
            VStack(alignment: .leading, spacing: 25) {
            
                HStack(spacing: 25) {
                    
                    Button(action: {  }) {
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .tint(.primary)
                    }
                    
                    Text("BLE-Connect")
                        .font(Font.custom("Georgia", size: 20))
                        .bold()
                    
                    
                    Spacer()
                    
                    NavigationLink(destination: pairDeviceContent()) {
                        Text("PAIR DEVICE")
                            .font(Font.custom("Monaco", size: 15))
                            .tint(.primary) // tint is for coloring NavigationStack, foregroundStyle no work
                        
                    }
                    
                    Menu("⋮") {
                        Button("Unpair All Devices") {
                            
                        }
                        
                        Button("Bluetooth Settings") {
                            
                        }
                        
                        Button("About") {
                            
                        }
                        
                        Button("Logout") {
                            
                            realmManager.loggoutCurrentUser()
                            
                        }
                        
                    }
                    .font(Font.custom("Monaco", size: 20))
                    .bold()
                    .tint(.primary)
                    
                }
                
                
                VStack {
                    // should be saying connect if bluetooth off
                    Text("PAIRED DEVICES")
                        .font(Font.custom("Monaco", size: 25))
                        .foregroundStyle(.secondary)
                        
                }
                
                
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 100)
    
//            .background(RoundedRectangle(cornerRadius: 5).fill(.white).shadow(radius: 2).ignoresSafeArea())
//            
            
            pairedDevicesContent()
            
            
            Spacer() // push to top, default they align in center
        }
        
    }
    
    
    @ViewBuilder // also can be shown with NavigationLink, very flexible
    private func pairDeviceContent() -> some View {

        VStack {
            
            // let's just stick with forever searching route, could have used timer but oh well
            
            ProgressView()
                .controlSize(.large)
        
            
            List {
                
                ForEach(bluetoothService.listDevices(), id: \.self) { peripheral in
                    
                    HStack(spacing: 20) {
                        
                        Image("lock-svgrepo-com")
                            .resizable()
                            .frame(width: 32, height: 32)
                        
                        
                        VStack(alignment: .leading ,spacing: 10) {
                            Text(peripheral.name!)
                                .font(Font.custom("Monaco", size: 20))
                                .foregroundStyle(.primary)
                            
                        }
                        
                        Spacer()
                        
                        Button(">") {
                            bluetoothService.pairDevice(peripheral)
//                            bluetoothService.command = command
                            
                            realmManager.addPeripheral(name: peripheral.name ?? "", UUID: peripheral.identifier.uuidString)
                            
                            dismiss()
                            
                        }
                        .font(Font.custom("Georgia", size: 25))
                        .tint(.primary)
                        
                    }
                    .padding(.horizontal, 4)
                    .padding(.vertical)
                    
                }
                
            }
            .scrollIndicators(.hidden)
            .listRowSpacing(15)
            .shadow(radius: 1)
            
            .navigationTitle("Pair New Device") // only unstyled text can be used here, warning say
            
        }
        .onAppear {
            bluetoothService.searchDevices()
        }
        
        .onDisappear {
            bluetoothService.stop()
        }
        
        Spacer()
        
    }
    
    
    @ViewBuilder
    private func pairedDevicesContent() -> some View {
        
        List {
            
            ForEach(realmManager.pairedPeripheralList, id: \._id) { peripheral in
                
                HStack(spacing: 20) {
                    
                    Image("lock-svgrepo-com")
                        .resizable()
                        .frame(width: 32, height: 32)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Text(peripheral.peripheralName)
                            .font(Font.custom("Monaco", size: 20))
                            .foregroundStyle(.primary)
                        
                    }
 
                    Spacer()
                   
                    Button(">") {
                        selectedPeripheral = peripheral
                    }
                    .font(Font.custom("Georgia", size: 25))
                    .tint(.primary)
                    
                                        
                }
                .padding(.horizontal, 4)
                .padding(.vertical)
                
            }
            .sheet(item: $selectedPeripheral) { peripheral in
                selectedDeviceContent()
            }
            
        }
        .listRowSpacing(15)
        .shadow(radius: 1)
        
    }
    
    
    @ViewBuilder
    private func selectedDeviceContent() -> some View {
        
        VStack {
            
            Spacer()
            
            HStack {
                TextField("", text: $command)
                
                Button(action: {
                    bluetoothService.command = command
                    bluetoothService.custom_connect(peripheralUUID: selectedPeripheral?.peripheralUUID ?? "")}) {
                    Image(systemName: "paperplane")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
            }
            .background(.gray)
            
        }
                
    }
    
}

#Preview {
//    ContentView()
}
