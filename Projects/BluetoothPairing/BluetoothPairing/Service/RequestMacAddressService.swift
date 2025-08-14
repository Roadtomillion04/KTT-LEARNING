//
//  RequestMacAddressService.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 08/08/25.
//

import Foundation

final class RequestMacAddressService {
    
    private var applicationId = Bundle.main.infoDictionary?["APPLICATION_ID"] as? String ?? ""
    private var restApiKey = Bundle.main.infoDictionary?["REST_API_KEY"] as? String ?? ""
    
    init() {
        applicationId = applicationId.replacingOccurrences(of: "\"", with: "")
        restApiKey = restApiKey.replacingOccurrences(of: "\"", with: "")
    }
    
    
    func requestMacAddress(lockName: String) -> String {
        
        // using the mock api, I wrote in express
        
        let url = URL(string: "http://127.0.0.1:9000/api/locks/mac/lock1")!
        let headers = [
            "application_id": applicationId,
            "content-type": "application/json",
            "rest_api_key": restApiKey
        ]
        
        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = headers
        
        Task {
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            
            let jsonResponse = try? decoder.decode(Response.self, from: data)
            
            return jsonResponse?.response ?? ""
            
        }
        
        return ""
        
    }
    
    // unpacking json
    struct Response: Decodable {
        let response: String
    }
    
}
