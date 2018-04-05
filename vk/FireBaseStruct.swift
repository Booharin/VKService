
//  FireBaseStruct.swift
//  vk
//
//  Created by Александр on 06.11.17.
//  Copyright © 2017 Александр. All rights reserved.

import Foundation
import FirebaseDatabase

struct User {
  let id: String
  let groups: [GroupVK]

  var toAnyObject: Any {
    return [
      "id": id,
      "groups": groups.reduce([String: Any](), { (prevResult, group) in
        var prevResult = prevResult
        prevResult[String(group.id)] = group
        return prevResult
      })
    ]
  }
}

class FireBaseMethods {
  let dbLink = Database.database().reference()
  var requestHandle: DatabaseHandle?

  func saveData(group: GroupVK) {
    guard let id = userDefaults.string(forKey: "userID") else { return }
    let puth = "Users/" + id + "/groups"
    dbLink.child(puth).updateChildValues([group.name : group.toAnyObject])
  }

  func deleteData(group: GroupVK) {
    //guard let id = userDefaults.string(forKey: "userID") else { return }
    let puth = "Users/" + String(group.id) + "/groups/" + group.name
    dbLink.child(puth).removeValue()
  }

  func loadData(completion: @escaping ([GroupVK]) -> ()) {
    guard let id = userDefaults.string(forKey: "userID") else { return }
    requestHandle = dbLink
      .child("Users")
      .child(id)
      .observe(DataEventType.value, with: { snapshot in
        guard let value = snapshot.value as? [String: Any] else {
          let user = User(id: id, groups: [GroupVK]())
          let data = [user].reduce([String: Any](), {( prevResult, user) in
                  var prevResult = prevResult
                  prevResult[user.id] = user.toAnyObject
                  return prevResult
                })
          self.dbLink.child("Users").setValue(data)
          return
        }
        let groups: [GroupVK] = (value["groups"] as? [String: Any])?.compactMap { groupJSON in
              guard let groupJSON = groupJSON.value as? [String: Any],
              let groupID = groupJSON["id"] as? Int,
              let membersCount = groupJSON["members_count"] as? Int,
              let name = groupJSON["name"] as? String,
                let photo = groupJSON["photo_100"] as? String else { return nil }
            let group = GroupVK(id: groupID, name: name, photo_100: photo, members_count: membersCount)
              return group
        } ?? []
        completion(groups)
    })
  }
}
