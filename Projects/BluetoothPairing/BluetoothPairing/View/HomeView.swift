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
    @ObservedObject var notificationService: NotificationService
    
    @ObservedObject var lockTotpService: LockTOTPService
    
    @State private var showAbout: Bool = false
    
    @State private var path = NavigationPath()
    
    
    var body: some View {
        
        NavigationStack(path: $path) {
            
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
                    

                    Menu("⋮") {
                        
                        Button("About") {
                            showAbout.toggle()
                        }
                        
                        Button("Logout") {
                            realmManager.loggoutCurrentUser()
                        }
                        
                    }
                    .font(Font.custom("Monaco", size: 25))
                    .bold()
                    .tint(.primary)

                    
                    .alert(isPresented: $showAbout) {
                        Alert(title: Text("BLE-Connect"), message: Text("Build 1.0"))
                    }
                    
                }
                
                HStack {
                    
                    Text("PAIR DEVICE")
                        .font(Font.custom("Monaco", size: 25))
                        .tint(.primary)
                    
                    Spacer()
                    
                    // this will act as animation on updating list
                    Text("\(bluetoothService.peripheralsList.count) devices")
                        .font(Font.custom("Georgia", size: 15))
                        .foregroundStyle(.black)
                    
                }
                
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            
            //            .background(RoundedRectangle(cornerRadius: 5).fill(.white).shadow(radius: 2).ignoresSafeArea())
            //
            
            pairDeviceContent()
            
        }
        
    }
    
    
    @ViewBuilder // also can be shown with NavigationLink, very flexible
    private func pairDeviceContent() -> some View {
        
        VStack {
            
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
                            path.append("CommandSendingView")
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
            .shadow(radius: 2)
            
            .refreshable {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    bluetoothService.stop()
                    bluetoothService.searchDevices()
                }
               
            }
            
            // is the only way if you don't want to give up the Button, and also this handles complex Navigation very well
            .navigationDestination(for: String.self) { paths in
                switch paths {
                    case "CommandSendingView":
                        CommandSendingView(path: $path, bluetoothService: bluetoothService, notificationService: notificationService)
                    
                    default:
                        Text("")
                }
            }
            
        }
        
        .onAppear {
            // let's just stick with forever searching route, could have used timer but oh well
            
            bluetoothService.searchDevices()
            
            
        }
      
        .onDisappear {

            bluetoothService.stop()
        }
        
    }
    
}


struct CommandExecution: Identifiable, Hashable {
    
    var id: UUID
    var command: String
    var result: String?
    
}

    
// can't add properties/variables in Viewbuild func, so created new View
struct CommandSendingView: View  {
    
    @Binding var path: NavigationPath
    
    @ObservedObject var bluetoothService: BluetoothService
    @ObservedObject var notificationService: NotificationService
    
    @State private var commandText: String = ""
    
    @State private var commandExecutionResult: [CommandExecution] = []
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.scenePhase) var scenePhase
    
    @State private var showStatusAlert: Bool = false
    
    enum ConnectionStatus {
        case successful
        case failed
        case disconnected
        case none
    }
    
    @State private var connectionStatus: ConnectionStatus = .none
    
    var body: some View {
            
        VStack {
            
//            ScrollViewReader { proxy in
                
            List {
                
                // for enumerated, Hashable protcol need to be conformed
                ForEach(Array(commandExecutionResult.enumerated()), id: \.element) { index, execution in
                    
                    HStack {
                        
                        Text("\(index + 1)")
                            .font(Font.custom("Monaco", size: 15))

                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text("Command: \(execution.command)")
                                .font(Font.custom("", size: 17.5))
                            
                            Text("Output: \(execution.result ?? "")")
                                .font(Font.custom("", size: 17.5))
                            
                        }
                        
                    }
//                        .id(commandExecutionResult.count + 1)
                    
                }
                
            }
            .listRowSpacing(15)
            .scrollIndicators(.hidden)
            
//                .onChange(of: commandExecutionResult.count) { old, new in
//                    proxy.scrollTo(new + 1)
//
//                }
            
            .scrollDismissesKeyboard(.immediately)
            
            // also styling cannot be added to naviagtion title
            .navigationTitle(bluetoothService.targetPeripheral?.name ?? "")
            
        
            Spacer()
            
            HStack {
                
                TextField("", text: $commandText)
                    .font(Font.custom("Monaco", size: 25))
                    .foregroundStyle(.black)
                    .autocorrectionDisabled()
                
                
                Button(action: commandSubmitAction) {
                    Image(systemName: "paperplane")
                        .resizable()
                        .frame(width: 48, height: 48)
                        .foregroundStyle(.black)
                }
                .disabled(commandText.isEmpty)
                
            }
            .safeAreaPadding(.all)
            .background(RoundedRectangle(cornerRadius: 15).fill(Color(hex: 0xF1F5F9)).shadow(radius: 2))
            
        }
        .padding(.horizontal)
        
        
        .onChange(of: bluetoothService.connectionStatus) { old, new in
            
            switch new {
                
            case .searching:
                break
                
            case .pairing:
                break
                
            case .connected:
                connectionStatus = .successful
                showStatusAlert = true
                
            case .disconnected:
                connectionStatus = .disconnected
                showStatusAlert = true
                
            case .error:
                connectionStatus = .failed
                showStatusAlert = true
                
            }
            
        }
        
        .alert(isPresented: $showStatusAlert) {
            
            switch connectionStatus {
                
            case .successful:
                Alert(title: Text("Connection Successful"), message: Text("Connected to the device"), dismissButton: .default(Text("OK")) { showStatusAlert = false })
                
            case .disconnected:
                Alert(title: Text("Connection Interupted"), message: Text("Device is disconnected"), dismissButton: .default(Text("OK")) { dismiss(); showStatusAlert = false })
                
            case .failed:
                Alert(title: Text("Connection Failed"), message: Text("Cannot connect to the device"), dismissButton: .default(Text("OK")) { dismiss(); showStatusAlert = false })
                
            case .none:
                Alert(title: Text("Device not Found"), message: Text("Please try again"), dismissButton: .default(Text("OK")) { dismiss(); showStatusAlert = false })
                
            }
            
        }
        
        //        .onSubmit {
        //            // which is on return press in keyboard
        //            commandSubmitAction()
        //        }
        
        .onAppear {
            // okay, wait for 5 sec, if no connection successful, must be peripheral is turned off and the list is not refreshed case
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if connectionStatus == .none {
                    showStatusAlert = true
                }
                
                print("mu")
                print(bluetoothService.centralManager.retrieveConnectedPeripherals(withServices: []))
                    
            }
        }
        
        
        // scencePhase .background calls when user move to home screen while app running, also by default notification pop up when app on background
        .onChange(of: scenePhase) { old, new in
            
//            if new == .active {
//                notificationService.checkAuthorization()
//            }
            
            if new == .background {
                // push if notification allowed in the phone
                if notificationService.checkNotificationEnabled() {
                    // let's trigger the notification implying bluetooth is connected
                    notificationService.pushNotification(peripheralName: bluetoothService.targetPeripheral?.name ?? "")
                }
            }
        }
        
        
        .onDisappear { // let's disconnect on going back, otherwise peripheral stay connected and no visible in search
            bluetoothService.disconnectPeripheral()
            
            // and clean up the commands
            commandText.removeAll()
            commandExecutionResult.removeAll()
            bluetoothService.peripheralSubscribedCharacteristics.removeAll()
            bluetoothService.commandExecutionResult = ""
            
        }
    
    }
    
    
    private func commandSubmitAction() {
        
        bluetoothService.commandExecutionResult = ""
        
        bluetoothService.write(commandText: commandText + "\n")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25)  // let's block to write function is called
        {
            commandExecutionResult.append(
                .init(id: UUID(), command: commandText, result: bluetoothService.commandExecutionResult))
            
            commandText.removeAll() // clearing input, qol?
            
        }
        
    }
    
}

#Preview {
//    ContentView()
}
