//
//  RemoteNotification.swift
//  vk
//
//  Created by Александр on 08.12.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation

class RemoteNotification {
    
    func goFetch(completion: @escaping (String?)->Void) {
        let friendsRequest = FriendsRequest()
        let chatRequest = ChatRequest()
        
        friendsRequest.loadRequestsToFriends()
        chatRequest.loadDialogsData(completion: {
            let vkLocalNotification = VKLocalNotification()
            var response : String? = nil
            if userDefaults.string(forKey: "TextOfLastMessage") != "" {
                vkLocalNotification.postLocalNotification()
                response = "You have new message"
            }
            if userDefaults.integer(forKey: "RequestsCount") > 0 {
                vkLocalNotification.postLocalNotification()
                response = "You have new request to Friend"
            }
            completion(response)
        })
    }
}
