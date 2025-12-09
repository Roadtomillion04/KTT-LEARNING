//
//  ViewExtension.swift
//  DriverApp
//
//  Created by Nirmal kumar on 18/10/25.
//

import SwiftUI


extension View {
    
    func loadingScreen(isLoading: Bool) -> some View {
        
        self
            .overlay {
                
                if isLoading {
                    
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(2.0)
                }
                
            }
        
            .onChange(of: isLoading) { old, new in
                print(new)
            }
        
            .opacity(isLoading ? 0.5 : 1)
        
            .disabled(isLoading)

    }
    
    func successAlert(success: Binding<Bool>, message: String, coordinator: AppCoordinator) -> some View {
        
        self
            .alert("Success", isPresented: success) {
                Button("Ok") {
                    coordinator.pop()
                }
            } message: {
                Text(message)
            }
        }
}

//
//fileprivate struct LoadingView<Content: View>: View {
//    
//    @State private var isLoading: Bool = false
//    
//    var content: Content
//    var task: () async throws
//    
//    var body: some View {
//        
//        content
//            .overlay {
//                
//                if isLoading {
//                    
//                    ProgressView()
//                        .background(.regularMaterial)
//                }
//                
//            }
//            .task(id: isLoading) {
//                guard isLoading else { return }
//                do {
//                    try await task
//                } catch {
//                    
//                }
//                isLoading = false
//            }
//        
//    }
//    
//}
//
//

extension CustomTextField {
  
    func formatDouble(_ valueBinding: Binding<String>) -> some View {
        
        self
            .onChange(of: valueBinding.wrappedValue) { oldValue, newValue in
                
                let decimalSeparator = Locale.current.decimalSeparator ?? "."
                
                var cleanedNewValue = newValue
                
                if cleanedNewValue.components(separatedBy: decimalSeparator).count > 2 {
                    cleanedNewValue = oldValue
                }
                
                valueBinding.wrappedValue = cleanedNewValue
                
            }

    }
}


#Preview {
//    ViewExtension()
}
