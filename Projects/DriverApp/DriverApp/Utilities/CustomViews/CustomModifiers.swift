//
//  TextFieldModifier.swift
//  DriverApp
//
//  Created by Nirmal kumar on 01/09/25.
//

import SwiftUI


struct CustomTextField: View {
    
    var icon: String
    var title: String
    @Binding var text: String
    var show: Bool
    var keyboardType: UIKeyboardType

    
    init(
        icon: String,
        title: String,
        text: Binding<String> = .constant(""),
        show: Bool = true,
        keyboardType: UIKeyboardType = .default
    ) {
        self.icon = icon
        self.title = title
        self._text = text
        self.show = show
        self.keyboardType = keyboardType
    }
    
    var body: some View {
        
        if show {
            
            HStack(alignment: .center, spacing: 10) {
                
                Image(systemName: icon)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                VStack(alignment: .leading, spacing: 2.5) {
                    
                    Text(title)
                        .font(Font.custom("AriSan-Medium", size: 13))
                        .foregroundColor(Color(.systemGray))
                    
                    
                    TextField("", text: $text)
                        .font(Font.custom("Monaco", size: 12.5))
                        .keyboardType(keyboardType)
                    
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
            .font(Font.custom("Monaco", size: 15))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.teal)
            .cornerRadius(10)
    }
    
}




#Preview {
//    ViewExtension()
}
