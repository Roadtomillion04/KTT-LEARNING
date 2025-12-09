//
//  LoginView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 01/09/25.
//

import SwiftUI

struct LoginView: View {
    
    @StateObject private var vm: LoginViewModel = .init()
    
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var loginService: APIService
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    // Single enum-based focus for this view
    enum Field: Hashable {
        case mobile
        case otp
    }
    @FocusState private var focusedField: Field?
    
    @FocusState private var focused: Bool
    
    var body: some View {
        
        // veritical
        if horizontalSizeClass == .compact && verticalSizeClass == .regular {
            
            VStack {
                Spacer()
                loginContent()
                Spacer()
                bottomContent()
            }
            .frame(maxHeight: .infinity, alignment: .center)
            
            .loadingScreen(isLoading: vm.isLoading)
        }
        
        else { // horizontal
            ScrollView {
                
                VStack {
                    Spacer()
                    loginContent()
                    Spacer()
                    bottomContent()
                }
                .frame(maxHeight: .infinity, alignment: .center)
                
                .loadingScreen(isLoading: vm.isLoading)
            }
            .scrollIndicators(.hidden)
            .scrollBounceBehavior(.basedOnSize)
        }
       
    }
    
    @ViewBuilder
    private func loginContent() -> some View {
        
        VStack(spacing: 40) {
            
            VStack {
                
                Image(systemName: "steeringwheel")
                    .resizable()
                    .frame(width: 125, height: 125)
                
                Text("Driver App")
                    .font(Font.custom("Monaco", size: 25))
                
            }
            
            
            CustomTextField(icon: "iphone.gen1", title: "Mobile No.", text: $vm.mobileNumber, keyboardType: .numberPad)
                .disabled(vm.disableMobileNumberField)
            
            
            if vm.showOtpField {
                
                CustomTextField(icon: "ellipsis.rectangle.fill", title: "OTP", text: $vm.otp, keyboardType: .numberPad)
                
                }
            
            
            Button(vm.buttonText) {
                
                Task {
                    
                    await vm.onLoginButtonTapped { success in
                        
                        if success {
                            coordinator.push(.home(.dashboard))
                        }
                        
                    }
                }
                
            }
            .frame(maxWidth: .infinity)
            .padding(12)
            .background(.black)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .font(Font.custom("ArialRoundedMTBold", size: 15))
            
        }
        .padding(.horizontal, 40)
        
        .onAppear {
            vm.loginService = loginService
        
        }
        
        
        .alert(isPresented: $vm.showAlert) {
        
            switch vm.loginError {
                
            case .mobileNumberError:
                
                Alert(title: Text("Invalid Mobile Number"), message: Text("Please Enter valid Mobile Number"), dismissButton: .default(Text("OK")))
                
            case .mobileNumberNotExistError:
                
                Alert(title: Text("Driver Profile Not Found"), message: Text("Please Contact Admin"), dismissButton: .default(Text("OK")))
                
            case .otpIncorrectError:
                
                Alert(title: Text("Invalid OTP"), message: Text("Please Enter correct OTP pin"), dismissButton: .default(Text("OK")))
                                
            default:
               
                Alert(title: Text(""))
                
            }
            
        }
        
        .toolbar {
            
            ToolbarItem(placement: .keyboard) {
                    
                Button("done") {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            }
        }
        
    }
    
    
    @ViewBuilder
    private func bottomContent() -> some View {
        
        VStack(spacing: 6) {
            
            Text("New to Driver App?")
            
            Link(destination: URL(string: "tel:\(vm.helpLineNumber)")!) {
                Text("Call \(vm.helpLineNumber) to learn more.")
            }
            
            Text("App Version \(vm.appVersion ?? "")")
                .foregroundStyle(.secondary)
            
        }
        .font(Font.custom("Monaco", size: 15))
        .padding()
        
        
        HStack {
            
            Image(systemName: "character.square.fill")
            
            Spacer()
            
            Text("© \(String(vm.year ?? -1)) Driver App.")
                .font(Font.custom("ArialRoundedMTBold", size: 15))
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(.green))
        
    }
    
}

#Preview {
//    LoginView()
}
