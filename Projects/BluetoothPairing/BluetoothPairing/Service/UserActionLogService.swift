//
//  UserLogService.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 08/08/25.
//

import Foundation
import Network

final class UserActionLogService: ObservableObject {
    
    // so we have to check for internet Availability first, if available POST no logging, if no available log and when available check for logs, POST and clear logs, which is Realm in this case
        
     var isNetworkAvailable: String = "" // can use optional but have to handle ?? so empty string is better way
    
    private var applicationId = Bundle.main.infoDictionary?["APPLICATION_ID"] as? String ?? ""
    private var restApiKey = Bundle.main.infoDictionary?["REST_API_KEY"] as? String ?? ""

        
    // NWPathMonitor is not consistent when truning off and on Wifi in simulator
    
    let monitor = NWPathMonitor(prohibitedInterfaceTypes: [.other, .wiredEthernet])
        
    init() {
        // realm needs to be accessed in main thread
        monitor.start(queue: .main) // gloabal is background thread
        
        applicationId = applicationId.replacingOccurrences(of: "\"", with: "")
        restApiKey = restApiKey.replacingOccurrences(of: "\"", with: "")
    }
    
    
    func checkNetworkAvailability(logs: [UserActionLog]) {
        
        monitor.pathUpdateHandler = { path in
            
            switch path.status {
                
                case .satisfied:
                    print("connected")
                                                                 
                        // posting Logs only when connected state and is not empty
                        if !logs.isEmpty {
                            self.postLogs(logs: logs)
                            
                        }
                    
                case .unsatisfied:
                    print("disconnected")
                    
                case .requiresConnection:
                    
                    print("waiting for connection...")
                    
                default:
                    break
                    
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
        
        let url = URL(string: "http://127.0.0.1:9000/api/logs")!
        
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
        request.timeoutInterval = 10
        
        
        Task {
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            let decoder = JSONDecoder()
            
            let jsonResponse = try? decoder.decode(Response.self, from: data)
            
            print(jsonResponse?.userLogs ?? -1)
            
        }
        
    }

    
    struct Response: Decodable {
        let userLogs: Int
    }

}
