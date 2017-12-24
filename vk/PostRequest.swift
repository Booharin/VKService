//
//  PostRequest.swift
//  vk
//
//  Created by Александр on 15.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation

class PostRequest {
    let requestMethods = RequestMethods()
    
    func goPost(text: String) {
        var lat = ""
        var long = ""
        if userDefaults.bool(forKey: "pressedMyLocation") {
            lat = String(userDefaults.double(forKey: "lat"))
            long = String(userDefaults.double(forKey: "long"))
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = requestMethods.goPost
        urlComponents.queryItems = [
            URLQueryItem(name: "owner_id", value: userDefaults.string(forKey: "userID")),
            URLQueryItem(name: "message", value: text),
            //URLQueryItem(name: "attachments", value: ""),
            URLQueryItem(name: "lat", value: lat),
            URLQueryItem(name: "long", value: long),
            URLQueryItem(name: "access_token", value: userDefaults.string(forKey: "token")),
            URLQueryItem(name: "v", value: requestMethods.apiVersion)
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        print(request)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: request)
        //    {
        //      (data, response, error) in
        //      guard error == nil else {
        //        print(error!)
        //        return
        //      }
        //      guard let responseData = data else {
        //        print("Error: did not receive data")
        //        return
        //      }
        //      do {
        //        guard let todo = try JSONSerialization.jsonObject(with: responseData, options: [])
        //          as? [String: Any] else {
        //            print("error trying to convert data to JSON")
        //            return
        //        }
        //
        //        
        //
        //      } catch {
        //        print(error)
        //        return
        //      }
        //    }
        task.resume()
    }
}
  

