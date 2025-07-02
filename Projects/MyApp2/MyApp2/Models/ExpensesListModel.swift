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
    
    // originProperty name "expenses_list" has to be same in Parent class
    @Persisted(originProperty: "expenses_list") var user: LinkingObjects<User>
    
    convenience init(name: String, amount: Int, category: String, date: Date) {
        self.init()
        
        self.name = name
        self.amount = amount
        self.category = category
        self.date = date
        
        //
        let formatter = DateFormatter()
//        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy'-'MM'-'dd"
        
        let get_string_date_from_timestamp = formatter.string(from: self.date)
   
        
        // date formatting no work for now, so let's handle with strings
        self.date_without_timestamp = String(String(get_string_date_from_timestamp).prefix(10))
        
    }
        
}
