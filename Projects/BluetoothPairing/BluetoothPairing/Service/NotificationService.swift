//
//  NotificationService.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 22/07/25.
//

import Foundation
import UserNotifications
import UIKit


@MainActor
class NotificationService: ObservableObject {
    
    private var current = UNUserNotificationCenter.current()
    
    init() {
        requestAuthorization()
    }
    
    
    func checkAuthorization() {
        current.getNotificationSettings(completionHandler: { notificationPermission in
            
            switch notificationPermission.authorizationStatus {
                
            case .authorized:
                print("Mmm")
                
            case .denied:
                print("araa")
                self.openNotificationSettings()
                
            default:
                print("...")
                
            }

        })
    }
    
    // bro it just open the settings in simulator, maybe work in real phone?
    func openNotificationSettings() {
        if let url = URL(string: UIApplication.openNotificationSettingsURLString) {
            Task { // is basically asynchorus for non asynochourus functions
                UIApplication.shared.open(url)
            }
        }
    }
    
    
    // I think is one time event, popup asking allow or deny just like Core Bluetooth
    func requestAuthorization() {
        current.requestAuthorization(options: [.alert, .sound, .providesAppNotificationSettings]) { (success, error) in
            if let error = error {
                print(error)
            } else {
               print("ok")
            }
        }
    }
    
    // the term push generally say is from Apple push network, remotely, but here we doing local notification
    func pushNotification(peripheralName: String) {
        
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = "Connected with \(peripheralName)"
        notificationContent.subtitle = "Bluetooth connection stays active in background"
        notificationContent.sound = .default
        
        
        let request = UNNotificationRequest(
        
            identifier: UUID().uuidString,
            content: notificationContent,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            
        )
        
        current.add(request)
        
    }
    
    
}
