//
//  ExpensesView-ViewModel.swift
//  MyApp2
//
//  Created by Nirmal kumar on 16/06/25.
//

import Foundation
import RealmSwift


class ExpensesInfo: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var amount: Int
    @Persisted var category: String
    @Persisted var date: Date
    
    
    convenience init(name: String, amount: Int, category: String, date: Date) {
        self.init()
        
        self.name = name
        self.amount = amount
        self.category = category
        self.date = date
        
    }
    
}
