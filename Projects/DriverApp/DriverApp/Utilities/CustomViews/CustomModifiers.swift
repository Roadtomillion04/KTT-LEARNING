//
//  TextFieldModifier.swift
//  DriverApp
//
//  Created by Nirmal kumar on 01/09/25.
//

import SwiftUI
//
//struct TextFieldModifier: ViewModifier { // could also do extension View to make it available as a modifier anywhere in the project
//
//    func body(content: Content) -> some View {
//        content
//            .foregroundStyle(.black)
//            .keyboardType(.numberPad)
//            .textContentType(.telephoneNumber)
//            .padding(12)
//            .background(RoundedRectangle(cornerRadius: 5).fill(Color(hex: 0xF1F5F9)).shadow(radius: 1))
//            .font(Font.custom("Monaco", size: 20))
//           
//    }
//    
//}


struct CustomTextField: View {
    
    var icon: String
    var title: String
    @Binding var text: String
    
    
    var show: Bool
    
    init(icon: String, title: String, text: Binding<String> = .constant(""), show: Bool = true) {
        
        self.icon = icon
        self.title = title
        self._text = text
        self.show = show
        
    }
    
    var body: some View {
        
        if show {
            
            HStack(alignment: .center, spacing: 10) {
                
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 1) {
                    
                    Text(title)
                        .font(Font.custom("Monaco", size: 14))
                        .foregroundColor(Color(.systemGray))
                    
                    TextField("", text: $text)
                        .font(Font.custom("Monaco", size: 16))
            
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
        }
        
    }
}


struct SaveButtonModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        
        content
            .font(Font.custom("Monaco", size: 17.5))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.teal)
            .cornerRadius(10)
        
            

    }
    
}

