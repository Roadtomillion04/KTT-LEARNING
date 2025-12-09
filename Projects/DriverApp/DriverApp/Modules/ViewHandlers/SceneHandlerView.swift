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
    @EnvironmentObject var languageManager: LanguageManager
    @EnvironmentObject var customAlertPresenter: CustomAlertPresenter
    @EnvironmentObject var toastPresenter: ToastPresenter
    
    @State private var errorDescription: String = ""
    @State private var showAlert: Bool = false
    
    @State private var viewId = UUID()
    
    var body: some View {
        
        NavigationStack(path: $coordinator.path) {
            
            VStack {
                
            }
            
            .onAppear {
                coordinator.push(.home(.dashboard))
                
                locationManager.requestLocation()
                locationManager.startTracking()
                
            }
            
            
            .onChange(of: customAlertPresenter.error) { old, new in
                errorDescription = new
                showAlert = !new.isEmpty
            }

            // alert not working, however
            .customAlert(isPresented: $showAlert) {
                
                VStack(spacing: 15) {
                    Text(errorDescription)
                        .font(Font.custom("ArialRoundedMTBold", size: 15))
                    
                    Button {
                        showAlert = false
                        customAlertPresenter.error = ""
                    } label: {
                        Text(LocalizedStringKey("ok"))
                            .modifier(SaveButtonModifier())
                            .frame(width: 100)
                    }
                }
                .padding()
            }
            
            // toast
//            .toast(message: $toastPresenter.message)

            .task {
                
                // as per se android app, few api on launch
                    
//                do {
//                    // isSessionValid api should come here
//                    
//                } catch {
//                    errorDescription = error.localizedDescription
//                    showAlert = true
//                }
                
            }
            
            
            .navigationDestination(for: Route.self) { route in
                
                switch route {
                    
                case .login:
                    LoginView()
                        .navigationBarBackButtonHidden()
                    
                    
                case .home:
                    HomeView()
                        .navigationTitle(LocalizedStringKey("app_name"))
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

        }
        
    }
    
}

#Preview {
//    SceneHandlerView()
}

