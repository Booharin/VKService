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
  let reqestMethods = RequestMethods()
  
  func loadGroupsDataCount(completion: @escaping ([Group]) -> ()) {
    
    if userDefaults.string(forKey: "whatYouSearch") == "" { return }
    
    let parameters: Parameters = [
      "q": userDefaults.string(forKey: "whatYouSearch") ?? print("no search"),
      "type": "group",
      "access_token": userDefaults.string(forKey: "token") ?? print("no Token")
    ]
    
    Alamofire.request(reqestMethods.baseURL + reqestMethods.groupSearch, parameters: parameters).responseJSON(queue: .global()) { response in
      let responseGroupGet = response.value as! [String: Any]
      
      guard var allData = responseGroupGet["response"] as! [Any]? else { return }
      allData.remove(at: 0)
      var groupIDs = [Int]()
      var groupIDsString = ""
      for value in allData {
        let group = value as! [String: Any]
        groupIDs.append(group["gid"] as! Int)
      }
      for i in groupIDs {
        groupIDsString = groupIDsString + "," + String(i)
      }
      
      let newParameters: Parameters = [
        "group_ids": groupIDsString,
        "fields": "members_count",
        "access_token": userDefaults.string(forKey: "token") ?? print("no Token")
      ]
      
      Alamofire.request(self.reqestMethods.baseURL + self.reqestMethods.groupInfo, parameters: newParameters).responseJSON(queue: .global()) { response in
        let responseGroupsMembersCount = response.value as! [String: Any]
        guard let array = responseGroupsMembersCount["response"] as! [Any]? else { return }
        var groups = [Group]()
        for value in array {
          let userJSON = value as! [String:Any]
          let name = userJSON["name"] as! String
          let photo = userJSON["photo"] as! String
          let groupID = userJSON["gid"] as! Int
          let membersCount = userJSON["members_count"] as! Int
          groups.append(Group(name: name, photo: photo, groupID: groupID, membersCount: membersCount))
        }
        completion(groups)
      }
    }
  }
}


