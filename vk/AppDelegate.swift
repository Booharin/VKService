//
//  AppDelegate.swift
//  vk
//
//  Created by Александр on 17.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit
import Firebase
//import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  //var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    // Override point for customization after application launch.
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
  }
  
//  func endBackgroundTask() {
//    print("Background task ended.")
//    UIApplication.shared.endBackgroundTask(backgroundTask)
//    backgroundTask = UIBackgroundTaskInvalid
//  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
//// здесь могла быть ваша задача
//    backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
//      // здесь начинается задача по истечении 3 минут
//      self?.endBackgroundTask()
//    }
//    assert(backgroundTask != UIBackgroundTaskInvalid)
  
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    let backgroundFetcher = BackgroundFetchAssist.instance
    print ("Вызов обновления данных в фоне \(Date())")
    if let lastUpdate = backgroundFetcher.lastUpdate, abs(lastUpdate.timeIntervalSinceNow) < 30 {
      print ("Фоновое обновление не требуется, т.к. последний раз данные обновлялись \(abs(lastUpdate.timeIntervalSinceNow)) секунд назад (меньше 30)")
      completionHandler(.noData)
      return
    }
    backgroundFetcher.timer = DispatchSource.makeTimerSource(queue: DispatchQueue.main)
    backgroundFetcher.timer?.schedule(deadline: .now(), repeating: .seconds(29), leeway: .seconds(1))
    backgroundFetcher.timer?.setEventHandler {
      print ("Говорим системе, что не смогли загрузить данные")
      completionHandler(.failed)
      return
    }
    backgroundFetcher.timer?.resume()
    print("asd")
    Swift.print("asd")
    let friendsRequest = FriendsRequest()
    friendsRequest.loadRequestsToFriends()
    let requestNotification = Notification.Name("requestNotification")
    NotificationCenter.default.addObserver(self, selector: #selector(addBadge(notification:)), name: requestNotification, object: nil)
    
    backgroundFetcher.timer = nil
    backgroundFetcher.lastUpdate = Date()
    completionHandler(.newData)
    print("Данные загружены")

  }
  
  @objc func addBadge(notification: Notification) {
    let application = UIApplication.shared
    DispatchQueue.main.async {
      application.registerForRemoteNotifications()
      application.applicationIconBadgeNumber = userDefaults.integer(forKey: "RequestsCount")
    }
  }
  
  
}

