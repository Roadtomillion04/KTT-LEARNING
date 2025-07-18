//
//  ConnectedPeripherals.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 17/07/25.
//

import Foundation
import RealmSwift


class PairedPeripherals: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    
//    Generic struct 'Persisted' requires that 'CBPeripheral' conform to '_Persistable'
//    @Persisted var peripheral: CBPeripheral
    
    
    // so let's store only the important properties
    @Persisted var peripheralName: String
    @Persisted var peripheralUUID: String // CBUUID also same issue
    
    // thinking about storing Commands too, but let's pass for now
    
    // so, CBUUID can be converted from string, this has to be shown in Home Screen when app launched on clicking this we have to connect to this peripheral with UUID, as for the bonding/paired status your mobile manages that so no concern about that
    
    
    @Persisted(originProperty: "pairedPeripheral") var user: LinkingObjects<User>
    
    convenience init(peripheralName: String, peripheralUUID: String) {
        self.init()
        
        self.peripheralName = peripheralName
        self.peripheralUUID = peripheralUUID
       
    }
    
}
