//
//  DriverAppApp.swift
//  DriverApp
//
//  Created by Nirmal kumar on 01/09/25.
//

import SwiftUI

@main
struct DriverAppApp: App {
    
    @StateObject private var coordinator: AppCoordinator = .init()
    
    // serivces
    @StateObject private var locationManager: LocationManager = .init()
    @StateObject private var apiService: APIService = .init()
    
    var body: some Scene {
        
        WindowGroup {
            
            SceneHandlerView()
                .environmentObject(coordinator)
                .environmentObject(locationManager)
                .environmentObject(apiService)
            
        }
        
    }
}
