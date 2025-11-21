//
//  Languages.swift
//  DriverApp
//
//  Created by Nirmal kumar on 03/09/25.
//

import SwiftUI


fileprivate struct CheckBox: Hashable {
    var name: String
    var identifier: Locale
}

struct LanguagesView: View {
    
    @EnvironmentObject var coordinator: AppCoordinator
    @EnvironmentObject var languageManager: LanguageManager
    
    @State private var languages: [CheckBox] = [
           CheckBox(name: "English", identifier: Locale(identifier: "en")),
           CheckBox(name: "Tamil", identifier: Locale(identifier: "ta")),
           CheckBox(name: "Hindi", identifier: Locale(identifier: "hi"))
       ]
    
    @State private var showLanguageChoice: Bool = false
    
    // placeholder
    @State private var languageSelected: CheckBox = CheckBox(name: "English", identifier: Locale(identifier: "en"))
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 25) {
            
            Text("Language")
            
            Button("title_list_preference") {
                showLanguageChoice = true
            }
            .font(Font.custom("ArialRoundedMTBold", size: 20))
                   
        }
        .onAppear {
            languageSelected = languages.filter( { $0.identifier == languageManager.selectedLanguage } ).first!
        }
        
        .customAlert(isPresented: $showLanguageChoice) {
            
            VStack(spacing: 25) {
                
                Text(LocalizedStringResource("dialog_title_list_preference"))
                
                Picker("", selection: $languageSelected) {
                    ForEach(languages, id: \.self) { language in
                        Text(language.name)
                    }
                }
                .tint(.black)
                .pickerStyle(.inline)
                .onChange(of: languageSelected) { old, new in
                    languageManager.selectedLanguage = new.identifier
                    showLanguageChoice = false
                    coordinator.pop()
                }
             
                Button("cancel") {
                    showLanguageChoice = false
                }
                .font(Font.custom("Monaco", size: 20))
                .foregroundStyle(.red)
            }
            .padding()
            
        }
            
    }
    
}



#Preview {
//    Languages()
}
