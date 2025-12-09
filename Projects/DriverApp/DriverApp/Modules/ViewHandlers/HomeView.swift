//
//  HomeView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 01/09/25.
//

import SwiftUI


struct HomeView: View {
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var apiService: APIService
    
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""
    

    var body: some View {
        // canno't tag in Tag {}
        TabView(selection: $coordinator.selectedTab) {
            
            POIView()
                .tabItem {
                    Image(systemName: "location")
                    Text(LocalizedStringResource("poi"))
                }
                .tag(HomeTab.poi)
                
            
            TripsView()
                .tabItem {
                    Image(systemName: "square.fill.text.grid.1x2")
                    Text(LocalizedStringResource("trips"))
                }
                .tag(HomeTab.trips)
        
            
            DashboardView()
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text(LocalizedStringResource("dashboard"))
                }
                .tag(HomeTab.dashboard)
                        
            
            SettingView()
                .tabItem {
                    Image(systemName: "gear")
                    Text(LocalizedStringResource("more"))
                }
                .tag(HomeTab.settings)

        }
        .tint(.black)
         
//            try? await Task.sleep(for: .milliseconds(1000))
//            
//            if apiService.driverStatusModel.success != true {
//                
//                alertMessage = apiService.driverStatusModel.error ?? ""
//                
//                showAlert = true
//            }
//            
//        }
//        
//        .alert(alertMessage, isPresented: $showAlert) {
//            Button("OK", role: .cancel) { showAlert = false }
//        }
        
    }
    
}

#Preview {
//    HomeView()
}
