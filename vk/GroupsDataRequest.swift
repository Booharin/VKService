//
//  CountMembersRequest.swift
//  vk
//
//  Created by Александр on 05.10.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import Alamofire

class GroupsDataRequest {
    let requestMethods = RequestMethods()
    let decoder = JSONDecoder()
    var parser: GroupsParserVK?
    var parserFromID: GroupsParserFromIDVK?
    
    func loadGroupsDataCount(completion: @escaping ([GroupVK]) -> ()) {
        
        if userDefaults.string(forKey: "whatYouSearch") == "" { return }
        
        let parameters: Parameters = [
            "q": userDefaults.string(forKey: "whatYouSearch") ?? print("no search"),
            "type": "group",
            "access_token": userDefaults.string(forKey: "token") ?? print("no Token"),
            "v": requestMethods.apiVersion
        ]
        
        Alamofire.request(requestMethods.baseURL + requestMethods.groupSearch, parameters: parameters).responseJSON(queue: .global()) { response in
            guard let data = response.data else {
                print("Error: Invalid Response from Request")
                return
            }
            do {
                let result = try self.decoder.decode(GroupsParserVK.self, from: data)
                self.parser = result
            } catch {
                print(error)
            }
            
            let groupsIDs: String? = self.parser?.response.items.compactMap({ String($0.id) }).joined(separator: ",")
            
            let newParameters: Parameters = [
                "group_ids": groupsIDs ?? "",
                "fields": "members_count",
                "access_token": userDefaults.string(forKey: "token") ?? print("no Token"),
                "v": self.requestMethods.apiVersion
            ]

            Alamofire.request(self.requestMethods.baseURL + self.requestMethods.groupsInfo,
                              parameters: newParameters)
                .responseJSON(queue: .global()) { response in
                    guard let data = response.data else {
                        print("Error: Invalid Response from Request")
                        return
                    }
                    do {
                        let result = try self.decoder.decode(GroupsParserFromIDVK.self, from: data)
                        self.parserFromID = result
                    } catch {
                        print(error)
                    }
                    if let groups = self.parserFromID?.response {
                        completion(groups)
                    }
            }
        }
    }
}


