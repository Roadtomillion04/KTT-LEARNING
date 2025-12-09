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
                    coordinator.push(.miscellaneous(.cameraCapture(image: $vm.newProfilePic, sourceType: .camera)))
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
                    coordinator.push(.miscellaneous(.cameraCapture(image: $vm.newDlBackPic, sourceType: .camera)))
                }
                
            }
            
            HStack {
                
                VStack(alignment: .center, spacing: 5) {
                    Text("\(String(vm.profileData.totalKms ?? 0))")
                        .font(Font.custom("ArialRoundedMTBold", size: 13))
                    
                    HStack(spacing: 2.5) {
                        
                        Image(systemName: "steeringwheel")
                        
                        Text(LocalizedStringResource("driven"))
                            
                    }
                    .font(Font.custom("ArialRoundedMTBold", size: 12.5))
                    .foregroundStyle(.secondary)
                }
                    
                VStack(alignment: .center, spacing: 5) {
                    Text("\(vm.profileData.onTimeTrips ?? 0) Trips")
                        .font(Font.custom("ArialRoundedMTBold", size: 13))
                    
                    HStack(spacing: 2.5) {
                        
                        Image(systemName: "truck.box.fill")
                        
                        Text(LocalizedStringResource("time"))
                            
                    }
                    .font(Font.custom("ArialRoundedMTBold", size: 12.5))
                    .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .center, spacing: 5) {
                    Text("\(vm.profileData.totalTrips ?? 0) Trips")
                        .font(Font.custom("ArialRoundedMTBold", size: 13))
                    
                    HStack(spacing: 2.5) {
                        
                        Image(systemName: "truck.box.fill")
                        
                        Text(LocalizedStringResource("total"))
                            
                    }
                    .font(Font.custom("ArialRoundedMTBold", size: 12.4))
                    .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .center, spacing: 5) {
                    Text("\(vm.profileData.presentInMonth ?? 0)/\(vm.profileData.daysInMonth ?? 0)")
                        .font(Font.custom("ArialRoundedMTBold", size: 13))
                    
                    HStack(spacing: 2.5) {
                        
                        Image(systemName: "calendar")
                        
                        Text(LocalizedStringResource("attendance"))
                            
                    }
                    .font(Font.custom("ArialRoundedMTBold", size: 12.5))
                    .foregroundStyle(.secondary)
                }
                
            }
            .frame(maxWidth: .infinity)
            .frame(height: 75)
            .background(RoundedRectangle(cornerRadius: 10).fill(.white).shadow(radius: 5))
            .padding(.horizontal, 10)
            .offset(y: -25)
            
            
            List {
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    HStack {
                        
                        Image(systemName: "person.text.rectangle")
                        
                        Text(LocalizedStringResource("license"))
                            .font(Font.custom("Monaco", size: 12.5))
                        
                        Spacer()
                        
                        Text(vm.viewMoreToggle ? LocalizedStringResource("viewless") : LocalizedStringResource("viewmore"))
                            .font(Font.custom("Monaco", size: 12.5))
                            .foregroundStyle(.green)
                            .onTapGesture {
                                vm.viewMoreToggle.toggle()
                        }
                    }
                    .foregroundStyle(.secondary)
                    
                    
                    HStack {
                        Text(LocalizedStringResource("number"))
                            .font(Font.custom("Monaco", size: 12.5))
                        
                        Spacer()
                        
                        Text(LocalizedStringResource("edate"))
                            .font(Font.custom("Monaco", size: 12.5))
                    }
                    
                    
                    HStack {
                        Text(apiService.driverStatusModel.driver?.dlno ?? "")
                            .font(Font.custom("Monaco", size: 12.5))
                        
                        Spacer()
                        
                        Text(apiService.driverStatusModel.driver?.dlexp?.dateFormatting(format: "dd/MM/yyyy") ?? "")
                            .font(Font.custom("Monaco", size: 12.5))
                    }
                    
                }
                
                
                if vm.viewMoreToggle == true {
                    
                    VStack(spacing: 2.5) {
                        
                        Text(LocalizedStringResource("dob"))
                            .font(Font.custom("ArialRoundedMTBold", size: 13))
                        
                        Text(apiService.driverStatusModel.driver?.dateOfBirth?.dateFormatting(format: "dd/MM/yyyy") ?? "")
                            .font(Font.custom("Monaco", size: 12.5))
                        
                    }
                    
                    
                    VStack {
                        
                        Text(LocalizedStringResource("license"))
                            .font(Font.custom("ArialRoundedMTBold", size: 13))
                        
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
            await vm.checkImageCaptured(apiService)
        }
        
        .successAlert(success: $vm.success, message: "Photo updated successfully", coordinator: coordinator)
        
    }
        
}

@MainActor
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
    
    @Published var profileData: APIService.DriverProfileModel = .init()
    
    @Published var success: Bool = false
    
    
    func onAppear(_ apiService: APIService) async {
       
        do {
            
            profileData = try await apiService.getDriverProfile()
            
            if profilePic.size.width == 0 && profilePic.size.height == 0 {
                
                profilePic = await apiService.downloadImage(urlString: apiService.driverStatusModel.driver?.photoURL ?? "")
                
                dlFrontPic = await apiService.downloadImage(urlString: apiService.driverStatusModel.driver?.dlPhotoURL?.front ?? "")
                
                dlBackPic = await apiService.downloadImage(urlString: apiService.driverStatusModel.driver?.dlPhotoURL?.back ?? "")
                
            }
            
        } catch {
            
        }
       
    }
    

    func checkImageCaptured(_ apiService: APIService) async {
        
        if newProfilePic.size.width != 0 || newProfilePic.size.height != 0 {
           
            await updateDrivingLicensePhoto(apiService: apiService, pic: newProfilePic, filename: "")
            
            newProfilePic = .init()
            
        }
        
        if newDlFrontPic.size.width != 0 || newDlFrontPic.size.height != 0 {
            await updateDrivingLicensePhoto(apiService: apiService, pic: newDlFrontPic, filename: "dlProofFront")
            
            newDlFrontPic = .init()
        }
        
        if newDlBackPic.size.width != 0 || newDlBackPic.size.height != 0 {
            await updateDrivingLicensePhoto(apiService: apiService, pic: newDlBackPic, filename: "dlProofBack")
            
            newDlBackPic = .init()
        }
        
    }
    
    
    func updateDrivingLicensePhoto(apiService: APIService, pic: UIImage, filename: String) async {
        
        do {
            // no imageData deletes the photo
            
            success = try await apiService.updateDriverphoto(image: pic, filename: filename)
            
        } catch {
            
        }
    }
    
}

// Model
extension APIService {
    
    struct DriverProfileModel: Decodable {
        var success: Bool?
        var totalTrips: Int?
        var onTimeTrips: Int?
        var totalKms: Int?
        var daysInMonth: Int?
        var presentInMonth: Int?
        var error: String?
    }
    
}

#Preview {
//    ProfileView()
}

