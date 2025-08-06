//
//  TwilioService.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 24/07/25.
//

import Foundation


@MainActor // Published needs to be updated in main thread
final class MessagingSerive: ObservableObject {
    
    @Published var otpVerificationStatus: Bool = false
    
    var applicationId = Bundle.main.infoDictionary?["APPLICATION_ID"] as? String ?? ""
    var restApiKey = Bundle.main.infoDictionary?["REST_API_KEY"] as? String ?? ""
    
    init() {
        applicationId = applicationId.replacingOccurrences(of: "\"", with: "")
        restApiKey = restApiKey.replacingOccurrences(of: "\"", with: "")
    }
    
    func sendOTP(mobileNumber: String) {

        // credits - https://curlconverter.com/swift/
        // for converting curl to swift code
        
        let url = URL(string: "https://api.kttelematic.com/api/locks/login?phone=\(mobileNumber)")!
        let headers = [
            "x-at-application-id": applicationId,
            "x-at-rest-api-key": restApiKey
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers

        // URLSession defaultly run on background thread, which is good
        
        Task {
            
            let (data, response) = try! await URLSession.shared.data(for: request)
                
            print(String(data: data, encoding: .utf8) ?? "")
            
        }

    }
    
    
    func verifyOTP(mobileNumber: String, OTPNumber: String) {
        
        let jsonData = [ "otp": "\(OTPNumber)" ]
        let data = try! JSONSerialization.data(withJSONObject: jsonData, options: [])

        let url = URL(string: "https://api.kttelematic.com/api/locks/verifyOtp?phone=\(mobileNumber)")!
        let headers = [
            "content-type": "application/json",
            "x-at-application-id": applicationId,
            "x-at-rest-api-key": restApiKey
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = data as Data
        
        Task {
            
            let (data, response) = try! await URLSession.shared.data(for: request)
            
            // let's parse json and check the verified status
            
            let decoder = JSONDecoder()
            
            let verifiedStatus = try? decoder.decode(StatusCheck.self, from: data)
            
            print(verifiedStatus?.success ?? false)
            
            otpVerificationStatus = verifiedStatus?.success ?? false
            
        }
        
    }
    
    
    // we only want the status key so decodable, JSONSerialize fetches all key value pairs
    struct StatusCheck: Decodable {
        let success: Bool
    }
    
}
