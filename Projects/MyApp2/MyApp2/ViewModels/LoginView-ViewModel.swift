//
//  LoginView-ViewModel.swift
//  Expense Mangement
//
//  Created by Nirmal kumar on 13/06/25.
//

import Foundation
import RealmSwift

//extension UserLoginView {
//    
//
//    class ViewModel {
//        
//        private(set) var user_name: String = ""
//        private(set) var user_password: String = ""
//        
//        init(user_name: String, user_password: String) {
//            self.user_name = user_name
//            self.user_password = user_password
//        }
//        
//        func print_values() {
//            print("user name is \(self.user_name)")
//            print("user password is \(self.user_password)")
//        }
//
//    }
//    
//}




//class UserLoginInfo: Object, ObjectKeyIdentifiable {
//    
//    @Persisted(primaryKey: true) var _id: ObjectId
//    @Persisted var user_name: String
//    @Persisted var user_password: String
//    
//    convenience init(user_name: String, user_password: String) {
//        self.init()
//        
//        self.user_name = user_name
//        self.user_password = user_password
//        
//    }
//    
//}


// I think this is standard way of Creating object with Realm
class UserRegisterInfo: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var user_name: String
    @Persisted var user_password: String
    @Persisted var user_email: String
    
    @Persisted var user_bank_name: String
    @Persisted var user_account_number: String
    
    
    
    convenience init(user_name: String, user_password: String, user_email: String, bank_name: String, account_numer: String) {
        self.init()
        
        self.user_name = user_name
        self.user_password = user_password
        self.user_email = user_email
        self.user_account_number = account_numer
        self.user_bank_name = bank_name
    
        
    }
    
}
