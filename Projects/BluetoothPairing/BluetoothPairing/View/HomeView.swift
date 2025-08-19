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
    @ObservedObject var userActionLogService: UserActionLogService
    
    @State private var showAbout: Bool = false
    @State private var showSideMenu: Bool = false
    @State private var menuIsShowing: Bool = false
    @State private var bluetoohEnabledStatus: String?
    
    @State private var path = NavigationPath()
    
    let sideMenuView: SideMenuView = SideMenuView()
 
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        
        NavigationStack(path: $path) {
            
            VStack(alignment: .leading, spacing: 25) {
                
                HStack(spacing: 25) {
                    
                    Button(action: { showSideMenu.toggle() }) {
                        Image(systemName: "line.3.horizontal")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .tint(.primary)
                    }
                    
                    Text("BLE-Connect")
                        .font(Font.custom("Georgia", size: 20))
                        .bold()
                    
                    
                    Spacer()
                    
//                    if userActionLogService.isConnected {
//                        Image(systemName: "wifi")
//                            .resizable()
//                            .frame(width: 25, height: 18)
//                            .tint(.primary)
//                    } else {
//                        Image(systemName: "wifi.slash")
//                            .resizable()
//                            .frame(width: 25, height: 18)
//                            .tint(.secondary)
//                    }
                    
                    
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
                    
                    Text(bluetoohEnabledStatus ?? "")
                        .font(Font.custom("Monaco", size: 20))
                        .tint(.primary)
                        
                        .onChange(of: bluetoothService.bluetoothIsDisabled) { old, new in
                            
                            switch new {
                                
                                case true:
                                    bluetoohEnabledStatus = "BLUETOOH IS DISABLED"
                                
                                case false:
                                    bluetoohEnabledStatus = "PAIR DEVICE"
                                
                                default:
                                    break
                            }
                        }
                    
                    
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

            
            pairDeviceContent()
            
        }
        
        .onReceive(userActionLogService.$isResponseSuccess) { success in
            
            if success {
                
                realmManager.deleteAllUserActionLog()
                
                userActionLogService.isResponseSuccess = false
                
            }
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
                    
                    userActionLogService.checkReachability(logs: realmManager.getUserActionLog())
                }
               
            }
            
            // is the only way if you don't want to give up the Button, and also this handles complex Navigation very well
            .navigationDestination(for: String.self) { paths in
                
                switch paths {
                    
                    case "CommandSendingView":
                    
                        CommandSendingView(path: $path, bluetoothService: bluetoothService, notificationService: notificationService, lockTotpService: lockTotpService, realmManager: realmManager, userActionLogService: userActionLogService)
                    
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
            
            userActionLogService.checkReachability(logs: realmManager.getUserActionLog())
            
        }
        
        
        .onChange(of: scenePhase) { old, new in
            
            switch new {
                
                case .active:
                    // let's check for network scenePhase active and onDissapear(Logout, in case of autoconnect), List refreshing and when commandSent to store or post/ depending on network availability, also in commandSending view
                
                    userActionLogService.checkReachability(logs: realmManager.getUserActionLog())

                
                default:
                    break
                
            }
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
    @ObservedObject var lockTotpService: LockTOTPService
    @ObservedObject var realmManager: RealmManager
    @ObservedObject var userActionLogService: UserActionLogService
    
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
    
    
    @State private var lockOTPSheetIsPresented: Bool = false
    @State private var lockOTP: String = ""
    @State private var lockOTPVerified: Bool = false

    
    var body: some View {
            
        VStack {

            List {
                
                // for enumerated, Hashable protcol need to be conformed
                ForEach(Array(commandExecutionResult.enumerated()), id: \.element) { index, execution in
                    
                    HStack {
                        
                        Text("\(index + 1)")
                            .font(Font.custom("ArialRoundedMTBold", size: 15))

                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Text("Command: \(execution.command)")
                                .font(Font.custom("", size: 17.5))
                            
                            Text("Output: \(execution.result ?? "")")
                                .font(Font.custom("", size: 17.5))
                            
                        }
                        
                    }

                }
                
            }
            .listRowSpacing(15)
            .scrollIndicators(.hidden)

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
        .opacity(lockOTPSheetIsPresented ? 0.5 : 1)
        
        
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
                
                if lockOTPSheetIsPresented {
                    lockOTPSheetIsPresented = false
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { // slight delay make it work
                    showStatusAlert = true
                }
                
            case .error:
                connectionStatus = .failed
                
                if lockOTPSheetIsPresented {
                    lockOTPSheetIsPresented = false
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    showStatusAlert = true
                }
                
            }
            
        }
        
        .alert(isPresented: $showStatusAlert) {
            
            switch connectionStatus {
                
            case .successful:
                Alert(title: Text("Connection Successful"), message: Text("Connected to the device"), dismissButton: .default(Text("OK")) { showStatusAlert = false; lockOTPSheetIsPresented = true })   // after the dismissal, let's pop up the lockOTP sheet
                
            case .disconnected:
                Alert(title: Text("Connection Interupted"), message: Text("Device is disconnected"), dismissButton: .default(Text("OK")) { dismiss(); showStatusAlert = false })
                
            case .failed:
                Alert(title: Text("Connection Failed"), message: Text("Cannot connect to the device"), dismissButton: .default(Text("OK")) { dismiss(); showStatusAlert = false })
                
            case .none:
                Alert(title: Text("Device not Found"), message: Text("Please try again"), dismissButton: .default(Text("OK")) { dismiss(); showStatusAlert = false })
                
            }
            
        }
        
//                .onSubmit {
//                    // which is on return press in keyboard
//                    commandSubmitAction()
//                }
        
        
        .sheet(isPresented: $lockOTPSheetIsPresented) {
            lockOTPEnterView()
                .presentationDetents([.medium])
                .interactiveDismissDisabled()
            
                .animation(.easeInOut(duration: 1), value: lockOTPSheetIsPresented)
        }
    
        
        .onAppear {
            // okay, wait for 5 sec, if no connection successful, must be peripheral is turned off and the list is not refreshed case
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                if connectionStatus == .none {
                    showStatusAlert = true
                }
            }
        }
        
        
        // scencePhase .background calls when user move to home screen while app running, also by default notification pop up when app on background
        .onChange(of: scenePhase) { old, new in
            
            switch new {
                
            case .active:
                userActionLogService.checkReachability(logs: realmManager.getUserActionLog()) // case if user exit app and turn internet on and open app from background or quick settings/control center
            
                
            case .background:
                // push if notification allowed in the phone
                if notificationService.checkNotificationEnabled() {
                    // let's trigger the notification implying bluetooth is connected
                    notificationService.pushNotification(peripheralName: bluetoothService.targetPeripheral?.name ?? "")
                }
                
            default:
                break
                
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

        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25)  // let's block so that write function is called
        {
            commandExecutionResult.append(
                .init(id: UUID(), command: commandText, result: bluetoothService.commandExecutionResult))
            
            commandText.removeAll() // clearing input, qol?
            
        }
        
        // actually just logging every time and posting if network available, no such thing as posting directly without logging is implemented, realm is fast anyway so shouldn't be issue
        realmManager.createUserActionLog(macAddress: "00:00:00:00:00:00")
        
        userActionLogService.checkReachability(logs: realmManager.getUserActionLog())
    
    }
    
    
    @ViewBuilder
    private func lockOTPEnterView() -> some View {
        
        VStack(spacing: 25) {
            
            Text("Connected to \(bluetoothService.targetPeripheral?.name ?? "")")
                .font(Font.custom("Monaco", size: 18))
            
            Text("Verify OTP")
                .font(Font.custom("Monaco", size: 18))
            
            TextField("", text: $lockOTP)
                .foregroundStyle(.black)
                .keyboardType(.numberPad)
                .textContentType(.telephoneNumber)
                .background(RoundedRectangle(cornerRadius: 5).fill(Color(hex: 0xF1F5F9)).shadow(radius: 1))
                .font(Font.custom("Monaco", size: 18))
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .frame(width: 72) // 18 * 4 digits;
            
                .onChange(of: lockOTP) { old, new in
                    lockOTP = String(new.prefix(4))
                }
            
            
            HStack {

                Button("Back") {
                    lockOTPSheetIsPresented = false
                    
                    dismiss()
                }
                .padding(.horizontal)
                
                Button("Submit") {
                    lockOTPVerified = lockTotpService.verifyTOTP(name: bluetoothService.targetPeripheral?.name ?? "", otp: lockOTP) // elock name and mac go here
                    
                    if lockOTPVerified {
                        lockOTPSheetIsPresented = false // dismiss the sheet, if lockOTP is correct
                    }
                    
                }
                .foregroundStyle(.white)
                .font(Font.custom("Georgia", size: 16))
                .padding(7.5)
                .background(RoundedRectangle(cornerRadius: 5).fill(Color.blue).shadow(radius: 1))
                
            }
            .padding(.horizontal)
        }
        
    }
    
}

#Preview {
//    ContentView()
}
