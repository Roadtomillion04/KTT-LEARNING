//
//  MiscellaneousViewHandler.swift
//  DriverApp
//
//  Created by Nirmal kumar on 03/10/25.
//

import SwiftUI

struct MiscellaneousViewHandler: View {
    
    var miscellaneousPath: MiscellaneousRoute
    
    var body: some View {
    
        switch miscellaneousPath {
        
        case .imageViewer(let image):
            
            ImageViewer(image: image)
                .navigationTitle("Media Viewer")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                            
                        ShareLink(item: image, preview: SharePreview("", image: image)) {
                            Image(systemName: "square.and.arrow.up")
                                .resizable()
                                .frame(width: 24, height: 32)
                                .padding(.horizontal)
                                .tint(.black)
                        }
                            
                    }
                }
            
            
        case .pdfViewer(let url):
            
            PDFKitView(url: URL(string: url)!)
                .navigationTitle("Media Viewer")
            
        case .cameraCapture(let image, let sourceType):
            
            ImagePicker(selectedImage: image, sourceType: sourceType)
            
            
        }
        
        
    }
    
}

#Preview {
//    MiscellaneousViewHandler()
}
