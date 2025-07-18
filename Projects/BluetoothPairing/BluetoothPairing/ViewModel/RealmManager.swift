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
    
    
    @Published var pairedPeripheralList: [PairedPeripherals] = []
    
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
            
            readPeripheral()
        }
        
    }
    
    
    func openRealm() {
        
        do {
            
            let config = Realm.Configuration(schemaVersion: 1)
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
                
                readPeripheral()
                
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
    
    
    func addPeripheral(name: String, UUID: String) {
        
        guard let realm = localRealm else { return }
        
        guard let user = currentUser else { return }
        
        // same case here, check for duplicates pairing just in case, okay so I had this doubt UUID might be chagning well the answer is no for the peripheral
        if realm.objects(PairedPeripherals.self).filter("peripheralName == '\(name)' AND peripheralName == '\(UUID)'").first != nil {
            
                return
            
        }
        
        do {
            
            let newPeripheral = PairedPeripherals(peripheralName: name, peripheralUUID: UUID)
            
            try realm.write {
                
                user.pairedPeripheral.append(newPeripheral)
                
            }
            
            readPeripheral()
            
        }
        
        catch {
            print("Error adding peripheral: \(error)")
        }
        
    }
    
    
    func readPeripheral() {
        
        guard let realm = localRealm else { return }
               
        guard let user = currentUser else { return }
        

        print("bi")
        
        let pairedPeripherals = realm.objects(User.self).filter(NSPredicate(format: "_id == %@", user._id)).first?.pairedPeripheral
        
        
        pairedPeripheralList.removeAll()
        
        pairedPeripherals?.forEach { peripheral in
            pairedPeripheralList.append(peripheral)
        }
        
        // as @Published is used, it automatically announces to all objects and refresh the view
        
    }
    
}
