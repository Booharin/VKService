//
//  RealmMethodsForDialogs.swift
//  vk
//
//  Created by Александр on 13.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import RealmSwift

class RealmMethodsForDialogs {
  
  func saveDialogData(_ dialogs: [Dialog]) {
    do {
      let realm = try Realm()
      let oldDialogs = realm.objects(Dialog.self)
      realm.beginWrite()
      for value in dialogs {
        guard realm.object(ofType: Dialog.self, forPrimaryKey: value.date) != nil else {
          if !oldDialogs.isEmpty {
          realm.delete(oldDialogs)
          }
          realm.add(dialogs)
          try realm.commitWrite()
          return
        }
      }
    } catch {
      print(error)
    }
  }
  
  func tableUpdate<T: Dialog>(_ items: inout Results<T>?, _ token: inout NotificationToken?, _ tableView: UITableView) {
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
}
