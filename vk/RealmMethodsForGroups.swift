//
//  RealmMethodsForGroups.swift
//  vk
//
//  Created by Александр on 23.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import RealmSwift

class RealmMethodsForGroups {
  
  func saveGroupData(_ group: Group) {
    do {
      let realm = try Realm()
      realm.beginWrite()
      if realm.object(ofType: Group.self, forPrimaryKey: group.groupID) == nil {
        realm.add(group)
      }
      try realm.commitWrite()
    } catch {
      print(error)
    }
  }
  
  func tableUpdate<T: Group>(_ items: inout Results<T>?, _ token: inout NotificationToken?, _ tableView: UITableView) {
    do {
      let realm = try Realm()
      items = realm.objects(T.self)
      token = items?.observe { [weak tableView] (changes: RealmCollectionChange) in
        switch changes {
        case .initial:
          tableView?.reloadData()
        case .update(_, let deletions, let insertions, let modifications):
          tableView?.beginUpdates()
          tableView?.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                with: .none)
          tableView?.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                with: .none)
          tableView?.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                with: .none)
          tableView?.endUpdates()
          
        case .error(let error):
          fatalError("\(error)")
          break
        }
      }
    } catch {
      print(error)
    }
  }
  
  func deleteGroupData(_ groupID: String) {
    do {
      let realm = try Realm()
      guard let groupDeleted = realm.object(ofType: Group.self, forPrimaryKey: groupID) else { return }
      try realm.write {
      realm.delete(groupDeleted)
      }
    } catch {
      print(error)
    }
  }
  
}








