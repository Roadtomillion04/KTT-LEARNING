//
//  SideMenuView.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 07/08/25.
//

import SwiftUI

struct SideMenuView: View {
    
    @State private var path = NavigationPath()
    
    var body: some View {
        
        VStack {
            
            NavigationStack(path: $path) {
                
//                Button("Authenticator") {
//                    path.append("AuthenticatorView")
//                }
                
            }
            .navigationDestination(for: String.self) { paths in
                switch paths {
                    case "AuthenticatorView":
                        Text("")
                    default:
                        Text("")
                }
            }
            
        
        }
        .opacity(0.5)
        .background(.gray)
        .ignoresSafeArea()
        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.height)
        
    }
}

#Preview {
//    SideMenuView()
}
