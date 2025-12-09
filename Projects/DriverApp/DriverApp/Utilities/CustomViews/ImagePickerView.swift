//
//  ImagePickerView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 05/09/25.
//

// credit https://designcode.io/swiftui-advanced-handbook-imagepicker

import SwiftUI
import GoogleMaps

struct ImagePicker: UIViewControllerRepresentable {
    
    @EnvironmentObject var locationManager: LocationManager
    
    // Image Binding does not work
    @Binding var selectedImage: UIImage
    
    var sourceType: UIImagePickerController.SourceType = .camera
    
    @Environment(\.presentationMode) private var presentationMode
    
    var location: String = ""
    
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
            self.locationManager = parent.locationManager
        }

        private func reverseGeocodeAddress(lat: Double, lon: Double) async -> String {
            await withCheckedContinuation { continuation in
                let geocoder = GMSGeocoder()
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                
                geocoder.reverseGeocodeCoordinate(coordinate) { response, _ in
                    var addressString = ""
                    if let address = response?.firstResult(), let lines = address.lines {
                        addressString = lines.joined(separator: ", ")
                    }
                    continuation.resume(returning: addressString)
                }
            }
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            guard let image = info[.originalImage] as? UIImage else {
                parent.presentationMode.wrappedValue.dismiss()
                return
            }
            
            // Capture coordinates once
            let lat = locationManager.location?.latitude ?? 0
            let lon = locationManager.location?.longitude ?? 0
            
            
            Task { @MainActor in
                let address = await reverseGeocodeAddress(lat: lat, lon: lon)
                
                let watermarkText = """
                \(address)
                \(lat), \(lon)
                \(Date().toString(format: "E, dd MMM yyyy HH:mm:ss a"))
                """
                
                let watermarkedImage = image.withTextWatermark(drawText: watermarkText)
                
                self.parent.selectedImage = watermarkedImage
                
                self.parent.presentationMode.wrappedValue.dismiss()
            }
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}
