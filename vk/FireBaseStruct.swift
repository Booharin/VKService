//
//  FireBaseStruct.swift
//  vk
//
//  Created by Александр on 06.11.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct User {
  let id: String
  let groups: [Group]
  
  var toAnyObject: Any {
    return [
      "id": id,
      "groups": groups.reduce([Int: Any](), { (prevResult, group) in
        var prevResult = prevResult
        prevResult[group.groupID] = group.toAnyObject
        return prevResult
      })
    ]
  }
}

class FireBaseMethods {
  let dbLink = Database.database().reference()
  var requestHandle: DatabaseHandle?
  
  func saveData(group: Group) {
    guard let id = userDefaults.string(forKey: "userID") else { return }
    let puth = "Users/" + id + "/groups"
    dbLink.child(puth).updateChildValues([group.name : group.toAnyObject])
  }
  
  func deleteData(group: Group) {
    guard let id = userDefaults.string(forKey: "userID") else { return }
    let puth = "Users/" + id + "/groups/" + group.name
    dbLink.child(puth).removeValue()
  }
  
  func loadData(completion: @escaping ([Group]) -> ()) {
    guard let id = userDefaults.string(forKey: "userID") else { return }
    requestHandle = dbLink
      .child("Users")
      .child(id)
      .observe(DataEventType.value, with: { snapshot in

        guard let value = snapshot.value as? [String: Any] else {
          let user = User(id: id, groups: [Group]())
          let data = [user].reduce([String: Any](), {( prevResult, user) in
                  var prevResult = prevResult
                  prevResult[user.id] = user.toAnyObject
                  return prevResult
                })
          self.dbLink.child("Users").setValue(data)
          return
        }
        let groups: [Group] = (value["groups"] as? [String: Any])?.flatMap { groupJSON in
              guard let groupJSON = groupJSON.value as? [String: Any],
              let groupID = groupJSON["groupID"] as? Int,
              let membersCount = groupJSON["membersCount"] as? Int,
              let name = groupJSON["name"] as? String,
                let photo = groupJSON["photo"] as? String else { return nil }
              let group = Group(name: name, photo: photo, groupID: groupID, membersCount: membersCount)
              return group
        } ?? []
        completion(groups)
    })
  }
}











