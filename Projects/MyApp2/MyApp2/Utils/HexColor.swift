//
//  HexColor.swift
//  MyApp2
//
//  Created by Nirmal kumar on 20/06/25.
//

import Foundation
import SwiftUI

// this enables to give hex color code

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
