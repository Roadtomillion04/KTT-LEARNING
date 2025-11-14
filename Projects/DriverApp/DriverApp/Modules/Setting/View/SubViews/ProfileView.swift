//
//  ProfileView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 03/09/25.
//

import SwiftUI


struct ProfileView: View {
    
    @StateObject private var vm: ProfileViewModel = .init()
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var apiService: APIService
    
    var body: some View {
        
        VStack {
            
            HStack(alignment: .center) {
                
                AsyncImage(url: URL(string: apiService.driverStatusAttributes.driver.photoURL ?? "")) { image in
                    
                    image
                        .profileImage()
                        
                        .onTapGesture {
                            coordinator.push(.miscellaneous(.imageViewer(image: image)))
                        }
                    
                        .overlay {
                            
                            Image(systemName: "pencil.circle.fill")
                                .resizable()
                                .frame(width: 28, height: 28)
                                .foregroundColor(.white)
                                
                            // offset relative position move
                                .offset(x: 35, y: 35)
                            
                                .onTapGesture {
                                    vm.showImagePicker = true
                                }
                               
                        }
                    
                    
                } placeholder: {
                    Image(systemName: "person.fill")
                        .profileImage()

                }
                .frame(width: 100, height: 100)
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .background(.green)
            
            
            HStack {
                
                VStack(alignment: .center, spacing: 5) {
                    Text("\(String(apiService.profileSummaryAttributes.totalKms ?? 0))")
                    
                    HStack(spacing: 2.5) {
                        
                        Image(systemName: "steeringwheel")
                        
                        Text("KM Driven")
                            
                    }
                    .font(Font.custom("ArialRoundedMTBold", size: 12))
                    .foregroundStyle(.secondary)
                }
                    
                VStack(alignment: .center, spacing: 5) {
                    Text("\(apiService.profileSummaryAttributes.onTimeTrips ?? 0) Trips")
                    
                    HStack(spacing: 2.5) {
                        
                        Image(systemName: "truck.box.fill")
                        
                        Text("On Time")
                            
                    }
                    .font(Font.custom("ArialRoundedMTBold", size: 12))
                    .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .center, spacing: 5) {
                    Text("\(apiService.profileSummaryAttributes.totalTrips ?? 0) Trips")
                    
                    HStack(spacing: 2.5) {
                        
                        Image(systemName: "truck.box.fill")
                        
                        Text("In Total")
                            
                    }
                    .font(Font.custom("ArialRoundedMTBold", size: 12))
                    .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .center, spacing: 5) {
                    Text("\(apiService.profileSummaryAttributes.presentInMonth ?? 0)/\(apiService.profileSummaryAttributes.daysInMonth ?? 0)")
                    
                    HStack(spacing: 2.5) {
                        
                        Image(systemName: "calendar")
                        
                        Text("Attendance")
                            
                    }
                    .font(Font.custom("ArialRoundedMTBold", size: 12))
                    .foregroundStyle(.secondary)
                }
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 75)
            .background(RoundedRectangle(cornerRadius: 10).fill(.white).shadow(radius: 5))
            .padding(.horizontal, 10)
            .offset(y: -25)
            
            
            List {
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        
                        Image(systemName: "person.text.rectangle")
                        
                        Text("Driving License")
                        
                        Spacer()
                        
                        Text(vm.viewMoreToggle ? "View Less" : "View More")
                            .foregroundStyle(.green)
                            .onTapGesture {
                                vm.viewMoreToggle.toggle()
                        }
                    }
                    .foregroundStyle(.secondary)
                    
                    
                    HStack {
                        Text("No.")
                        Spacer()
                        Text("Expiry Date")
                    }
                    
                    
                    HStack {
                        Text(apiService.driverStatusAttributes.driver.dlno ?? "")
                        Spacer()
                        Text(apiService.driverStatusAttributes.driver.dlexp?.dateFormatting(format: "dd/MM/yyyy") ?? "")
                    }
                    
                }
                
                
                if vm.viewMoreToggle == true {
                    
                    VStack {
                        
                        Text("Date of Birth")
                        
                        Text(apiService.driverStatusAttributes.driver.dateOfBirth?.dateFormatting(format: "dd/MM/yyyy") ?? "")
                        
                    }
                    
                    
                    VStack {
                        
                        Text("Driving Liscense")
                        
                        HStack {
                            
                            ImagePreview()
                            
                            ImagePreview()
                            
                        }
                    }
                    
                }
            }
            
        }
        
    }
        
}

fileprivate class ProfileViewModel: ObservableObject {
    
    @Published var viewMoreToggle: Bool = false
    
    @Published var showImagePicker: Bool = false
    @Published var image = UIImage()
    
}

#Preview {
//    ProfileView()
}
