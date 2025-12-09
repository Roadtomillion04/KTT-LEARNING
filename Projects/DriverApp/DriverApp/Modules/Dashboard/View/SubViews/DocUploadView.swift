//
//  DocUploadView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 05/09/25.
//

import SwiftUI


struct DocUploadView: View {
    
    @StateObject private var vm: DocUploadViewModel = .init()
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var apiService: APIService
    
    let zoneId: String
    let docDetails: [APIService.DriverStatusModel.ImageShare]
 
    
    var body: some View {
        
        VStack(alignment: .center, spacing: 20) {
            
            VStack(spacing: 10) {
                
                Image(systemName: "icloud.and.arrow.up")
                    .resizable()
                    .frame(width: 32, height: 32)
                
                Text("Capture Document Image to Upload")
                    .font(Font.custom("ArialRoundedMTBold", size: 15))
                
                Text("Tap to Capture the document")
                    .font(Font.custom("Monaco", size: 14))
                    .foregroundStyle(.secondary)
                
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(hex: 0xF1F5F9)).stroke(.tertiary, style: StrokeStyle(lineWidth: 1, dash: [5, 5])))
            
            .onTapGesture {
                
                if vm.documentDetails.count < apiService.driverStatusModel.driver?.account?.driverConfig?.trip?.maxImages?.docs ?? -1 {
                    
                    coordinator.push(.miscellaneous(.cameraCapture(image: $vm.docImage, sourceType: .camera)))
                    
                } else {
                    vm.showLimitAlert = true
                }
            }
            
            .alert("Limit Reached", isPresented: $vm.showLimitAlert) {
                
            }
            
            ScrollView {
                
                LazyVGrid(columns: vm.columns, spacing: 30) {
                    
                        ForEach(vm.documentDetails, id: \.self) { detail in
                            
                            VStack {
                                
                                ImagePreview(uiImage: detail.image)
                                
                                    .overlay {
                                        
                                        Image(systemName: "xmark.circle.fill")
                                            .font(.headline)
                                            .background(Circle().fill(.white))
                                            .foregroundStyle(.red)
                                            .offset(x: 35, y: -35)
                                        
                                            .onTapGesture {
                                                
                                                if !detail.url.isEmpty {
                                                    vm.removedFiles.append(detail.url)
                                                }
                                                
                                                vm.documentDetails.removeAll(where: { $0.image == detail.image })
                                                
                                            }
                                        
                                    }
                                
                                Text(detail.type)

                                Text("(\(detail.number))")
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
                        vm.success = try await apiService.uploadDocuments(docType: .doc(removedFiles: vm.removedFiles, documentDetails: vm.documentDetails), zoneId: zoneId)
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
        
        .sheet(isPresented: $vm.showDocumentSheet) {
              documentSheetContent()
                  .presentationDetents([.fraction(0.75)])
                  .interactiveDismissDisabled(true)
          }
              
                
        .task {
            if !vm.sceneEntered {
                
                do {
                    
                    vm.isLoading = true
                    // zip could do only pairs, so nest them
                    for (url, (type, number)) in zip(docDetails.map( { $0.url ?? "" } ), zip(docDetails.map( { $0.type ?? "" } ), docDetails.map( { $0.number ?? "" } )))  {
                        try await vm.downloadImage(apiService, urlString: url, docType: type, number: number)
                    }
                    vm.isLoading = false
                } catch {
                    
                }
                    
                
            } else {
                vm.checkCapturedImage()
            }
            
            vm.sceneEntered = true
            
        }
       
        .loadingScreen(isLoading: vm.isLoading)
        
        .successAlert(success: $vm.success, message: "Documents uploaded successfully", coordinator: coordinator)
        
    }

    
    @ViewBuilder
    private func documentSheetContent() -> some View {
        
        VStack(alignment: .leading, spacing: 20) {
            
            VStack(alignment: .center) {
                
                Image(uiImage: vm.documentDetails.last!.image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical)
                    
            
            HStack {
                
                Text("Select Document Type")
                    .font(Font.custom("ArialRoundedMTBold", size: 15))
                
                Spacer()
                
                Picker("", selection: $vm.selectedDocumentType) {
                    
                    ForEach(DocUploadViewModel.DocumentTypes.allCases) { documentType in
                        Text("\(documentType.rawValue)")
                            .font(Font.custom("Monaco", size: 12.5))
                            .tag(documentType)
                    }
                }
                
            }
            .tint(.black)

            
            CustomTextField(icon: "text.document.fill", title: "Document No.", text: $vm.documentNumber, keyboardType: .numberPad)
                .padding(.bottom)
            
            
            HStack(alignment: .center, spacing: 50) {
                
                Button(LocalizedStringKey("cancel")) {
                    vm.documentDetails.removeLast()
                    vm.showDocumentSheet = false
                }
                .font(Font.custom("ArialRoundedMTBold", size: 15))
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(.red))
                .foregroundStyle(.white)
            
                
                Button(LocalizedStringKey("save")) {
                    vm.showDocumentSheet = false
                    
                    // logically thinking, the last image should be captured image so
                    vm.documentDetails[vm.documentDetails.count - 1].type = vm.selectedDocumentType
                    vm.documentDetails[vm.documentDetails.count - 1].number = vm.documentNumber
                    
                    // reset the values
                    vm.selectedDocumentType = "Invoice"
                    vm.documentNumber = ""
                }
                .font(Font.custom("ArialRoundedMTBold", size: 15))
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(.teal))
                .foregroundStyle(.white)
                
                
            }
            .frame(maxWidth: .infinity)
            
        }
        .padding(.horizontal)
        
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
fileprivate class DocUploadViewModel: ObservableObject {
    
    @Published var docImage = UIImage()
    
    @Published var showImagePicker: Bool = false
    @Published var showDocumentSheet: Bool = false
    
    @Published var documentDetails: [DocumentType.DocumentDetails] = []
    @Published var docNumber: [String] = []
    @Published var documentType: [String] = []
    
    @Published var showLimitAlert: Bool = false
    @Published var sceneEntered: Bool = false
    
    @Published var success: Bool = false
    @Published var isLoading: Bool = false
    
    // no of columns for VGrid
    let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
    
    
    enum DocumentTypes: String, CaseIterable, Identifiable {
        case invoice = "Invoice"
        case deliveryChallan = "Delivery Challan"
        case documentNo = "Document No"
        case siteId = "Site ID"
        
        var id: String { self.rawValue }
    }
    
    
    @Published var selectedDocumentType: String = "Invoice"
    @Published var documentNumber: String = ""
    
    @Published var removedFiles: [String] = []
    
    func checkCapturedImage() {
        
        if docImage.size.width != 0 || docImage.size.height != 0 {
            documentDetails.append(DocumentType.DocumentDetails(image: docImage, url: "", fileName: "doc_img_\(Int(Date.timeIntervalSinceReferenceDate.rounded())).jpg", number: "", type: ""))
            showDocumentSheet = true
            
            docImage = UIImage() // resetting back to empty image as we handling only one variable
        }
        
    }
    
    func downloadImage(_ apiService: APIService, urlString: String, docType: String, number: String) async throws {
        
        var image: UIImage = .init()
        
        image = await apiService.downloadImage(urlString: urlString)
    
        if image.size.width != 0 && image.size.height != 0 {
            
            documentDetails.append(DocumentType.DocumentDetails(image: image, url: urlString, fileName: "", number: number, type: docType))
        }
    }
    
}


#Preview {
//    DocUploadView()
}
