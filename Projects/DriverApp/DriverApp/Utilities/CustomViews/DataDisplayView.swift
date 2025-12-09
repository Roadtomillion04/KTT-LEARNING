//
//  DataDisplayView.swift
//  DriverApp
//
//  Created by Nirmal kumar on 13/10/25.
//

import SwiftUI

struct IconData: View {
    
    var icon: String?
    var image: String?
    
    var title: LocalizedStringResource?
    var value: String
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 10) {
            
            if let icon = icon {
                
                Image(systemName: icon)
                    .font(.headline)
                    .foregroundColor(Color(hex: 0x5A5A5A))
                
            }
            
            if let image = image {
                
                Image(image)
                    .font(.headline)
                    .foregroundColor(Color(hex: 0x5A5A5A))
                
            }
       
            
            VStack(alignment: .leading, spacing: 2.5) {
                
                if let title = title {
                    Text(title)
                        .font(Font.custom("AriSanPro-Medium", size: 13))
                        .foregroundColor(Color(.systemGray))
                }
                
                Text(value)
                    .font(Font.custom("Monaco", size: 12.5))
        
            }
        }
    }
}



#Preview {
//    DataDisplayView()
}
