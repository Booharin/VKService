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
    var parser: GroupsParserVK?
    
    func loadGroupsDataCount(completion: @escaping ([Group]) -> ()) {
        
        if userDefaults.string(forKey: "whatYouSearch") == "" { return }
        
        let parameters: Parameters = [
            "q": userDefaults.string(forKey: "whatYouSearch") ?? print("no search"),
            "type": "group",
            "access_token": userDefaults.string(forKey: "token") ?? print("no Token"),
            "v": requestMethods.apiVersion
        ]
//        print(Alamofire.request(requestMethods.baseURL + requestMethods.groupSearch, parameters: parameters))
        Alamofire.request(requestMethods.baseURL + requestMethods.groupSearch, parameters: parameters).responseJSON(queue: .global()) { response in
            guard let data = response.data else {
                print("Error: Invalid Response from Request")
                return
            }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(GroupsParserVK.self, from: data)
                self.parser = result
            } catch {
                print(error)
            }
            
            let groupsIDs: String = (self.parser?.response
                .compactMap({ String($0.id) })
                .joined(separator: ","))!
            
//            let responseGroupGet = response.value as! [String: Any]
//
//            guard let allData = responseGroupGet["response"] as! [String: Any]? else { return }
//            var groupIDs = [Int]()
//            var groupIDsString = ""
//            for (_, value) in allData {
//                let group = value as! [String: Any]
//                groupIDs.append(group["gid"] as! Int)
//            }
//            for i in groupIDs {
//                groupIDsString = groupIDsString + "," + String(i)
//            }
            
            let newParameters: Parameters = [
                "group_ids": groupsIDs,
                "fields": "members_count",
                "access_token": userDefaults.string(forKey: "token") ?? print("no Token")
            ]
            
            Alamofire.request(self.requestMethods.baseURL + self.requestMethods.groupsInfo,
                              parameters: newParameters)
                .responseJSON(queue: .global()) { response in
                let responseGroupsMembersCount = response.value as! [String: Any]
                    guard let array = responseGroupsMembersCount["response"] as! [Any]? else {
                        return
                    }
                var groups = [Group]()
                for value in array {
                    let userJSON = value as! [String:Any]
                    let name = userJSON["name"] as! String
                    let photo = userJSON["photo_medium"] as! String
                    let groupID = userJSON["gid"] as! Int
                    let membersCount = userJSON["members_count"] as! Int
                    groups.append(Group(name: name,
                                        photo_100: photo,
                                        id: groupID,
                                        membersCount: membersCount))
                }
                completion(groups)
            }
        }
    }
}


