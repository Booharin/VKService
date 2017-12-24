//
//  LocalNotification.swift
//  vk
//
//  Created by Александр on 06.12.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import UserNotifications

class VKLocalNotification {
    let content = UNMutableNotificationContent()
    
    func postLocalNotification() {
        
        if let title = userDefaults.string(forKey: "NameOfLastMessage") {
            content.title = title
        }
        if let body = userDefaults.string(forKey: "TextOfLastMessage") {
            content.body = body
        }
        content.sound = .default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let requestIndentifier = "message"
        let request = UNNotificationRequest(identifier: requestIndentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error) in
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [requestIndentifier])
        })
        
        if userDefaults.integer(forKey: "RequestsCount") > 0 {
            content.title = ""
            content.body = "Кто-то хочет в друзья"
            content.sound = .default()
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
            let requestIndentifier = "friend"
            let request = UNNotificationRequest(identifier: requestIndentifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error) in
                UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [requestIndentifier])
            })
        }
    }
}
