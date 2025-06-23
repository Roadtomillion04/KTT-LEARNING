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
//    @Persisted va
    
    static var amount: Int = 50_000
    
    
    
    static func distribute(_ _amount: Int)  -> Int {
        
        if _amount > amount {
            return 0
        }
        
        amount -= _amount
        
        return _amount
        
    }
    
    static func receieve(_ _amount: Int) {
        amount += _amount
    }
    
}


class UserBank: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var amount: Int = Bank.distribute(1000)
    
    @Persisted var bank_name: String
    @Persisted var account_number: String
    
    @Persisted var receieve_amount: Int
    @Persisted var spent_amount: Int
    
    // Realm swift on their doc, suggest you to use convenience init
    convenience init(bank_name: String, account_number: String) {
        self.init()
        
        self.bank_name = bank_name
        self.account_number = account_number
        
        self.amount = Bank.distribute(1000)
        
    }
    
    
    func distribute(_ _amount: Int)  -> Int {
        
        if _amount > self.amount {
            return 0
        }
        
        self.spent_amount += _amount
        
        self.amount -= _amount
        
        return _amount
        
    }
    
    func receieve(_ _amount: Int) {
        self.amount += _amount
        
        self.receieve_amount += _amount
        
    }
    
    
    deinit {
        Bank.receieve(self.amount)
    }
    
}
