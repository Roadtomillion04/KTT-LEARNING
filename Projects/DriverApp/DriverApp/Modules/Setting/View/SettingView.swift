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
    
    var body: some View {
           
        VStack(alignment: .center) {
       
            List {
                
                Section {
                    
                    Button {
                        coordinator.push(.setting(.profile))
                    } label: {
                        
                        HStack(spacing: 15) {
                            
                            AsyncImage(url: URL(string: apiService.driverStatusAttributes.driver.photoURL ?? "")) { image in
                                
                                image
                                    .profileImage()
                                
                                
                            } placeholder: {
                                Image(systemName: "person.fill")
                                    .profileImage()
                            }
                            .frame(width: 64, height: 64)
                            
                            VStack(alignment: .leading, spacing: 6) {
                                
                                Text(apiService.driverStatusAttributes.driver.name ?? "Name")
                                    .font(Font.custom("ArialRoundedMTBold", size: 20))
                                
                                Text(apiService.driverStatusAttributes.driver.phone1 ?? "Number")
                                    .font(Font.custom("ArialRoundedMTBold", size: 17.5))
                                    .foregroundStyle(.secondary)
                                
                            }
                            
                            Spacer()
                            
                            Image("right-arrow")
                                .resizable()
                                .frame(width: 28, height: 28)
                            
                        }
                        
                    }
                }
                
                
                Button {
                    coordinator.push(.setting(.leaveRequest))
                } label: {
                    buttonContent(systemName: "pencil.and.list.clipboard", text: "Leave Request")
                        
                }
                .listRowSeparator(.hidden)
                .padding(.vertical, 10)
                
                
                Button {
                    coordinator.push(.setting(.leaveHistory))
                } label: {
                    buttonContent(systemName: "clock.arrow.trianglehead.counterclockwise.rotate.90", text: "Leave History")
                        
                }
                .padding(.vertical, 10)
                .listRowSeparator(.hidden)

                
                Button {
                    coordinator.push(.setting(.tripSettlement))
                } label: {
                    buttonContent(systemName: "dollarsign.circle.fill", text: "Trip Settlement")
                        
                }
                .padding(.vertical, 10)
                .listRowSeparator(.hidden)
                
                
                Button {
                    coordinator.push(.setting(.documents))
                } label: {
                    buttonContent(systemName: "folder", text: "Documents")
                        
                }
                .padding(.vertical, 10)
                .listRowSeparator(.hidden)
                
                
                Button {
                    coordinator.push(.setting(.attendance(.attendance)))
                } label: {
                    buttonContent(systemName: "person.crop.circle.badge.checkmark.fill", text: "Attendance")
                }
                .padding(.vertical, 10)
                .listRowSeparator(.hidden)
                
                
                Section {
                    
                    Button {
                        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
                    } label: {
                        buttonContent(systemName: "bell.fill", text: "Notifications")
                    }
                    .padding(.vertical, 10)
                    
                    
                } header: {
                    Text("Notfications")
                        .font(Font.custom("ArialRoundedMTBold", size: 15))
                }
                
                
                Section {
                    
                    Button {
                        coordinator.push(.setting(.languages))
                    } label: {
                        buttonContent(systemName: "globe", text: "Languages")
                    }
                    .padding(.vertical, 10)
                    .listRowSeparator(.hidden)
                    
                    Button {
                        openURL(URL(string: "https://www.apple.com/privacy/")!)
                        
                    } label: {
                        buttonContent(systemName: "shield", text: "Privacy Policy")
                    }
                    .padding(.vertical, 10)
                    .listRowSeparator(.hidden)
                    
                    
                    Button {
                        coordinator.reset()
                    } label: {
                        buttonContent(systemName: "rectangle.portrait.and.arrow.right", text: "Logout")
                    }
                    .padding(.vertical, 10)
                    
                    
                } header: {
                    Text("Settings")
                        .font(Font.custom("ArialRoundedMTBold", size: 15))
                } footer: {
                    Text("App Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")")
                        .font(Font.custom("ArialRoundedMTBold", size: 15))
                        .frame(maxWidth: .infinity)
                        .frame(alignment: .center)
                }

            }
            .listStyle(.sidebar)
            .shadow(radius: 3)
            
        }
        
    }
    
    @ViewBuilder
    private func buttonContent(systemName: String, text: String) -> some View {
            
        if text == "Logout" {
            
            HStack(spacing: 15) {
                
                Image(systemName: systemName)
                    .font(.title)
                
                Text(text)
                    .font(Font.custom("ArialRoundedMTBold", size: 18))
                
            }
            .foregroundStyle(.red)
            
        } else {
            
            HStack(spacing: 15) {
                
                Image(systemName: systemName)
                    .font(.title)
                
                Text(text)
                    .font(Font.custom("ArialRoundedMTBold", size: 18))
                
                Spacer()
                
                Image("right-arrow")
                    .resizable()
                    .frame(width: 28, height: 28)
                
            }
            .frame(maxWidth: .infinity)
            .foregroundStyle(Color(hex: 0x5A5A5A))
        }
    
    }
    
}

#Preview {
//    SettingsView()
}
