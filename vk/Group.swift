//
//  Group.swift
//  vk
//
//  Created by Александр on 29.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation

struct Group: Codable {
  let name: String
  let photo: String
  let groupID: Int
  let membersCount: Int
  
  var toAnyObject: Any {
    return [
      "name": name,
      "photo": photo,
      "groupID": groupID,
      "membersCount": membersCount
    ]
  }
  init(name: String, photo: String, groupID: Int, membersCount: Int) {
    self.name = name
    self.photo = photo
    self.groupID = groupID
    self.membersCount = membersCount
  }
}
