//
//  User.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 17/07/25.
//

import Foundation
import RealmSwift


final class User: Object, ObjectKeyIdentifiable {
    
    @Persisted(primaryKey: true) var _id: ObjectId
    
    @Persisted var mobileNumber: String
    @Persisted var loginStatus: Bool
    
    
    convenience init(mobileNumber: String) {
        self.init()
        
        self.mobileNumber = mobileNumber
        
        // well, what I'm trying to do is once they register like in Original app, next time on app open, Home page is greeting us so, only on logout View switch to login page, so let's do the same, since it's just a local app it's doesnt matter anyway
    }
                                            
}
