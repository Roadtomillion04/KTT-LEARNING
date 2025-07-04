//
//  LoginModel.swift
//  Expense Mangement
//
//  Created by Nirmal kumar on 12/06/25.
//

import Foundation
import SwiftUI


// Detailed @ObservedObject and @EnvironmentObject explanation - https://stackoverflow.com/questions/63343819/what-is-the-difference-between-environmentobject-and-observedobject


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

    @EnvironmentObject var realmManager: RealmManager // environemnt object is used here, to keep Appflow(), if observerd object we need to pass initializer
    
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
