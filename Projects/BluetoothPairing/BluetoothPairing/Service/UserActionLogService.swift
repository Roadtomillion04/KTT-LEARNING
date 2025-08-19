//
//  UserLogService.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 08/08/25.
//

import Foundation
import Connectivity


@MainActor
final class UserActionLogService: ObservableObject {
    
    // so we have to check for internet Availability first, if available POST no logging, if no available log and when available check for logs, POST and clear logs, which is Realm in this case
    
    private var applicationId = Bundle.main.infoDictionary?["APPLICATION_ID"] as? String ?? ""
    private var restApiKey = Bundle.main.infoDictionary?["REST_API_KEY"] as? String ?? ""
    
    private var connectivity = Connectivity()
    
    @Published var isResponseSuccess: Bool = false
    
    init() {
    
        applicationId = applicationId.replacingOccurrences(of: "\"", with: "")
        restApiKey = restApiKey.replacingOccurrences(of: "\"", with: "")

    }

    
    // okay, now it works one off checking as intended
    func checkReachability(logs: [UserActionLog]) {
        
        connectivity.checkConnectivity { connectivity in
            
            if !logs.isEmpty && connectivity.status == .connected {
            
                self.postLogs(logs: logs)
                
            }
            
        }
        
    }
    
    
    func postLogs(logs: [UserActionLog]) {
        
        print(logs)
        
        let encoder = JSONEncoder()
        
        let encodedLogs = try! encoder.encode(logs)
        
        let encodedString = String(data: encodedLogs, encoding: .utf8) // imp takeaway, could not JSONSerialize object
        // credit: https://stackoverflow.com/questions/51121051/how-to-send-an-array-of-objects-to-server-in-swift
        
        // should send in this format { "lockLogs": [UserActionLog] }
        
        let jsonData = ["lockLogs": encodedString]
        
        let data = try! JSONSerialization.data(withJSONObject: jsonData, options: [])
        
        let url = URL(string: "http://192.168.110.20:9000/api/logs")!
        
        let headers = [
            "application_id": applicationId,
            "content-type": "application/json",
            "rest_api_key": restApiKey
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = data as Data
        
        request.cachePolicy = .reloadIgnoringLocalCacheData // we are doing POST operation,so no caching
        
        Task {
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            // let's just check response == 200 to determine, connection is successful
            if let httpResponse = response as? HTTPURLResponse {
                
                if httpResponse.statusCode == 200 || httpResponse.statusCode == 201 {
                    isResponseSuccess = true
                }
                
            }
            
        }
        
    }

}
