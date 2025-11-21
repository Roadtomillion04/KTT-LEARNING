//
//  LocalizeManager.swift
//  DriverApp
//
//  Created by Nirmal kumar on 19/11/25.
//

import Foundation
import SwiftUI

class LanguageManager: ObservableObject {
    @Published var selectedLanguage: Locale = Locale.current {
        didSet {
            UserDefaults.standard.set([selectedLanguage.identifier], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    }

    init() {
        if let preferredLanguages = UserDefaults.standard.stringArray(forKey: "AppleLanguages"),
           let firstLanguage = preferredLanguages.first {
            selectedLanguage = Locale(identifier: firstLanguage)
        }
    }
}
