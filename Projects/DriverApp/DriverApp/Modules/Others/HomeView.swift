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
                    Text("POI")
                }
                .tag(HomeTab.poi)
            
            
            TripsView()
                .tabItem {
                    Image(systemName: "square.fill.text.grid.1x2")
                    Text("Trips")
                }
                .tag(HomeTab.trips)
        
            
            DashboardView()
                .tabItem {
                    Image(systemName: "square.grid.2x2.fill")
                    Text("Dashboard")
                }
                .tag(HomeTab.dashboard)
                        
            
            SettingView()
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(HomeTab.settings)

        }
        .tint(.black)
         
//            try? await Task.sleep(for: .milliseconds(1000))
//            
//            if apiService.driverStatusAttributes.success != true {
//                
//                alertMessage = apiService.driverStatusAttributes.error ?? ""
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
