//
//  LockTOTPService.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 01/08/25.
//

import Foundation
import CryptoKit


class LockTOTPService: ObservableObject {

 
    func generateSymmetricKey(deviceName: String, macAddress: String?, time: Date = Date()) -> SymmetricKey {
        
        let formatter = ISO8601DateFormatter()
        let timestamp = formatter.string(from: time)

        let inputString = "\(deviceName)+\(macAddress ?? "unknown")+\(timestamp)"
        let inputData = Data(inputString.utf8)

        
        let hash = Insecure.SHA1.hash(data: inputData)
 
        return SymmetricKey(data: Data(hash))
        
    }
    
    func generateTOTP(key: SymmetricKey, timeStep: TimeInterval = 30, digits: Int = 6) -> String {
        let timestamp = Date().timeIntervalSince1970
        let counter = UInt64(timestamp / timeStep)
        
        var bigEndianCounter = counter.bigEndian
        let counterData = Data(bytes: &bigEndianCounter, count: MemoryLayout.size(ofValue: bigEndianCounter))
        
        let hmac = HMAC<Insecure.SHA1>.authenticationCode(for: counterData, using: key)
        let hmacData = Data(hmac)
        
        let offset = Int(hmacData.last! & 0x0F)
        let truncated = hmacData[offset..<offset+4]
        
        let code = truncated.withUnsafeBytes { ptr in
            ptr.loadUnaligned(as: UInt32.self)
        }.bigEndian & 0x7FFFFFFF
        
        let otp = code % UInt32(pow(10, Float(digits)))
        return String(format: "%0*u", digits, otp)
    }
    
}
