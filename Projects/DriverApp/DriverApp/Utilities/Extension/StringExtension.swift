//
//  StringExtension.swift
//  DriverApp
//
//  Created by Nirmal kumar on 09/10/25.
//

import Foundation

extension String {
    
    func dateFormatting(format: String = "dd/MM/yyyy HH:mm a") -> String {
        
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let utcDate = isoFormatter.date(from: self) ?? nil
        
        
        if utcDate == nil {
            return "-"
        }
        
        // to ist
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = .current
        
        return dateFormatter.string(from: utcDate!)
    }

    
    func toDouble() -> Double? {
        return Double(self)
    }
    
    
}


extension Double {
    
    func round() -> String {
        let formattedString = String(format: "%.2f", self)
        return formattedString
    }
    
}

extension Data {
    
   mutating func append(_ string: String) {
    
       if let data = string.data(using: .utf8) {
         append(data)
      }
       
   }
    
}
