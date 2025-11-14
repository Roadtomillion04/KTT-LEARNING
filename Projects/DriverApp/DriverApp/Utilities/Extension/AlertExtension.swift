//
//  AlertExtension.swift
//  DriverApp
//
//  Created by Nirmal kumar on 18/10/25.
//

import SwiftUI


enum CustomErrorDescription: Error, LocalizedError {
    
    case badResponse
    
    var errorDescription: String? {
        
        switch self {
            
        case .badResponse:
            
            return "Not Authorized"
        }
    }
    
}

// credit - kavsoft

extension View {
    
    @ViewBuilder
    func customAlert<Content: View>(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .modifier(CustomAlertViewModifier(isPresented: isPresented, alertContent: content))
    }
    
}


fileprivate struct CustomAlertViewModifier<AlertContent: View>: ViewModifier {
    
    @Binding var isPresented: Bool
    @ViewBuilder var alertContent: AlertContent
    
    @State private var showFullScreenCover: Bool = false
    @State private var animatedValue: Bool = false
    
    
    
    func body(content: Content) -> some View {
        
        
        
        content
            // covers full screen
            .fullScreenCover(isPresented: $showFullScreenCover) {
                
                ZStack {
                    
                    if animatedValue {
                        alertContent
                            .padding()
                            .background(.background, in: .rect(cornerRadius: 10))
                            .padding(.horizontal)
                    }
                    
                }
                .presentationBackground {
                    Rectangle()
                        .fill(.primary.opacity(0.35))
                        
                        // tapping/swiping outside
                        .onTapGesture {
                            isPresented = false
                        }
                    
                        .gesture(
                            DragGesture()
                                .onChanged { _ in
                                    isPresented = false
                                }
                        )
                }
                .task {
                    try? await Task.sleep(for: .seconds(0.1))
                    withAnimation(.easeInOut(duration: 0.3)) {
                        animatedValue = true
                    }
                }
                
            }
            .onChange(of: isPresented) { old, new in
                var transaction = Transaction()
                transaction.disablesAnimations = true
                
                if new {
                    withTransaction(transaction) {
                        showFullScreenCover = true
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        animatedValue = false
                    } completion: {
                        withTransaction(transaction) {
                            showFullScreenCover = false
                        }
                    }
                }
            }
        
    }
    
}


#Preview {
//    AlertExtension()
}
