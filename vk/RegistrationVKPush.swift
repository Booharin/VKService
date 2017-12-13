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
    
    let parameters: Parameters = [
      "token": userDefaults.string(forKey: "RegistrationToken") ?? print("no token"),
      "access_token": userDefaults.string(forKey: "token") ?? print("no access token"),
      "device_id": "123456",
      "settings": "{\"msg\":\"on\", \"chat\": \"on\", \"friend\":\"on\", \"reply\":\"on\", \"mention\":\"fr_of_fr\"} ",
      "version": requestMethods.apiVersion,
      "sandbox": "1"
    ]
   
    Alamofire.request(requestMethods.baseURL + requestMethods.registrationForPushes, parameters: parameters)
  }
  
  func getPushSettings() {
    
    let parameters: Parameters = [
      "token": userDefaults.string(forKey: "RegistrationToken") ?? print("no token"),
      "access_token": userDefaults.string(forKey: "token") ?? print("no access token"),
    ]
    
    Alamofire.request(requestMethods.baseURL + requestMethods.getPushSettings, parameters: parameters)
  }
  
}
