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
  
  func loadFriendsData() {
    
    let parameters: Parameters = [
      "access_token": userDefaults.string(forKey: "token") ?? print("no Token"),
      "order": "name",
      "fields": "nickname,photo_100",
      "name_case": "nom",
      "version": requestMethods.apiVersion,
      ]
    
    Alamofire.request(requestMethods.baseURL + requestMethods.getFriends, parameters: parameters).responseData(queue: .global()) { [weak self] response in // без SwiftyJSON
      let json = try! JSONSerialization.jsonObject(with: response.value!, options: JSONSerialization.ReadingOptions.mutableContainers)
      
      var friends = [Friend]()
      
      let dict = json as! [String: Any]
      for (_, array) in dict {
        for value in array as! [Any] {
            let userJSON = value as! [String:Any]
            let firstName = userJSON["first_name"] as! String
            let lastName = userJSON["last_name"] as! String
            let photoAvatar = userJSON["photo_100"] as! String
            let userID = userJSON["user_id"] as! Int
            friends.append(Friend(firstName: firstName, lastName: lastName, photoAvatar: photoAvatar, userID: String(userID)))
          }
        }
      self?.realm.saveFriendsData(friends)
    }
  }
  
  func loadRequestsToFriends() {
    let parameters: Parameters = [
      "count": "100",
      "extended": "1",
      "sort": "0",
      "need_viewed": "1",
      "access_token": userDefaults.string(forKey: "token") ?? print("no Token")
    ]
    
    Alamofire.request(requestMethods.baseURL + requestMethods.getRequests, parameters: parameters).responseJSON(queue: .global()) { response in
      guard let responseRequestsGet = response.value as! [String: Any]? else { return }
      let array = responseRequestsGet["response"] as! [Any]
      userDefaults.set(array.count, forKey: "RequestsCount")
      let requestNotification = Notification.Name("requestNotification")
      NotificationCenter.default.post(name: requestNotification, object: nil)
    }
  }
}
