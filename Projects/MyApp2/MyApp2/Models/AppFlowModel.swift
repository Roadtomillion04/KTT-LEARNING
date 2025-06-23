//
//  LoginModel.swift
//  Expense Mangement
//
//  Created by Nirmal kumar on 12/06/25.
//

import Foundation
import SwiftUI

//class AppState: ObservableObject {
//    @Published var is_logged_in: Bool
//    
//    init(is_logged_in: Bool) {
//        self.is_logged_in = is_logged_in
//    }
//}
    

@main
struct AppFlow: App {
//    @ObservedObject var appState = AppState(is_logged_in: false)
    
//    @State var is_logged_in: Bool = false
    
    @State var sign_in_success: Bool = false
    
    
    var body: some Scene {
        WindowGroup {
            
//            if is_logged_in == false {
            
//            NavigationStack {
//                
//                NavigationDestination(destination: UserLoginView(is_logged_in: self.$is_logged_in), isActive: self.$is_logged_in, label: { EmptyView() })
//                
//                
//            }
                
//            } else {
                
                    
//            }
            
            
            Group {
                if sign_in_success {
                    ExpensesView()
                }
                
                else {
                    
                    UserLoginView(sign_in_success: self.$sign_in_success)
                    
                }
            }
            
            
            
        }
    }
    
    
    
    
    
    
}

