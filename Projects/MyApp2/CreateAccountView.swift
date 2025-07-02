//
//  CreateAccountView.swift
//  MyApp2
//
//  Created by Nirmal kumar on 30/06/25.
//


import SwiftUI
import Combine

struct CreateAccountView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var bank = ""
    @State private var accountNumber = ""
    @State private var focusedField: Field?

    @ObservedObject private var keyboard = KeyboardResponder()

    enum Field: String, CaseIterable {
        case name, email, password, bank, accountNumber
    }

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(spacing: 36) {
                    Text("Create Account")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 40)

                    Group {
                        textField("Enter your Name", text: $name, field: .name)
                        textField("Enter your Email", text: $email, field: .email)
                        secureField("Enter your Password", text: $password, field: .password)
                        textField("Enter your Bank", text: $bank, field: .bank)
                        textField("Enter your Account Number", text: $accountNumber, field: .accountNumber)
                    }

                    Button("Register") {
                        // Registration logic
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                .padding(.bottom, keyboard.currentHeight + 40)
                .onChange(of: focusedField) { newValue in
                    if let field = newValue {
                        withAnimation {
                            proxy.scrollTo(field, anchor: .center)
                        }
                    }
                }
            }
        }
        .background(Color.black.ignoresSafeArea())
        .foregroundColor(.white)
        .onTapGesture { hideKeyboard() }
    }

    @ViewBuilder
    func textField(_ placeholder: String, text: Binding<String>, field: Field) -> some View {
        TextField(placeholder, text: text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .id(field)
            .onTapGesture {
                focusedField = field
            }
    }

    @ViewBuilder
    func secureField(_ placeholder: String, text: Binding<String>, field: Field) -> some View {
        SecureField(placeholder, text: text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .id(field)
            .onTapGesture {
                focusedField = field
            }
    }
}

// MARK: - Keyboard Tracking
final class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    private var cancellable: AnyCancellable?

    init() {
        cancellable = Publishers.Merge(
            NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
                .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0 },

            NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
                .map { _ in CGFloat(0) }
        )
        .assign(to: \.currentHeight, on: self)
    }

    deinit {
        cancellable?.cancel()
    }
}

// MARK: - Dismiss Keyboard Helper
#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}
#endif


#Preview {
    CreateAccountView()
}
