//
//  NotificationService.swift
//  BluetoothPairing
//
//  Created by Nirmal kumar on 22/07/25.
//

import Foundation
import UserNotifications
import UIKit // also UIKit is for open settings in iphone, swiftui cant do that yet


@MainActor // oh and for UIkit to open system settings, the task should be executed in main thread, UI updates should not be done in background threads
final class NotificationService: ObservableObject {
    
    private var current = UNUserNotificationCenter.current()
    
    init() {
        requestAuthorization()
    }
    
    
    func checkNotificationEnabled() -> Bool {
        
        var notificationEnabled: Bool?
        
        current.getNotificationSettings(completionHandler: { notificationPermission in
            
            switch notificationPermission.authorizationStatus {
                
            case .authorized:
                print("notification enabled")
                notificationEnabled = true
                break
                
            case .denied:
                print("not enabled notification")
//                self.openNotificationSettings()
                break
                
            default:
                print("other")
                break
                
            }
            
        })
        
        return notificationEnabled == true
        
    }
    
    
    // it open the settings in simulator
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
        
        // scheduling should be something like this
        var scheduledNotification = DateComponents()
        scheduledNotification.hour = 10
        scheduledNotification.minute = 28
        let trigger = UNCalendarNotificationTrigger(dateMatching: scheduledNotification, repeats: true)
        // repeats true is for everyday and false for one time, and also is useless for local pushing, as if app is closed no program is running, so scheduled is for remote
        
        let request = UNNotificationRequest(
        
            identifier: UUID().uuidString,
            content: notificationContent,
            trigger: UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false) // 1 is seconds
//            trigger: trigger
        )
        
        current.add(request)
        
    }
    
    
    func cancelScheduledNotifications() {
        current.removeAllPendingNotificationRequests() // description says remove local only
    }
    
}
