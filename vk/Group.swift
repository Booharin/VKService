//
//  Group.swift
//  vk
//
//  Created by Александр on 29.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import RealmSwift

class Group: Object, Codable {
  @objc dynamic var name = ""
  @objc dynamic var photo = ""
  @objc dynamic var groupID = ""
  @objc dynamic var membersCount = 0
  
  @objc dynamic var toAnyObject: Any {
    return [
      "name": name,
      "photo": photo,
      "groupID": groupID,
      "membersCount": membersCount
    ]
  }
  
  convenience init(name: String, photo: String, groupID: String, membersCount: Int) {
    self.init()
    self.name = name
    self.photo = photo
    self.groupID = groupID
    self.membersCount = membersCount
  }
  
  override static func primaryKey() -> String? {
    return "groupID"
  }
}
