//
//  Authenticator.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 4/08/25.
//

import Foundation
import RealmSwift


final class Authenticator: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var name: String
    @Persisted var macAddress: String
    
    convenience init(name: String, macAddress: String) {
        self.init()
        
        self.name = name
        self.macAddress = macAddress
    }
    
}
