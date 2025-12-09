//
//  DocumentsView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 03/09/25.
//

import SwiftUI

struct DocumentsView: View {

    @StateObject private var vm: DocumentsViewModel = .init()
    
    @EnvironmentObject private var apiService: APIService
        
    @State private var isPdfViewerPresented: Bool = false

    
    var body: some View {
        
        List {
            
            Section {
                
                LazyVGrid(columns: vm.columns) {
                    
                    ImagePreview(imageUrl: vm.documents.dlPhotoURL?.front ?? "")
                    
                    ImagePreview(imageUrl: vm.documents.dlPhotoURL?.back ?? "")
                    
                }
                
            } header: {
                Text("License")
                    .font(Font.custom("ArialRoundedMTBold", size: 15))
            }
            
            Section {
                
                LazyVGrid(columns: vm.columns) {
                    
                    ImagePreview(imageUrl: vm.documents.idProofURL?.front ?? "")
                    
                    ImagePreview(imageUrl: vm.documents.idProofURL?.back ?? "")
                                        
                }
                
            } header: {
                Text("ID Proof")
                    .font(Font.custom("ArialRoundedMTBold", size: 15))
            }
            
            // condition will come
            
//            Section {
//                VStack(alignment: .center) {
//                    Text(vm.documents.lplate ?? "")
//                        .font(Font.custom("ArialRoundedMTBold", size: 17.5))
//                }
//                .frame(maxWidth: .infinity)
//            }
            
            
//            Section {
//                
//                LazyVGrid(columns: vm.columns) {
//                            
//                    PDFPreview(pdfUrl: "https://www.diva-portal.org/smash/get/diva2:1399422/FULLTEXT01.pdf")
//                    
//                    PDFPreview(pdfUrl: "https://classes.engineering.wustl.edu/~roger/569M.s09/m2025.pdf")
//                    
//                }
//                
//            } header: {
//                Text("Fitness Certificate")
//                    .font(Font.custom("ArialRoundedMTBold", size: 15))
//            }
//            
//            
//            Section {
//                
//                LazyVGrid(columns: vm.columns) {
//                  
//                    PDFPreview(pdfUrl: "https://www.diva-portal.org/smash/get/diva2:1399422/FULLTEXT01.pdf")
//                    
//                    PDFPreview(pdfUrl: "https://classes.engineering.wustl.edu/~roger/569M.s09/m2025.pdf")
//                    
//                }
//                
//            } header: {
//                Text("Insurance")
//                    .font(Font.custom("ArialRoundedMTBold", size: 15))
//            }
//            
//            Section {
//                
//                LazyVGrid(columns: vm.columns) {
//                    
//                    PDFPreview(pdfUrl: "https://www.diva-portal.org/smash/get/diva2:1399422/FULLTEXT01.pdf")
//                    
//                    PDFPreview(pdfUrl: "https://classes.engineering.wustl.edu/~roger/569M.s09/m2025.pdf")
//                    
//                }
//                
//            } header: {
//                Text("Certificate of Registration")
//                    .font(Font.custom("ArialRoundedMTBold", size: 15))
//            }
            
        }
        .listRowSpacing(0)
        
        .task {
            await vm.onAppear(apiService)
        }
        
    }

}


fileprivate class DocumentsViewModel: ObservableObject {
    @Published var documents: APIService.DriverDocumentsModel.Result = .init()
    
    let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]

    
    func onAppear(_ apiService: APIService) async {
        do {
            documents = try await apiService.getDriverDocuments()
        } catch {
            
        }
    }
    
}


// Model
extension APIService {
    
    struct DriverDocumentsModel: Decodable {
        var success: Bool?
        var result: Result?
        var error: String?
        
        struct Result: Decodable {
            var dlPhotoURL: DLPhotoURL?
            var idProofURL: DLPhotoURL?
            var lplate: String?
            var assetDocs: [AssetDoc] = []
            
        }
        
        struct AssetDoc: Decodable {
            var id: Int?
            var name: String?
            var doc: DLPhotoURL?
        }
        
        struct DLPhotoURL: Decodable {
            var front, back: String?
            
            enum CodingKeys: String, CodingKey {
                case front
                case back
            }
            
            init(from decoder: any Decoder) throws {
                let container: KeyedDecodingContainer<APIService.DriverDocumentsModel.DLPhotoURL.CodingKeys> = try decoder.container(keyedBy: APIService.DriverDocumentsModel.DLPhotoURL.CodingKeys.self)
                
                let front = try container.decodeIfPresent(String.self, forKey: APIService.DriverDocumentsModel.DLPhotoURL.CodingKeys.front)
                
                let back = try container.decodeIfPresent(String.self, forKey: APIService.DriverDocumentsModel.DLPhotoURL.CodingKeys.back)
                
                self.front = "https://dev.ktt.io/api/upload/file" + (front ?? "")
                self.back = "https://dev.ktt.io/api/upload/file" + (back ?? "")
            }
        }
    }
    
}

#Preview {
//    DocumentsView()
}
