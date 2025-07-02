//
//  BankModel.swift
//  MyApp2
//
//  Created by Nirmal kumar on 16/06/25.
//


import Foundation
import RealmSwift


//protocol BankProtocol {
//    static var amount: Int { get set }
//    
//    static func distribute(_ _amount: Int)  -> Int
//    static func recieve(_ _amount: Int)
//}

//extension BankProtocol {
//    
//    static func distribute(_ _amount: Int)  -> Int {
//        
//        if _amount > amount {
//            return 0
//        }
//        
//        amount -= _amount
//        
//        return _amount
//        
//    }
//    
//    static func recieve(_ _amount: Int) {
//        amount += _amount
//    }
//    
//}


class Bank: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var amount: Int = 50_000

    
    func distribute(_ _amount: Int)  -> Int {
        
        if _amount > self.amount {
            return 0
        }
        
        self.amount -= _amount
        
        return _amount
        
    }
    
    func receieve(_ _amount: Int) {
        self.amount += _amount
    }
    
}


class UserBank: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var balance: Int
    
    @Persisted var bank_name: String
    @Persisted var account_number: String
    
    @Persisted var receieve_amount: Int
    @Persisted var spent_amount: Int
    
    @Persisted(originProperty: "bank_account") var user: LinkingObjects<User>
    
    // Realm swift on their doc, suggest you to use convenience init
    convenience init(bank_name: String, account_number: String) {
        self.init()
        
        self.bank_name = bank_name
        self.account_number = account_number
        
        self.balance = Bank().distribute(1000)
        
    }
    
    // for Expense Add check, if amount exceeds than in balance, Expense is not added
    func distribute(_ _amount: Int) -> Bool {
        
        // just cancel out 
        if _amount > self.balance {
            return false
        }
        
        self.spent_amount += _amount
        
        self.balance -= _amount
        
        return true
        
    }
    
    // is for delete/edit amount of Expense, receieve is only for credits (as it has income)
    func add_balance(_ _amount: Int) {
        self.balance += _amount
    }
    
    
    func receieve(_ _amount: Int) {
        
        self.balance += _amount
        
        self.receieve_amount += _amount
        
    }
    
    
//    deinit {
//        Bank().receieve(self.balance)
//    }
    
}
