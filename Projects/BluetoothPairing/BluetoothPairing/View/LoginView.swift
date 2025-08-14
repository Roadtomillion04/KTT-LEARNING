//
//  LoginView.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 16/07/25.
//

import SwiftUI


struct LoginView: View {
    
    @ObservedObject var realmManager: RealmManager
    @ObservedObject var messagingService: MessagingSerive
    
    @State private var mobileNumber: String = ""
    @State private var otp: String = ""
    
    // this is alternative way for Binding?
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    
    enum LoginState {
        case numberEntered
        case otpSent
        case otpVerified
    }
    
    // following E-lock app route
    @State private var loginState: LoginState = .numberEntered
    @State private var showOtpField: Bool = false
    @State private var disableMobileNumberField: Bool = false
    
    enum LoginError {
        case mobileNumberError
        case otpIncorrectError
    }
    
    @State private var loginError: LoginError?
    @State private var showAlert: Bool = false
    @Environment(\.dismiss) var dismiss
    
    
    var body: some View {

        // refering human interface guidelines, so iPhone follow this format, so this should be Portrait, will not be consistent with iPads
        if horizontalSizeClass == .compact && verticalSizeClass == .regular {
            loginContent()
        }
        
        else {
            ScrollView {
                loginContent()
            }
            .scrollBounceBehavior(.basedOnSize)
        }
       
    }

    
    @ViewBuilder // -> is for semantic, wraps View inside closure/function
    private func loginContent() -> some View {
        
        VStack(spacing: 48) {
            
            VStack {
                Image("lock-svgrepo-com")
                    .resizable()
                    .frame(width: 64, height: 64)
                
                Text("BLE-Connect")
                    .font(Font.custom("Georgia", size: 24))
            }

            
            VStack(spacing: 32) {
                
                VStack(spacing: 0) { // no spacing as per original app
                    
                    TextField("Mobile No.", text: $mobileNumber)
                        .modifier(TextFieldModifier())
                        .disabled(disableMobileNumberField)
                    
                    // prefix cuts off after 10, and also as @State is used View will be updated, thus display only 10 numbers
                        .onChange(of: mobileNumber) { old, new in
                            mobileNumber = String(new.prefix(10))
                        }
                    
                    
                    if showOtpField {
                        TextField("OTP", text: $otp)
                            .modifier(TextFieldModifier())

                            .onChange(of: otp) { old, new in
                            otp = String(new.prefix(4))
                        }
                    }
                }
                
                Button("LOGIN") {
                    
                    Task {
                        
                        switch loginState {
                            // this is first time, after entering number, we also need to check if count is 10
                        case .numberEntered:
                            
                            if mobileNumber.count == 10 {
                                showOtpField = true
                                disableMobileNumberField = true
                                loginState = .otpSent
                                
                               messagingService.sendOTP(mobileNumber: mobileNumber)
                                
                            } else {
                                loginError = .mobileNumberError
                                showAlert = true
                            }
                            
                            // on second click should be checking otp validity
                        case .otpSent:
                            
                            messagingService.verifyOTP(mobileNumber: mobileNumber, OTPNumber: otp)
                            
                            try await Task.sleep(for: .seconds(1)) // sleeps 1 sec before proceeding, yield() should have worked but oh well
                                
                                
                            if messagingService.otpVerificationStatus {
                                loginState = .otpVerified
                                fallthrough // is the only way to make switch do two/more actions in single check
                                
                            } else {
                                loginError = .otpIncorrectError
                                showAlert = true
                            }
                            
                        case .otpVerified:
                            
                            realmManager.registerNewUser(mobileNumber: mobileNumber)
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .background(.indigo)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                .font(Font.custom("Monaco", size: 16))
                
                
            }
            .padding(.horizontal, 32)
            
        }
        .alert(isPresented: $showAlert) {
            
            switch loginError {
                
            case .mobileNumberError:
                
                Alert(title: Text("Invalid Mobile Number"), message: Text("Please Enter valid Mobile Number"), dismissButton: .default(Text("OK")) {
                    dismiss()
                })
                
            case .otpIncorrectError:
                Alert(title: Text("Invalid OTP"), message: Text("Please Enter correct OTP pin"), dismissButton: .default(Text("OK")) {
                    dismiss()
                })
                
            default:
                Alert(title: Text("how did you come here??"))
                
            }
            
        }
        
    }
    
}


struct TextFieldModifier: ViewModifier { // could also do extension View to make it available anywhere in the project
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.black)
            .keyboardType(.numberPad)
            .textContentType(.telephoneNumber)
            .padding(12)
            .padding(.horizontal, 36)
        // background only shadow
            .background(RoundedRectangle(cornerRadius: 5).fill(Color(hex: 0xF1F5F9)).shadow(radius: 1))
            .font(Font.custom("Monaco", size: 16))
        
            .overlay(alignment: .leading) {
                Image(systemName: "phone.fill")
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
            }
    }
    
}


#Preview {
//    LoginView()
}
