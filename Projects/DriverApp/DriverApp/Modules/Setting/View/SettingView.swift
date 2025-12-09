//
//  SettingsView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 01/09/25.
//

import SwiftUI
import UIKit


struct SettingView: View {
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var apiService: APIService
    
    @Environment(\.openURL) var openURL
    
    @State var showLogoutAlert: Bool = false
    
    var body: some View {
           
        VStack(alignment: .center) {
       
            List {
                
                Section {
                    
                    Button {
                        coordinator.push(.setting(.profile))
                    } label: {
                        
                        HStack(spacing: 15) {
                            
                            AsyncImage(url: URL(string: apiService.driverStatusModel.driver?.photoURL ?? "")) { image in
                                
                                image
                                    .profileImage()
                                
                                
                            } placeholder: {
                              Circle().fill(.thinMaterial)
                            }
                            .frame(width: 64, height: 64)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                
                                Text(apiService.driverStatusModel.driver?.name ?? "Name")
                                    .font(Font.custom("ArialRoundedMTBold", size: 15))
                                
                                Text(apiService.driverStatusModel.driver?.phone1 ?? "Number")
                                    .font(Font.custom("ArialRoundedMTBold", size: 12.5))
                                    .foregroundStyle(.secondary)
                                
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.forward")
                                .font(.title3)
                            
                        }
                        
                    }
                }
                
                
                Button {
                    coordinator.push(.setting(.leaveRequest))
                } label: {
                    buttonContent(systemName: "pencil.and.list.clipboard", text: LocalizedStringResource("leave_request"))
                        
                }
                .listRowSeparator(.hidden)
                
                
                Button {
                    coordinator.push(.setting(.leaveHistory))
                } label: {
                    buttonContent(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90", text: LocalizedStringResource("leave_history_list"))
                        
                }
                .listRowSeparator(.hidden)

                
                Button {
                    coordinator.push(.setting(.tripSettlement))
                } label: {
                    buttonContent(systemName: "dollarsign.circle.fill", text: LocalizedStringResource("trip_settlement"))
                        
                }
                .listRowSeparator(.hidden)
                
                
                Button {
                    coordinator.push(.setting(.documents))
                } label: {
                    buttonContent(systemName: "folder", text: LocalizedStringResource("documents"))
                        
                }
                .listRowSeparator(.hidden)
                
                
                Button {
                    coordinator.push(.setting(.attendance(.attendance)))
                } label: {
                    buttonContent(systemName: "person.crop.circle.badge.checkmark.fill", text: LocalizedStringResource("mattendance"))
                }
                .listRowSeparator(.hidden)
                
                // Firebase integration
//                Section {
//                    
//                    Button {
//                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
//                    } label: {
//                        buttonContent(systemName: "bell.fill", text: LocalizedStringResource("notifications"))
//                    }
//                    
//                    
//                } header: {
//                    Text(LocalizedStringResource("notifications"))
//                        .font(Font.custom("ArialRoundedMTBold", size: 15))
//                }
                
                
                Section {
                    
                    Button {
                        coordinator.push(.setting(.languages))
                    } label: {
                        buttonContent(systemName: "globe", text: LocalizedStringResource("languages"))
                    }
                    .listRowSeparator(.hidden)
                    
                    Button {
                        openURL(URL(string: "https://www.kttelematic.com/privacy_dt")!)
                        
                    } label: {
                        buttonContent(systemName: "shield", text: LocalizedStringResource("privacy_policy"))
                    }
                    .listRowSeparator(.hidden)
                    
                    
                    Button {
                        // alert
                        showLogoutAlert = true
                    } label: {
                        buttonContent(systemName: "rectangle.portrait.and.arrow.right", text: LocalizedStringResource("logout"))
                    }
                    
                    
                } header: {
                    Text(LocalizedStringResource("settings"))
                        .font(Font.custom("ArialRoundedMTBold", size: 13))
                } footer: {
                    Text("App Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")")
                        .font(Font.custom("ArialRoundedMTBold", size: 13))
                        .frame(maxWidth: .infinity)
                        .frame(alignment: .center)
                }

            }
            .listStyle(.sidebar)
            .shadow(radius: 3)
            
            .alert("logout", isPresented: $showLogoutAlert) {
                Button(LocalizedStringKey("yes")) {
                    coordinator.reset()
                }
                
                Button(LocalizedStringKey("no")) {
                    
                }
            }
            
        }
        
    }
    
    @ViewBuilder
    private func buttonContent(systemName: String, text: LocalizedStringResource) -> some View {
            
        if text == LocalizedStringResource("logout") {
            
            HStack(spacing: 15) {
                
                Image(systemName: systemName)
                    .font(.headline)
                
                Text(text)
                    .font(Font.custom("ArialRoundedMTBold", size: 15))
                
            }
            .foregroundStyle(.red)
            
        } else {
            
            HStack(spacing: 15) {
                
                Image(systemName: systemName)
                    .font(.headline)
                
                Text(text)
                    .font(Font.custom("ArialRoundedMTBold", size: 15))
                
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .font(.headline)
                    
                
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color(hex: 0x5A5A5A))
        }
    
    }
    
}

#Preview {
//    SettingsView()
}
