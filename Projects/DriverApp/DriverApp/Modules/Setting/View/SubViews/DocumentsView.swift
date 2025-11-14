//
//  DocumentsView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 03/09/25.
//

import SwiftUI

struct DocumentsView: View {

    @EnvironmentObject private var apiService: APIService
    
    private let columns = [
                GridItem(.flexible()),
                GridItem(.flexible())
            ]
    
    @State private var isPdfViewerPresented: Bool = false

    
    var body: some View {
        
        List {
            
            Section {
                
                LazyVGrid(columns: columns) {
                    
                    ImagePreview(imageUrl: apiService.driverDocumentsAttributes.result.dlPhotoURL.front ?? "")
                    
                    ImagePreview(imageUrl: apiService.driverDocumentsAttributes.result.dlPhotoURL.back ?? "")
                    
                }
                
            } header: {
                Text("License")
                    .font(Font.custom("ArialRoundedMTBold", size: 20))
            }
            
            Section {
                
                LazyVGrid(columns: columns) {
                    
                    ImagePreview(imageUrl: apiService.driverDocumentsAttributes.result.idProofURL.front ?? "")
                    
                    ImagePreview(imageUrl: apiService.driverDocumentsAttributes.result.idProofURL.back ?? "")
                                        
                }
                
            } header: {
                Text("ID Proof")
                    .font(Font.custom("ArialRoundedMTBold", size: 20))
            }
            
            Section {
                VStack(alignment: .center) {
                    Text(apiService.driverStatusAttributes.trip.lplate ?? "")
                        .font(Font.custom("Monaco", size: 25))
                }
                .frame(maxWidth: .infinity)
            }
            
            Section {
                
                LazyVGrid(columns: columns) {
                            
                    PDFPreview(pdfUrl: "https://www.diva-portal.org/smash/get/diva2:1399422/FULLTEXT01.pdf")
                    
                    PDFPreview(pdfUrl: "https://classes.engineering.wustl.edu/~roger/569M.s09/m2025.pdf")
                    
                }
                
            } header: {
                Text("Fitness Certificate")
                    .font(Font.custom("ArialRoundedMTBold", size: 20))
            }
            
            
            Section {
                
                LazyVGrid(columns: columns) {
                  
                    PDFPreview(pdfUrl: "https://www.diva-portal.org/smash/get/diva2:1399422/FULLTEXT01.pdf")
                    
                    PDFPreview(pdfUrl: "https://classes.engineering.wustl.edu/~roger/569M.s09/m2025.pdf")
                    
                }
                
            } header: {
                Text("Insurance")
                    .font(Font.custom("ArialRoundedMTBold", size: 20))
            }
            
            Section {
                
                LazyVGrid(columns: columns) {
                    
                    PDFPreview(pdfUrl: "https://www.diva-portal.org/smash/get/diva2:1399422/FULLTEXT01.pdf")
                    
                    PDFPreview(pdfUrl: "https://classes.engineering.wustl.edu/~roger/569M.s09/m2025.pdf")
                    
                }
                
            } header: {
                Text("Certificate of Registration")
                    .font(Font.custom("ArialRoundedMTBold", size: 20))
            }
            
        }
        .listRowSpacing(0)
        
    }

}


#Preview {
//    DocumentsView()
}
