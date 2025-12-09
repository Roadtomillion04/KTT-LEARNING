//
//  LRUploadView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 04/09/25.
//

import SwiftUI


struct LrUploadView: View {
    
    @StateObject private var vm: LrUploadViewModel = .init()
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var apiService: APIService
    
    let zoneId: String
    let lrDetails: APIService.DriverStatusModel.ShareImages
    
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 30) {
            
            CustomTextField(icon: "pencil", title: "LR Number", text: $vm.lrNumber, keyboardType: .numberPad)
            
            VStack(spacing: 10) {
                
                Image(systemName: "camera.fill")
                    .resizable()
                    .frame(width: 40, height: 32)
                
                Text("Capture Image to Upload")
                    .font(Font.custom("ArialRoundedMTBold", size: 15))
                
                Text("Tap to Capture the lorry receipt (LR) images")
                    .font(Font.custom("Monaco", size: 14))
                    .foregroundStyle(.secondary)
                
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: 0xF1F5F9)).stroke(.tertiary, style: StrokeStyle(lineWidth: 1, dash: [5, 5])))
            
            
            .onTapGesture {
                
                if vm.fileDetails.count < apiService.driverStatusModel.driver?.account?.driverConfig?.trip?.maxImages?.lr ?? 0 {
                    
                    coordinator.push(.miscellaneous(.cameraCapture(image: $vm.lrImage, sourceType: .camera)))
                    
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
                    
                    do {
                        vm.isLoading = true
                        
                        vm.success = try await apiService.uploadDocuments(docType: .lr(lrNumber: vm.lrNumber, removedFiles: vm.removedFiles, fileDetails: vm.fileDetails), zoneId: zoneId)
                        
                        vm.isLoading = false
                        
                    } catch {
                        vm.isLoading = false
                    }
                    
                }
                
            } label: {
                Text(LocalizedStringResource("save"))
                    .modifier(SaveButtonModifier())
            }
            
            
        }
        .padding(.horizontal)
        .padding(.top)
        .ignoresSafeArea(.keyboard)
        
        .onAppear {
            
            if !vm.sceneEntered {
                Task {
                    do {
                        for (url, notes) in zip(lrDetails.images.map( { $0.url ?? "" } ), lrDetails.images.map( { $0.notes ?? "" } )) {
                            vm.isLoading = true
                            try await vm.downloadImage(apiService, urlString: url, notes: notes)
                            vm.isLoading = false
                        }
                        
                        
                    } catch {
                        
                    }
                    
                }
                
                vm.lrNumber = lrDetails.number ?? ""
                
                // pushing sub view inside will not reset this, only on popping
                vm.sceneEntered = true

            } else {
                vm.checkCapturedImage()
            }
           
        }
        
        .loadingScreen(isLoading: vm.isLoading)
        
        .successAlert(success: $vm.success, message: "LR uploaded successfully", coordinator: coordinator)
        
        .toolbar {
            
            ToolbarItem(placement: .keyboard) {
                    
                Button("done") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }

    }
        
}

@MainActor
fileprivate class LrUploadViewModel: ObservableObject {
    
    @Published var lrNumber: String = ""
    
    @Published var lrImage = UIImage()
    
    @Published var showImagePicker: Bool = false
    
    @Published var fileDetails: [DocumentType.FileDetails] = []
    
    @Published var showLimitAlert: Bool = false
    
    @Published var notes: String = ""
    
    @Published var showNoteAlert: Bool = false
    @Published var showNoteEditor: Bool = false
    @Published var indexToEdit: Int = -1
    
    @Published var removedFiles: [String] = []
    
    // will reset only when scene popped from Navigation Stack
    @Published var sceneEntered: Bool = false
    
    @Published var success: Bool = false
    @Published var isLoading: Bool = false
    
    // no of columns for VGrid
    let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
    
    @Published var cachedImages: [UIImage] = []
    
    let lrCacheManager = ImageCacheManager.shared
    
    
    func checkCapturedImage() {
        
        if lrImage.size.width != 0 && lrImage.size.height != 0 {
            fileDetails.append(DocumentType.FileDetails(image: lrImage, url: "",fileName: "lr_img_\(Int(Date.timeIntervalSinceReferenceDate.rounded())).jpg", notes: "", editable: true))
            
            lrImage = UIImage() // resetting back to empty image as we handling only one variable
        }
        
    }
    
    
    func downloadImage(_ apiService: APIService, urlString: String, notes: String) async throws {
        
        var image: UIImage = .init()
        
        image = await apiService.downloadImage(urlString: urlString)
    
        if image.size.width != 0 && image.size.height != 0 {
            
            // for already uploaded images, set filename to empty, is how server request body expects
            fileDetails.append(DocumentType.FileDetails(image: image, url: urlString, fileName: "", notes: notes, editable: false))
            
        }
        
    }
    
    
}

#Preview {
//    LrUploadView()
}
