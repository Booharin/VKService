//
//  AppDelegate.swift
//  vk
//
//  Created by Александр on 17.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate {
  
  var window: UIWindow?
  let remoteNotification = RemoteNotification()
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    FirebaseApp.configure()
    Messaging.messaging().delegate = self
    UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
    
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
    
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {

  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {

  }
  
  func applicationWillTerminate(_ application: UIApplication) {

  }
  
  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
    
    let tokenParts = deviceToken.map { data -> String in
      return String(format: "%02.2hhx", data)
    }
    
    let token = tokenParts.joined()
    print("Device Token: \(token)")
    userDefaults.set(token, forKey: "RegistrationToken")
  }
  
  func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Failed to register: \(error)")
  }
  
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
  }
  
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {

  }
  
  func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {

    if let newData = remoteNotification.goFetch() {
      print("New Data loaded: \(newData)")
      completionHandler(.newData)
    }
    completionHandler(.noData)
  }
  
}

