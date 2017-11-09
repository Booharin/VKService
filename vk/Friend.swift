//
//  User.swift
//  vk
//
//  Created by Александр on 28.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import RealmSwift

class Friend: Object {
  @objc dynamic var firstName = ""
  @objc dynamic var lastName = ""
  @objc dynamic var photoAvatar = ""
  @objc dynamic var userID = ""
  let photos = List<Photo>()
  convenience init(firstName: String, lastName: String, photoAvatar: String, userID: String) {
    self.init()
    self.firstName = firstName
    self.lastName = lastName
    self.photoAvatar = photoAvatar
    self.userID = userID
  }
  
  override static func primaryKey() -> String? {
    return "userID"
  }
}

