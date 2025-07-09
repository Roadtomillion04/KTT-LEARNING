//
//  RealmManager.swift
//  MyApp2
//
//  Created by Nirmal kumar on 26/06/25.
//

import Foundation
import RealmSwift

// think it of Realm is a box and we opening the box and storing data inside
// But opening Realm might throw error, if configs are wrong so it has to Optional as per documentation

class RealmManager: ObservableObject {
    
    private(set) var localRealm: Realm?
    
    // This will be the most important thing to CRUD in local storage, there is no threading (multi users/devices at same time), so in one device one user is handled at a time
    @Published var logged_user: User? // is Optional cause we'll be deinit on Logout Press
    // and Published is every time the logged_user is modified, it publishes to every object
    
    @Published var expense_dict: [String: [Expense]] = [:] // this will contain Date and Expense
    
    @Published var expense_array: [Expense] = []
    
    @Published var chart_dict: [String: [Expense]] = [:] // this contains category and Expense for charting
 
    
    init() { // calls when class in instansiated
        openRealm()
       
//        print(Realm.Configuration.defaultConfiguration.fileURL!) // -> Realm path for the simulator
    }
    
    func openRealm() {
        
        do {
            // schemaVersion is like build version, let's say if you update app in future you could migrate from 1 to 2 with all new features added
//            let config = Realm.Configuration(schemaVersion: 2) { migration, oldSchemaVersion in
//                if oldSchemaVersion == 1 {
//                    // migration.objects give you only one that is oldObject I think
//                    migration.enumerateObjects(ofType: "Expense") { oldExpense, newExpense in
//                        newExpense?["notes"] = "" // this set empty string for all rows
//                        
//                    }
//                }
//                
//                // to rename property/column
//                // migration.renameProperty(onType: ObjectModel, from: , to: )
//            }
            
            // migration worked! - Credit -> https://ali-akhtar.medium.com/migration-with-realm-realmswift-part-6-11c3a7b24955
        
            
            
            // 2nd migration for formatting Expense.date_without_timestamp to format month day, year
            
//            let date_formatter = DateFormatter()
//            
//            date_formatter.dateFormat = "MMM d, yyyy"
//            
//            let config = Realm.Configuration(schemaVersion: 3) { migraion, oldSchemaVersion in
//                if oldSchemaVersion == 2 {
//                    migraion.enumerateObjects(ofType: "Expense") { oldExpense, newExpense in
//                        newExpense?["date_without_timestamp"] = date_formatter.string(from: oldExpense?["date"] as! Date) // oldExpense is just for semantics
//                    }
//                }
//            }
            
            let config = Realm.Configuration(schemaVersion: 3)
            
            Realm.Configuration.defaultConfiguration = config
            
            localRealm = try Realm()
            
            
        } catch {
            
            print("Opening Error \(error)")
            
        }
    
    }
    
    // let's handle anything related to Realm here, and also Using Bool as return type has one advantage that is I can change screen or show alert in View based on return
    
    
    func login_user(user_name: String, user_password: String) -> Bool {
        
        // if can't open realm, we immediately return false
        guard let realm = localRealm else { return false }
     
        if let user = realm.objects(User.self).filter("user_name == '\(user_name)' and user_password == '\(user_password)'").first {
            
            // so setting logged_user here, will publish to listening objects, thus changing view in AppFlowModel
            logged_user = user
            
            read_expense()
            
            
            return false // cause we are catching login failed
            
        }
        
        return true
        
    }
    
    
    func register_user(user_name: String, user_email: String, user_password: String, user_bank_name: String, user_account_number: String) -> Bool {
        
        guard let realm = localRealm else { return false }
        
        do {
            
            let newUser = User(user_name: user_name, user_password: user_password, user_email: user_email, bank_name: user_bank_name, account_number: user_account_number)
            
            try realm.write {
                realm.add(newUser)
            }
            
        } catch {
            
            print("Register Error \(error)")
            return false
                
        }
        
        return true
        
    }
    
    
    func create_expense(name: String, amount: Int, notes: String, category: String, date: Date) -> Bool {
        
        guard let realm = localRealm else { return false }
        
        // this is important, otherwise after logout, logged_user.write may produce error
        guard let user = logged_user else { return false }
        
        do {
            
            let newExpense = Expense(name: name, amount: amount, notes: notes, category: category, date: date)
            
            try realm.write {
                
                if category == "Credit" {
                    // let's update the Expense list here, to display on Expenses ListView
                    let credit_amount: Int = amount
                    
                    user.bank_account?.receieve(credit_amount)
                    
                    user.expenses_list.append(newExpense)
                    
                    read_expense()
                    
                    return true
        
                }
                
                
                // only adding if user has enough amount in bank
                if user.bank_account?.distribute(newExpense.amount) == true {
                    
                    user.expenses_list.append(newExpense)
                    
                    read_expense()
                    
                    return true

                }
                
                return true // all these return true cause swift forces to add return in all scope
                
            }
            
        } catch {
            print("Add Expenese Error \(error)")
            
            return false
        }
        
       return true
        
    }
    
    
    func read_expense() {
        
        guard let realm = localRealm else { return }
        
        guard let user = logged_user else { return }
        
        let get_expenses_from_realm = realm.objects(User.self).filter(NSPredicate(format: "_id == %@", user._id)).first?.expenses_list
        
        // okay so I was getting Out of Bounds error while directly delaing with List<Expense> on deleting, and also I was updating expense array in the views, which is not good practise
//        expense_dict.removeAll() 
        // Update: Changing this to dict, I want to use date as List Section now so yeah
        
        expense_array = []
        expense_dict.removeAll()
        chart_dict.removeAll()
        
        
        get_expenses_from_realm?.forEach { expense in
            expense_array.append(expense)
        }
        
        
        // This is shortcut grouping for duplicate keys, stores in String, [Array] as I intended
        expense_dict = Dictionary(grouping: expense_array, by: { $0.date_without_timestamp })
        
            
//        print(expense_dict.compactMapValues({ $0.filter( { $0.category == "Food" }) }) )
        
        
        // Category: [Expense] array, let's handle aggregating in the View
        chart_dict = Dictionary(grouping: expense_array, by: { $0.category })
       
        
    }
    
    
    // for whatever reason sending id: \._id from ForEach and here id conforming Object Id matches
    
    func update_expense(id: ObjectId, name: String, amount: Int, notes: String, category: String, date: Date) {
        
        guard let realm = localRealm else { return }
        
        // this is important, otherwise after logout, logged_user.write may produce error
//        guard let user = logged_user else { return }
        
        do {
            
            guard let expense_to_updated = localRealm?.objects(Expense.self).filter(NSPredicate(format: "_id == %@", id)) else { return }
            
            guard let user = logged_user else { return }
            
            let old_amount = expense_to_updated.first?.amount ?? 0
            
            
            try realm.write {
                
                // update bank before write
                
                if amount > old_amount { // charging bank in this case, extra amount
                    user.bank_account?.distribute( amount - old_amount )
                }
                
                else if old_amount > amount { // in case of amount edited is less than old one
                    user.bank_account?.add_balance( old_amount - amount )
                }
                
                expense_to_updated.first?.name = name
                expense_to_updated.first?.amount = amount
                expense_to_updated.first?.notes = notes
                expense_to_updated.first?.category = category
                expense_to_updated.first?.date = date
                
            }
            
            // update expense array and refresh view
            read_expense()
            
        } catch {
            print("Error updating \(error)")
        }
        
    }
    

    func delete_expense(id: ObjectId) {
        
        guard let realm = localRealm else { return }
        
        // this is important, otherwise after logout, logged_user.write may produce error
        guard let user = logged_user else { return }
        
        do {
            
            guard let expense_to_deleted = localRealm?.objects(Expense.self).filter(NSPredicate(format: "_id == %@", id)) else { return }
           
            
            try realm.write {
                
                // let's also check if the deleted expense is a credit
                if expense_to_deleted.first?.category == "Credit" {
                    user.bank_account?.distribute(expense_to_deleted.first?.amount ?? 0)
                    
                    realm.delete(expense_to_deleted)
                    
                    read_expense()
                    
                    return
                }
                
                // update the bank on deletion before deletion
                user.bank_account?.add_balance(expense_to_deleted.first?.amount ?? 0)
                
                realm.delete(expense_to_deleted)
                
            }
            
            read_expense() // @Published refreshes the views, update in real time
            
        } catch {
            print("Delete Expenese Error \(error)")
        }
        
    }
    
  
    // let's unwrap Optionals here, forcing unwrap ! in Swiftui, on deiniting throws error
    func get_name() -> String {
        return logged_user?.user_name ?? ""
    }
    
    func get_email() -> String {
        return logged_user?.user_email ?? ""
    }
    
    func get_password() -> String {
        return logged_user?.user_password ?? ""
    }
    
    func get_bank_name() -> String {
        return logged_user?.user_bank_name ?? ""
    }
    
    func get_account_number() -> String {
        return logged_user?.user_account_number ?? ""
    }
    
    func get_bank_balance() -> Int {
        let balance: Int = logged_user?.bank_account?.balance ?? 0
        
        return balance
    }
    
    func get_spent_amount() -> Int {
        return logged_user?.bank_account?.spent_amount ?? 0
    }
    
    func get_income_amount() -> Int {
        return logged_user?.bank_account?.receieve_amount ?? 0
    }

    
    // just deinit user, and as published used, app flow returns us to login screen
    func logout() {
        logged_user = nil
    }
    
}
