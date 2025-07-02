//
//  LoginModel.swift
//  Expense Mangement
//
//  Created by Nirmal kumar on 12/06/25.
//

import Foundation
import SwiftUI


@main
struct StartApp: App {
    
    @StateObject private var realmManager = RealmManager()
    
    var body: some Scene {
        
        WindowGroup {
            
            AppFlow()
                .environmentObject(realmManager)
        }
        
    }
    
}


struct AppFlow: View {

    @EnvironmentObject var realmManager: RealmManager
    
    var body: some View {
     
        // on app open, no user pointer is created
        if realmManager.logged_user == nil {
            
            LoginView(realmManager: realmManager)
                            
        }
        
        else {
            // as user pointer logged_user is @Published, here condition is checked again and moves to ExpensesView
            ExpensesView(realmManager: realmManager)
            
        }
        
    }
    
}
