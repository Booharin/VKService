//
//  RemoteNotification.swift
//  vk
//
//  Created by Александр on 08.12.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation

class RemoteNotification {
  let vkLocalNotification = VKLocalNotification()
  let friendsRequest = FriendsRequest()
  let chatRequest = ChatRequest()
  //vkLocalNotification.postLocalNotification()
  func goFetch() -> String? {
    var response : String?
    friendsRequest.loadRequestsToFriends()
    chatRequest.loadDialogsData()
    sleep(5)
    if userDefaults.string(forKey: "TextOfLastMessage") != "" {
      vkLocalNotification.postLocalNotification()
      response = "You have new message"
    }
    if userDefaults.integer(forKey: "RequestsCount") > 0 {
      vkLocalNotification.postLocalNotification()
      response = "You have new request to Friend"
    }
    return response
  }
}
