//
//  FriendsRequest.swift
//  vk
//
//  Created by Александр on 30.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class FriendsRequest {
    let requestMethods = RequestMethods()
    let realm = RealmMethodsForFriends()
    var parser: FriendsParserVK?
    
    func loadFriendsData() {
        
        let parameters: Parameters = [
            "access_token": userDefaults.string(forKey: "token") ?? print("no Token"),
            "order": "name",
            "fields": "nickname,photo_100",
            "name_case": "nom",
            "version": requestMethods.apiVersion,
            ]
        
        Alamofire.request(requestMethods.baseURL + requestMethods.getFriends, parameters: parameters).responseJSON(queue: .global()) { [weak self] response in
            guard let data = response.data else {
                print("Error: Invalid Response from Request")
                return
            }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(FriendsParserVK.self, from: data)
                self?.parser = result
            } catch {
                print(error)
            }
            
            if let response = self?.parser?.response {
                var friends = [Friend]()
                response.forEach { friend in
                    if let id = friend.user_id {
                        friends.append(Friend(firstName: friend.first_name,
                                              lastName: friend.last_name,
                                              photoAvatar: friend.photo_100,
                                              userID: String(id)))
                    }
                }
                self?.realm.saveFriendsData(friends)
            }
        }
    }

    
    func loadRequestsToFriends() {
        let parameters: Parameters = [
            "count": "100",
            "extended": "1",
            "sort": "0",
            "need_viewed": "0",
            "access_token": userDefaults.string(forKey: "token") ?? print("no Token"),
            "v": requestMethods.apiVersion
        ]

        Alamofire.request(requestMethods.baseURL + requestMethods.getRequests,
                          parameters: parameters)
            .responseJSON(queue: .global()) { response in
                
            guard let responseRequestsGet = response.value as? [String: Any]? else { return }
                guard let dict = responseRequestsGet?["response"] as? [String: Any]? else { return }
            userDefaults.set(dict?["count"], forKey: "RequestsCount")
            
            let application = UIApplication.shared
            DispatchQueue.main.async {
                application.applicationIconBadgeNumber =
                    userDefaults.integer(forKey: "RequestsCount") +
                    userDefaults.integer(forKey: "UnreadMessage")
            }
        }
    }
}
