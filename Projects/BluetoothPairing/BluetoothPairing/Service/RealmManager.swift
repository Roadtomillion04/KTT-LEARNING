//
//  RealmManager.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 17/07/25.
//

import Foundation
import RealmSwift


class RealmManager: ObservableObject {
    
    private(set) var localRealm: Realm?
    
    @Published var currentUser: User?
    
    
    init() {
        openRealm()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!) // -> Realm path for the simulator
        
        // also need to check if any of the saved users is loggedIn, i.e login status == true
        checkUserLoggedIn()
        
    }
    
    
    func checkUserLoggedIn() {
        guard let realm = localRealm else { return }
        
        // only one user can be online so no issues, also true does not work, YES works
        if let user = realm.objects(User.self).filter("loginStatus == YES").first {
            currentUser = user
            
        }
        
    }
    
    
    func openRealm() {
        
        do {
            
            let config = Realm.Configuration(schemaVersion: 1, deleteRealmIfMigrationNeeded: true)
            Realm.Configuration.defaultConfiguration = config
            localRealm = try Realm()
            
        }
        
        catch {
            print("Error opening Realm: \(error)")
        }
        
    }
    
    
    func registerNewUser(mobileNumber: String) {
        
        guard let realm = localRealm else { return }
        
        do {
        // since there's no login functionality, might well as check the user exists here before adding
        
            if let user = realm.objects(User.self).filter("mobileNumber == '\(mobileNumber)'").first {
                
                currentUser = user
                
                try realm.write { // modifying Realm Object outside write scope throws you error
                    currentUser?.loginStatus = true
                }

                
                return
                
            }
        

            let newUser = User(mobileNumber: mobileNumber)
            
            try realm.write {
    
                realm.add(newUser)
                newUser.loginStatus = true

            }
            
            currentUser = newUser
            
        }
        
        catch {
            print("Error adding user: \(error)")
        }
        
    }
    
    
    func loggoutCurrentUser() {
        
        guard let realm = localRealm else { return }
        
        do {
            
            try realm.write { // modifying Realm Object outside write scope throws you error
                currentUser?.loginStatus = false
            }
            
            currentUser = nil
            
        }
        
        catch {
            print("Error logging out user: \(error)")
        }
        
    }
    
    // Authenticator Model
    func createAuthenticator(name: String, macAddress: String) {
        
        guard let realm = localRealm else { return }
        
        do {
            
            // safe check if exists already before write
            guard let _ = realm.objects(Authenticator.self).filter("macAddress == '\(macAddress)'").first else { return }

            
            let newAuthenticator = Authenticator(name: name, macAddress: macAddress)
                        
            try realm.write {
                realm.add(newAuthenticator)
            }
            
        }
        
        catch {
            print("Error creating authenticator: \(error)")
        }
        
    }
    
    
    func getAllAuthenticators() -> [Authenticator] {
       
        guard let realm = localRealm else { return [] }
                
        return Array(realm.objects(Authenticator.self))
        
    }
    
    
    // UserActionLog Model
    func createUserActionLog(macAddress: String) {
        
        guard let realm = localRealm else { return }
        
        do {
            // new object for every new action/command
            let newUserActionLog = UserActionLog(macAddress: macAddress, phoneNumber: currentUser?.mobileNumber ?? "") // action is static 1, and date handled in Class init
            
            try realm.write {
                realm.add(newUserActionLog)
                
            }
            
        }
        
        catch {
            print("Error creating userActionLog: \(error)")
        }
        
    }
    
    
    func getUserActionLog() -> [UserActionLog] {
        
        guard let realm = localRealm else { return [] }

        let logs = Array(realm.objects(UserActionLog.self))
                
        return logs
            
    }
    
    
    func deleteAllUserActionLog() {
        
        guard let realm = localRealm else { return }
        
        do {
            try realm.write {
                realm.delete(realm.objects(UserActionLog.self))
            }
        }
        
        catch {
            print("Error deleting all userActionLog: \(error)")
        }
        
    }
    
}
