//
//  UserModel.swift
//  MyApp2
//
//  Created by Nirmal kumar on 26/06/25.
//

import Foundation
import RealmSwift

// I think this is standard way of Creating object with Realm
class User: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var user_name: String
    @Persisted var user_password: String
    @Persisted var user_email: String
    
    @Persisted var user_bank_name: String
    @Persisted var user_account_number: String
    
    @Persisted var bank_account: UserBank? // it has to optional because of Objectproperty, Realm documentaion say
    @Persisted var expenses_list: List<Expense>
    
    convenience init(user_name: String, user_password: String, user_email: String, bank_name: String, account_number: String) {
        self.init()
        
        self.user_name = user_name
        self.user_password = user_password
        self.user_email = user_email
        self.user_account_number = account_number
        self.user_bank_name = bank_name
    
        self.bank_account = UserBank(bank_name: bank_name, account_number: account_number)
        
    }
    
    
    
}
