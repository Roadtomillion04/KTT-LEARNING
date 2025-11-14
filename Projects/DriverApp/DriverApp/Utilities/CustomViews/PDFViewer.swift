//
//  PDFViewer.swift
//  DriverApp
//
//  Created by Nirmal kumar on 09/09/25.
//

// swiftui has no native pdfviewer, PDFKit is UIKit library

import SwiftUI
import PDFKit


// UIViewRepresentable is making UIKIT view in Swiftui
struct PDFKitView: UIViewRepresentable {
    
    let url: URL
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        pdfView.autoScales = true
        return pdfView
    }
    
    // this is stubs, has to confrom
    func updateUIView(_ uiView: PDFView, context: Context) {
        
    }
    
}

#Preview {
//    PDFViewer()
}
