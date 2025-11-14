//
//  ConnectivityService.swift
//  DriverApp
//
//  Created by Nirmal kumar on 18/09/25.
//

import Foundation
import Connectivity


class ConnectivityService {
    
    private var connectivity = Connectivity()
    
    // singleton
    static let sharedInstance = ConnectivityService()
    
    func checkConnectivity(completion: @escaping (_ success: Bool) -> Void) async {
        
        connectivity.checkConnectivity { connectivity in
                
            if connectivity.status == .connected {
                completion(true)
            }
            
            if connectivity.status == .notConnected {
                 completion(false)
            }
        
        }
        

    }
    
}
