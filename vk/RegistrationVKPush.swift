//
//  File.swift
//  vk
//
//  Created by Александр on 10.12.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import Alamofire

class RegistrationVKPush {
  let requestMethods = RequestMethods()
  func registrationForPushes() {
  var deviceIDEasy = "12345"
    if let deviceID = userDefaults.string(forKey: "RegistrationToken") {
      deviceIDEasy = deviceID + "id"
    }
    
    let parameters: Parameters = [
      "token": userDefaults.string(forKey: "RegistrationToken") ?? print("no token"),
      "device_id": deviceIDEasy,
      "access_token": userDefaults.string(forKey: "token") ?? print("no access token"),
      "sandbox": "1",
      "settings": "{\"msg\":\"on\", \"chat\": \"on\", \"friend\":\"on\", \"reply\":\"on\", \"mention\":\"fr_of_fr\", \"wall_post\":\"on\"}",
      "v": requestMethods.apiVersion,
    ]
  
    Alamofire.request(requestMethods.baseURL + requestMethods.registrationForPushes, parameters: parameters)
  }
  
}
