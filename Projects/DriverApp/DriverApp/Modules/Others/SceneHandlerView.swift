//
//  SceneHandlerView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 01/09/25.
//

import SwiftUI

struct SceneHandlerView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var locationManager: LocationManager
    @EnvironmentObject var apiService: APIService
    
    @State private var errorDescription: String = ""
    @State private var showAlert: Bool = false
    
    var body: some View {
        
        NavigationStack(path: $coordinator.path) {
            
            VStack {
                
            }
            
            .onAppear {
                coordinator.push(.home(.dashboard))
                
                locationManager.manager.requestLocation()
                
                print(locationManager.manager.location?.coordinate.latitude ?? 0)
                print(locationManager.manager.location?.coordinate.longitude ?? 0)
                
                // for simulator
                URLCache.shared.removeAllCachedResponses()
                
            }
             
            .task {
                
                // as per se android app, few api on launch
                    
                do {
                    // isSessionValid api should come here
                    
                } catch {
                    errorDescription = error.localizedDescription
                    showAlert = true
                }
                
            }
            
            .alert(errorDescription, isPresented: $showAlert) {
                
            }
            
            .navigationDestination(for: Route.self) { route in
                
                switch route {
                    
                case .login:
                    LoginView()
                        .navigationBarBackButtonHidden()

             
                case .home:
                    HomeView()
                        .navigationTitle("Driver App")
                        .navigationBarBackButtonHidden()
                    
                
                case .trips(let route):
                    TripsViewHandler(tripPath: route)
                    
                case .dashboard(let route):
                    DashboardViewHandler(dashboardPath: route)
                    
                case .setting(let route):
                    SettingViewHandler(settingPath: route)
                    
                case .miscellaneous(let route):
                    MiscellaneousViewHandler(miscellaneousPath: route)
                    
                    
                }
            }
            
//            .onChange(of: scenePhase) { old, new in
//                
//                switch new {
//                    
//                case .background:
//                    URLCache.shared.removeAllCachedResponses()
//                    
//                default:
//                    break
//                    
//                }
//                
//            }
            
        }
        
    }
    
}

#Preview {
//    SceneHandlerView()
}
