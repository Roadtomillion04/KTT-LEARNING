//
//  ToastView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 08/12/25.
//

import SwiftUI

struct Toast: View {
    let message: String

    var body: some View {
        Text(message)
            .font(Font.custom("Monaco", size: 13))
            .foregroundStyle(.white)
            .padding()
            .background(Color(.darkGray))
            .cornerRadius(10)
            .padding(.bottom, 60)
    }
}


struct ToastModifier: ViewModifier {
    @Binding var message: String?
    let duration: TimeInterval

    func body(content: Content) -> some View {
        ZStack {
            content
            if let message = message {
                VStack {
                    Spacer()
                    Toast(message: message)
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation {
                            self.message = nil
                        }
                    }
                }
            }
        }
        .animation(.easeInOut, value: message)
    }
}

extension View {
    func toast(message: Binding<String?>, duration: TimeInterval = 2) -> some View {
        self.modifier(ToastModifier(message: message, duration: duration))
    }
}
