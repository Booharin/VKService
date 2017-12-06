//
//  LocalNotification.swift
//  vk
//
//  Created by Александр on 06.12.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotification {
  func showNoti
  let content = UNMutableNotificationContent()
  content.title = "Заголовок"
  content.body = "Уведомление"
  content.sound = .default()
  content.badge = 69
  
  let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30, repeats: false)
  let requestIndentifier = "example"
  let request = UNNotificationRequest(identifier: requestIndentifier, content: content, trigger: trigger)
  
  UNUserNotificationCenter.current().add(request, withCompletionHandler: {(error) in
  UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [requestIndentifier])
  })
}
