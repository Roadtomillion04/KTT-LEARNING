//
//  AlertExtension.swift
//  DriverApp
//
//  Created by Nirmal kumar on 18/10/25.
//

import SwiftUI


class CustomAlertPresenter: ObservableObject {
    
    @Published var error: String = ""
}

class ToastPresenter: ObservableObject {
    
    @Published var message: String?
}

enum CustomErrorDescription: Error, LocalizedError, Equatable {
    static func == (lhs: CustomErrorDescription, rhs: CustomErrorDescription) -> Bool {
        return true
    }
    
    case networkError(String)
    case badResponse(Int? = nil)
    case decodeError(Error)
    case responseError(String)
    
    var errorDescription: String? {
        
        switch self {
            
        case .networkError(let error):
            return error
            
        case .badResponse(let statusCode):
            return "Invalid Server Response.\nStatus Code: \(statusCode ?? 0)"
                    
        case .decodeError(let error):
            print("Error From decoding data: \(error)")
            return error.localizedDescription
            
        case .responseError(let message):
            print("Error message from Response: \(message)")
            return message
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
            .font(Font.custom("Monaco", size: 13))
        
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
                        
//                        .onTapGesture { isPresented = false }
//                        .gesture(
//                            DragGesture()
//                                .onChanged { _ in isPresented = false }
//                        )
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

