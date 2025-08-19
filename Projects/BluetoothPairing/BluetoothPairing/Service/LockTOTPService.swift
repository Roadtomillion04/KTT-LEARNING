//
//  LockTOTPService.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 01/08/25.
//

import Foundation
import CryptoKit


final class LockTOTPService: ObservableObject {
    
    var totpCode: String = ""
    
    let step: TimeInterval = 60
    let digits = 4
    let initialTime: TimeInterval = 0
    let flexibility: TimeInterval = 60
    
    private let secretKey = Bundle.main.infoDictionary?["SECRET_KEY"] as? String ?? ""
    
    
    func timeFactor(for date: Date = Date()) -> UInt64 {
        
        let timeSinceInitial = date.timeIntervalSince1970 - self.initialTime
        
        return UInt64(timeSinceInitial / self.step)
        
    }
    
    
    private func hmacSha1(key: Data, message: Data) -> Data {
        
        let keySym = SymmetricKey(data: key)
        let mac = HMAC<Insecure.SHA1>.authenticationCode(for: message, using: keySym)
        
        return Data(mac)
        
    }
    
    
    private func truncate(_ hash: Data) -> String {
        
        let offset = Int(hash.last! & 0x0f)
        let subdata = hash.subdata(in: offset..<offset+4)
        var number = UInt32(bigEndian: subdata.withUnsafeBytes { $0.load(as: UInt32.self) }) & 0x7fffffff
        
        number = number % UInt32(pow(10, Float(self.digits)))
        
        return String(format: "%0*u", self.digits, number)
        
    }
    
    
    func generateTOTP(name: String, time: Date = Date()) -> String {
        
        let input = name + secretKey.replacingOccurrences(of: "\"", with: "")  // secretKey had quotes on getting from infoDict
        let timeHex = String(format: "%016X", timeFactor(for: time))
        let timeData = Data(hexString: timeHex)
        let keyData = input.data(using: .utf8)!
        let hash = hmacSha1(key: keyData, message: timeData)
        
        totpCode = truncate(hash)
        
        return truncate(hash)
        
    }
    
    
    // so no server side validation, authenticator runs on asset tracker just like google authenticator for every lock?, and user enter otp to this app and verify locally
    func verifyTOTP(name: String, otp: String, time: Date = Date(), flexible: Bool = false) -> Bool {
        
        if generateTOTP(name: name, time: time) == otp {
            return true
        }
        
        if flexible {
            let past = time.addingTimeInterval(-self.flexibility)
            return generateTOTP(name: name, time: past) == otp
        }
        
        return false

    }
    
}

extension Data {
    
    init(hexString: String) {
        
        var data = Data()
        var tempHex = hexString
        if tempHex.count % 2 != 0 {
            tempHex = "0" + tempHex
        }
        
        for i in stride(from: 0, to: tempHex.count, by: 2) {
            
            let start = tempHex.index(tempHex.startIndex, offsetBy: i)
            let end = tempHex.index(start, offsetBy: 2)
            let byteString = tempHex[start..<end]
            if let byte = UInt8(byteString, radix: 16) {
                data.append(byte)
                
            }
        }
        
        self = data
        
    }
}
