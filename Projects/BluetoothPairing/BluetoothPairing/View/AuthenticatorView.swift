//
//  AuthenticatorView.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 04/08/25.
//

import SwiftUI

struct AuthenticatorView: View {
    
    @ObservedObject var realmManager: RealmManager
    @ObservedObject var lockTotpService: LockTOTPService
    
    @State private var searchText = ""
    @State var timerProgress: TimeInterval = 60 - TimeInterval(Calendar.current.component(.second, from: Date()))
    @State private var totpCode: String = ""
    
    // setting 0.1 instead of 1 second, cause of the animation is not smooth
    let timer = Timer.publish(every: 0.1, on: .main , in: .common).autoconnect()
    
    var body: some View {
        
        NavigationStack {
            
            ProgressView(value: timerProgress, total: 60)
                .progressViewStyle(.linear)
                .scaleEffect(x: 1, y: 2.5)
                .tint(.green)
            
                .onReceive(timer) { _ in // current time with date is recieved and also in UTC
                    
                    timerProgress -= 0.1
                    
                }
            
            listAuthenticator()
    
        }
        .searchable(text: $searchText)
        
    }
    
    
    private func searchFilter() -> [Authenticator] {
        
        guard !searchText.isEmpty else { return realmManager.getAllAuthenticators() }
        
        let filteredResults = realmManager.getAllAuthenticators().filter {
            $0.name.lowercased().contains(searchText.lowercased())
        }
        
        return filteredResults
        
    }
    
    
    @ViewBuilder
    private func listAuthenticator() -> some View {
        
        List {
            
            ForEach(searchFilter()) { authenticator in
                                
                HStack(spacing: 25) {
                    
                    Image("lock-svgrepo-com")
                        .resizable()
                        .frame(width: 32, height: 32)
                    
                    
                    VStack(alignment: .leading ,spacing: 10) {
                        
                        Text(totpCode)
                            .font(Font.custom("ArialRoundedMTBold", size: 25))
                            .foregroundStyle(.primary)
                        
                        VStack(alignment: .leading, spacing: 5) {
                         
                            Text(authenticator.name)
                                .font(Font.custom("Monaco", size: 17.5))
                                .foregroundStyle(.secondary)
                            
                            Text(authenticator.macAddress)
                                .font(Font.custom("Monaco", size: 15))
                                .foregroundStyle(.secondary)
                        }
                        
                    }
                    
                    .onReceive(timer) { _ in
                            
                        lockTotpService.generateTOTP(code: authenticator.name, pass: authenticator.macAddress)
                        
                    }
                    
                    .onChange(of: lockTotpService.totpCode) { old, new in
                        
                        if new != old{
                            totpCode = lockTotpService.totpCode
                            
                            if !old.isEmpty {
                                timerProgress = 60 // resseting timer here
                            }
                        }
                        
                    }
                    
                }
                
            }
            
        }
        .listRowSpacing(10)
        .scrollBounceBehavior(.basedOnSize)
        .scrollIndicators(.hidden)
        
        .navigationTitle("Ble-Authenticator")
        .navigationBarTitleDisplayMode(.large)
        
    }
    
}

#Preview {
//    AuthenticatorView()
}
