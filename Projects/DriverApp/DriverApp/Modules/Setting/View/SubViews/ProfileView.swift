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
                
                ImagePreview(uiImage: vm.profilePic)
                    .clipShape(.circle)
                    
                    .overlay {
                        
                        Image(systemName: "pencil.circle.fill")
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(.white)
                            
                        // offset relative position move
                            .offset(x: 35, y: 35)
                        
                            .onTapGesture {
                                vm.showProfileImagePicker = true
                            }
                           
                    }
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .background(.green)
            
            .alert("lbl_set_profile_photo", isPresented: $vm.showProfileImagePicker) {
                
                Button(LocalizedStringKey("lbl_take_camera_picture")) {
                    coordinator.push(.miscellaneous(.cameraCapture(image: $vm.newProfilePic, sourceType: .camera)))
                }
                
                Button(LocalizedStringKey("lbl_choose_from_gallery")) {
                    coordinator.push(.miscellaneous(.cameraCapture(image: $vm.newProfilePic, sourceType: .photoLibrary)))
                }
                
            }
            
            .alert("lbl_set_profile_photo", isPresented: $vm.showdlFrontImagePicker) {
                
                Button(LocalizedStringKey("lbl_take_camera_picture")) {
                    coordinator.push(.miscellaneous(.cameraCapture(image: $vm.newDlFrontPic, sourceType: .camera)))
                }
                
                Button(LocalizedStringKey("lbl_choose_from_gallery")) {
                    coordinator.push(.miscellaneous(.cameraCapture(image: $vm.newDlFrontPic, sourceType: .photoLibrary)))
                }
                
            }
            
            .alert("lbl_set_profile_photo", isPresented: $vm.showdlBackImagePicker) {
                
                Button(LocalizedStringKey("lbl_take_camera_picture")) {
                    coordinator.push(.miscellaneous(.cameraCapture(image: $vm.newDlBackPic, sourceType: .camera)))
                }
                
                Button(LocalizedStringKey("lbl_choose_from_gallery")) {
                    coordinator.push(.miscellaneous(.cameraCapture(image: $vm.newDlBackPic, sourceType: .photoLibrary)))
                }
                
            }
            
            HStack {
                
                VStack(alignment: .center, spacing: 5) {
                    Text("\(String(apiService.profileSummaryAttributes.totalKms ?? 0))")
                        .font(Font.custom("ArialRoundedMTBold", size: 14))
                    
                    HStack(spacing: 2.5) {
                        
                        Image(systemName: "steeringwheel")
                        
                        Text(LocalizedStringResource("driven"))
                            
                    }
                    .font(Font.custom("ArialRoundedMTBold", size: 12))
                    .foregroundStyle(.secondary)
                }
                    
                VStack(alignment: .center, spacing: 5) {
                    Text("\(apiService.profileSummaryAttributes.onTimeTrips ?? 0) Trips")
                        .font(Font.custom("ArialRoundedMTBold", size: 14))
                    
                    HStack(spacing: 2.5) {
                        
                        Image(systemName: "truck.box.fill")
                        
                        Text(LocalizedStringResource("time"))
                            
                    }
                    .font(Font.custom("ArialRoundedMTBold", size: 12))
                    .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .center, spacing: 5) {
                    Text("\(apiService.profileSummaryAttributes.totalTrips ?? 0) Trips")
                        .font(Font.custom("ArialRoundedMTBold", size: 14))
                    
                    HStack(spacing: 2.5) {
                        
                        Image(systemName: "truck.box.fill")
                        
                        Text(LocalizedStringResource("total"))
                            
                    }
                    .font(Font.custom("ArialRoundedMTBold", size: 12))
                    .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .center, spacing: 5) {
                    Text("\(apiService.profileSummaryAttributes.presentInMonth ?? 0)/\(apiService.profileSummaryAttributes.daysInMonth ?? 0)")
                        .font(Font.custom("ArialRoundedMTBold", size: 14))
                    
                    HStack(spacing: 2.5) {
                        
                        Image(systemName: "calendar")
                        
                        Text(LocalizedStringResource("attendance"))
                            
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
                        
                        Text(LocalizedStringResource("license"))
                        
                        Spacer()
                        
                        Text(vm.viewMoreToggle ? LocalizedStringResource("viewless") : LocalizedStringResource("viewmore"))
                            .foregroundStyle(.green)
                            .onTapGesture {
                                vm.viewMoreToggle.toggle()
                        }
                    }
                    .foregroundStyle(.secondary)
                    
                    
                    HStack {
                        Text(LocalizedStringResource("number"))
                        Spacer()
                        Text(LocalizedStringResource("edate"))
                    }
                    
                    
                    HStack {
                        Text(apiService.driverStatusAttributes.driver.dlno ?? "")
                        Spacer()
                        Text(apiService.driverStatusAttributes.driver.dlexp?.dateFormatting(format: "dd/MM/yyyy") ?? "")
                    }
                    
                }
                
                
                if vm.viewMoreToggle == true {
                    
                    VStack {
                        
                        Text(LocalizedStringResource("dob"))
                        
                        Text(apiService.driverStatusAttributes.driver.dateOfBirth?.dateFormatting(format: "dd/MM/yyyy") ?? "")
                        
                    }
                    
                    
                    VStack {
                        
                        Text(LocalizedStringResource("license"))
                        
                        HStack {
                            
                            Image(uiImage: vm.dlFrontPic)
                                .resizable()
                                .frame(width: 200, height: 150)
                            
                                .onTapGesture {
                                    vm.showdlFrontImagePicker = true
                                }
                            
                            Image(uiImage: vm.dlBackPic)
                                .resizable()
                                .frame(width: 200, height: 150)
                            
                                .onTapGesture {
                                    vm.showdlBackImagePicker = true
                                }
                        }
                    }
                    
                }
            }
            
        }
        .task {
            await vm.onAppear(apiService)
        }
        
        .onAppear {
            vm.checkImageCaptured(apiService)
        }
        
    }
        
}

fileprivate class ProfileViewModel: ObservableObject {
    
    @Published var viewMoreToggle: Bool = false
    
    @Published var showProfileImagePicker: Bool = false
    @Published var showdlFrontImagePicker: Bool = false
    @Published var showdlBackImagePicker: Bool = false
    
    
    @Published var profilePic: UIImage = .init()
    @Published var dlFrontPic: UIImage = .init()
    @Published var dlBackPic: UIImage = .init()
    
    // captured images
    @Published var newProfilePic: UIImage = .init()
    @Published var newDlFrontPic: UIImage = .init()
    @Published var newDlBackPic: UIImage = .init()
    
    @Published var success: Bool = false
    
    @MainActor
    func onAppear(_ apiService: APIService) async {
       
        do {
            if profilePic.size.width == 0 && profilePic.size.height == 0 {
                
                profilePic = try await apiService.downloadImage(urlString: apiService.driverStatusAttributes.driver.photoURL ?? "")
                
                dlFrontPic = try await apiService.downloadImage(urlString: apiService.driverStatusAttributes.driver.dlPhotoURL.front ?? "")
                
                dlBackPic = try await apiService.downloadImage(urlString: apiService.driverStatusAttributes.driver.dlPhotoURL.back ?? "")
                
            }
        } catch {
            
        }
       
    }

    
    @MainActor
    func checkImageCaptured(_ apiService: APIService) {
        
        if newProfilePic.size.width != 0 || newProfilePic.size.height != 0 {
           
            updateDrivingLicensePhoto(apiService: apiService, pic: newProfilePic, filename: "")
            
            newProfilePic = .init()
            
        }
        
        if newDlFrontPic.size.width != 0 || newDlFrontPic.size.height != 0 {
            updateDrivingLicensePhoto(apiService: apiService, pic: newDlFrontPic, filename: "dlProofFront")
            
            newDlFrontPic = .init()
        }
        
        if newDlBackPic.size.width != 0 || newDlBackPic.size.height != 0 {
            updateDrivingLicensePhoto(apiService: apiService, pic: newDlBackPic, filename: "dlProofBack")
            
            newDlBackPic = .init()
        }
        
    }
    
    @MainActor
    func updateDrivingLicensePhoto(apiService: APIService, pic: UIImage, filename: String) {
        Task {
            do {
                // no imageData deletes the photo
                
                success = try await apiService.updateDriverphoto(image: pic, filename: filename)
                
                print(success)
            } catch {
                
            }
        }
    }
    
    
}

#Preview {
//    ProfileView()
}
