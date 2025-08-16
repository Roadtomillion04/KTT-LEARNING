//
//  UserActionLog.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 08/08/25.
//

import Foundation
import RealmSwift


final class UserActionLog: Object, ObjectKeyIdentifiable, Codable {
    
//    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted(primaryKey: true) var date: String // as per se android app
    
    @Persisted var macAddress: String
    @Persisted var phoneNumber: String
    @Persisted var action: String = "1" // 1 for lock/unlock?, is static for now 
    
//    let dateFormatter: DateFormatter = DateFormatter()
    // okay, dateFormatter does not follow Encodable, for JSONSerialization to post logs
    
    
    convenience init(macAddress: String, phoneNumber: String) {
        self.init()
        
        self.macAddress = macAddress
        self.phoneNumber = phoneNumber
        
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ" // ISO 8601, internationally accepted date and time format
        
        
        self.date = ISO8601DateFormatter().string(from: Date())
    }

    // "Only unmanaged Realm objects can be encoded using automatic Codable synthesis. You must explicitly define encode(to:) on your model class to support managed Realm objects."
    
    // manual encode(to) has to be written for Realm handled objects, which is basically encoding the attributes invidually
    
    enum CodingKeys: String, CodingKey {
            case date
            case macAddress
            case phoneNumber
            case action
        }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(macAddress, forKey: .macAddress)
        try container.encode(phoneNumber, forKey: .phoneNumber)
        try container.encode(action, forKey: .action)
    }
    
}
