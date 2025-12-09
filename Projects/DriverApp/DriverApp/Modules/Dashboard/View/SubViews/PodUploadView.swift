//
//  PodUploadView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 05/09/25.
//

import SwiftUI


struct PodUploadView: View {
    
    @StateObject private var vm: PodUploadViewModel = .init()

    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var apiService: APIService
    
    let zoneId: String
    let podDetails: APIService.DriverStatusModel.ShareImages
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
            
            VStack(spacing: 10) {
                
                Image(systemName: "camera.fill")
                    .resizable()
                    .frame(width: 40, height: 32)
                
                Text("Capture Image to Upload")
                    .font(Font.custom("ArialRoundedMTBold", size: 15))
                
                Text("Tap to Capture the proof of delivary (POD) images")
                    .font(Font.custom("Monaco", size: 14))
                    .foregroundStyle(.secondary)
                
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: 0xF1F5F9)).stroke(.tertiary, style: StrokeStyle(lineWidth: 1, dash: [5, 5])))
            
            .onTapGesture {
                
                if vm.fileDetails.count < apiService.driverStatusModel.driver?.account?.driverConfig?.trip?.maxImages?.pod ?? 0 {
                    coordinator.push(.miscellaneous(.cameraCapture(image: $vm.podImage, sourceType: .camera)))
        
                } else {
                    vm.showLimitAlert = true
                }
            }
            
            .alert("Limit Reached", isPresented: $vm.showLimitAlert) {
             
            }
            
            ScrollView {
                
                LazyVGrid(columns: vm.columns, spacing: 30) {
                    
                    ForEach(vm.fileDetails, id: \.self) { detail in
                        
                        HStack {
                            ImagePreview(uiImage: detail.image)
                            
                                .overlay {
                                    
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.headline)
                                        .background(Circle().fill(.white))
                                        .foregroundStyle(.red)
                                        .offset(x: 35, y: -35)
                                    
                                        .onTapGesture {
                                            
                                            vm.removedFiles.append(detail.url)
                                            
                                            vm.fileDetails.removeAll(where: { $0.image == detail.image })
                                            
                                        }
                                    
                                }
                            
                            Image(systemName: "text.document")
                                .font(.headline)
                                .foregroundStyle(.black)
                                .offset(y: 35)
                                
                                .onTapGesture {
                                    vm.showNoteAlert = true
                                    vm.notes = detail.notes
                                    
                                    if detail.editable {
                                        
                                        vm.showNoteEditor = true
                                        if let index = vm.fileDetails.firstIndex(of: detail) {
                                            vm.indexToEdit = index
                                        }
                                    }
                                }
                            
                        }
                        
                        .alert("Notes", isPresented: $vm.showNoteAlert) {
                            
                            if vm.showNoteEditor {
                                TextField("Text", text: $vm.fileDetails[vm.indexToEdit].notes)
                            }
                            
                            Button(LocalizedStringKey("ok")) {
                                
                                
                                if vm.showNoteEditor {
                                    
                                    vm.showNoteEditor = false
                                    
                                }
                                
                            }
                            
                        } message: {
                            Text(vm.notes)
                        }
                        
                    }
                }
                    
                
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
            

            Button {
                Task {
                    await vm.postData(apiService, zoneId: zoneId)
                }
            } label: {
                Text(LocalizedStringResource("save"))
                    .modifier(SaveButtonModifier())
            }
            
        }
        .padding(.horizontal)
        .padding(.top)
        
        
        .onAppear {
            if !vm.sceneEntered {
                
                Task {
                    do {
                        vm.isLoading = true
                        for (url, notes) in zip(podDetails.images.map( { $0.url ?? "" } ), podDetails.images.map( { $0.notes ?? "" } ))  {
                            try await vm.downloadImage(apiService, urlString: url, notes: notes)
                        }
                        vm.isLoading = false
                    } catch {
                        
                    }
                    
                }
            } else {
                vm.isImageCaptured()
            }
            
            vm.sceneEntered = true
          
        }
        
        .loadingScreen(isLoading: vm.isLoading)
        
        .successAlert(success: $vm.success, message: "POD uploaded successfully", coordinator: coordinator)

        
    }
        
}

@MainActor
fileprivate class PodUploadViewModel: ObservableObject {
    
    @Published var podImage = UIImage()
    
    @Published var showImagePicker: Bool = false
    
    @Published var fileDetails: [DocumentType.FileDetails] = []
    
    @Published var showLimitAlert: Bool = false
    
    @Published var sceneEntered: Bool = false
    
    
    @Published var notes: String = ""
    
    @Published var showNoteAlert: Bool = false
    @Published var showNoteEditor: Bool = false
    @Published var indexToEdit: Int = -1
    
    @Published var removedFiles: [String] = []
    
    @Published var success: Bool = false
    @Published var isLoading: Bool = false    
    // no of columns for VGrid
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var alertPresenter: CustomAlertPresenter?
    
    
    func isImageCaptured() {
        
        if podImage.size.width != 0 || podImage.size.height != 0 {
            
            fileDetails.append(DocumentType.FileDetails(image: podImage, url: "", fileName:"pod_img_\(Int(Date.timeIntervalSinceReferenceDate.rounded())).jpg", notes: "", editable: true))
            
            
            podImage = UIImage()
            
        }
        
    }
    
    
    func downloadImage(_ apiService: APIService, urlString: String, notes: String) async throws {
        
        var image: UIImage = .init()
        
        image = await apiService.downloadImage(urlString: urlString)
    
        if image.size.width != 0 && image.size.height != 0 {
            
            fileDetails.append(DocumentType.FileDetails(image: image, url: urlString, fileName: "", notes: notes, editable: false))
        }
        
    }
    
    func postData(_ apiService: APIService, zoneId: String) async {
        
        do {
            isLoading = true
            
            success = try await apiService.uploadDocuments(docType: .pod(removedFiles: removedFiles, fileDetails: fileDetails), zoneId: zoneId)
            
            isLoading = false
            
        } catch {
            isLoading = false
        }
        
    }
        
}


#Preview {
//    PodUploadView()
}
