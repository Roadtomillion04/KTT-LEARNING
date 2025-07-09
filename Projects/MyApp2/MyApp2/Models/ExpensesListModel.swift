//
//  ExpensesListModel.swift
//  MyApp2
//
//  Created by Nirmal kumar on 26/06/25.
//

import Foundation
import RealmSwift


class Expense: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var name: String
    @Persisted var amount: Int
    @Persisted var category: String
    @Persisted var date: Date
    
    @Persisted var date_without_timestamp: String
    
    @Persisted var notes: String // this notes is newly added in realm SchemaVersion 2
    
    // originProperty name "expenses_list" has to be same in Parent class
    @Persisted(originProperty: "expenses_list") var user: LinkingObjects<User>
    
    convenience init(name: String, amount: Int, notes: String, category: String, date: Date) {
        self.init()
        
        self.name = name
        self.amount = amount
        self.notes = notes
        self.category = category
        self.date = date
        
        
        //
        let formatter = DateFormatter()
//        formatter.timeStyle = .none
        formatter.dateFormat = "MMM d, yyyy"
        
        self.date_without_timestamp = formatter.string(from: self.date)
        
//        print(formatter.date(from: self.date_without_timestamp)!)
        
    }
        
}
