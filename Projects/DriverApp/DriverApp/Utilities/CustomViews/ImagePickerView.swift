//
//  ImagePickerView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 05/09/25.
//

// credit https://designcode.io/swiftui-advanced-handbook-imagepicker

import SwiftUI


struct ImagePicker: UIViewControllerRepresentable {
    
    @EnvironmentObject var locationManager: LocationManager
    
    // Image Binding does not work
    @Binding var selectedImage: UIImage
    
    var sourceType: UIImagePickerController.SourceType = .camera
    
    @Environment(\.presentationMode) private var presentationMode
    
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var locationManager: LocationManager
        
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
            
            locationManager = parent.locationManager
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
                let watermarkText = """
                Location
                \(locationManager.location?.latitude ?? 0), \( locationManager.location?.longitude ?? 0)
                \(Date().toString(format: "E, dd MMM yyyy HH:mm:ss a"))
                """
                            

                let watermarkedImage = image.withTextWatermark(drawText: watermarkText)
                         
                parent.selectedImage = watermarkedImage
                
            }
                
            self.parent.presentationMode.wrappedValue.dismiss()
            
        }

    }
}

