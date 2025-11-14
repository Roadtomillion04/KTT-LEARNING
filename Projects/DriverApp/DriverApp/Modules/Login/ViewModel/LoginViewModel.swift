//
//  Loginvm.swift
//  DriverApp
//
//  Created by Nirmal kumar on 01/09/25.
//

import Foundation
import Combine


@MainActor
final class LoginViewModel: ObservableObject {
    
    @Published var mobileNumber: String = ""
    @Published var otp: String = ""
    @Published var buttonText: String = ""
    
    enum LoginState {
        case numberEntered
        case otpSent
        case otpVerified
    }
    
    @Published var loginState: LoginState = .numberEntered
    @Published var showOtpField: Bool = false
    @Published var disableMobileNumberField: Bool = false
    
    enum LoginError {
        case mobileNumberError
        case mobileNumberNotExistError
        case otpIncorrectError
    }
    
    @Published var loginError: LoginError?
    @Published var showAlert: Bool = false
    @Published var isLoading: Bool = false
    
    // services
    var loginService: APIService?
    
    // sink returns cancellable, if not stored subscription cancelled
    private var cancellables = Set<AnyCancellable>()
    
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
    let year = Calendar(identifier: .gregorian).dateComponents([.year], from: Date()).year
    let helpLineNumber = "1234567890"
    
    
    init() {
        
        limitMobileNumber()
        limitOTP()
        
        buttonText = "GET OTP"
    }
    
    
    private func limitMobileNumber() {
        
        $mobileNumber // making debounce shorted consumes more memory and app lags/does not perform as intended
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main) // RunLoop is event loop is awaiting network response/input event
            .sink { newValue in
                self.mobileNumber = String(newValue.prefix(10))
            }
            .store(in: &cancellables)
        
    }
    
    
    private func limitOTP() {
        
        $otp
            .debounce(for: .milliseconds(750), scheduler: RunLoop.main)
            .sink { newValue in
                self.otp = String(newValue.prefix(4))
            }
            .store(in: &cancellables)
        
    }
    
    
    func onLoginButtonTapped(completion: @escaping (_ success: Bool) -> Void) async {
            
        switch loginState {
            
        case .numberEntered:
            
            if mobileNumber.count == 10 {
                
                isLoading = true
                
                do {
                    
                    let success = try await loginService?.sendOtp(mobileNumber: mobileNumber)
                    
                    if success == true {
                        
                        showOtpField = true
                        disableMobileNumberField = true
                        loginState = .otpSent
                        buttonText = "LOGIN"

                        
                    } else {
                            
                        loginError = .mobileNumberNotExistError
                        showAlert = true
                        
                    }
                    
                    
                } catch {
                    print("catch", error)
                }
                
                isLoading = false

                
            } else {
                loginError = .mobileNumberError
                showAlert = true
            }
            
        // on second click should be checking otp validity
        case .otpSent:
            
            isLoading = true
            
            do {
                
                let success = try await loginService?.verifyOtp(mobileNumber: mobileNumber, otp: otp)
                
                if success == true {
                    loginState = .otpVerified
                    fallthrough
                } else {
                    loginError = .otpIncorrectError
                    showAlert = true
                }
                
            } catch {
                print("catch", error)
            }
            
            isLoading = false

            
        case .otpVerified:
            
            completion(true) // completion is standard name in community
            
            // ressting back to original state
            mobileNumber = ""
            otp = ""
            showOtpField = false
            disableMobileNumberField = false
            
        }
    }
    
}
