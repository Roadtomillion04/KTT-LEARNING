//
//  DateExtension.swift
//  DriverApp
//
//  Created by Nirmal kumar on 09/10/25.
//

import Foundation

extension Date {
    
    func toString(format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
}
