//
//  ImagePreviewView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 29/09/25.
//

import SwiftUI

struct ImagePreview: View {
    
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var imageUrl: String?
    var uiImage: UIImage?
    
    var body: some View {
        
        if imageUrl != nil {
            
            AsyncImage(url: URL(string: imageUrl!)) { phase in
                
                switch phase {
                    
                case .success(let image):
                    
                    image
                        .previewableImage()
                    
                        .onTapGesture {
                            coordinator.push(.miscellaneous(.imageViewer(image: image)))
                        }
                    
                    
                case .failure(_):
                    Image("id-card")
                        .previewableImage()
                    
                default:
                    EmptyView()
                    
                }
                
            }
        }
        
        if uiImage != nil {
            
            Image(uiImage: uiImage!)
            
                .previewableImage()
            
                .onTapGesture {
                    coordinator.push(.miscellaneous(.imageViewer(image: Image(uiImage: uiImage!) )))
                }
            
        }
        
    }
}


struct PDFPreview: View {
    
    @EnvironmentObject private var coordinator: AppCoordinator
    
    let pdfUrl: String
    
    var body: some View {
        
        Image("pdf-icon")
             .resizable()
             .frame(width: 150, height: 150)
        
             .onTapGesture {
                 coordinator.push(.miscellaneous(.pdfViewer(url: pdfUrl)))
             }
    }
    
}
