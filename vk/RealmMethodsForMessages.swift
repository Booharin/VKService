//
//  RealmMethodsForMessages.swift
//  vk
//
//  Created by Александр on 14.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import RealmSwift

class RealmMethodsForMessages {
  
  func saveMessagesData(_ messages: [Message], date: Int) {
    do {
      let realm = try Realm()
      guard let dialog = realm.object(ofType: Dialog.self, forPrimaryKey: date) else { return }
      let oldMessages = dialog.messages
      realm.beginWrite()
      if messages.count != oldMessages.count {
        realm.delete(oldMessages)
        dialog.messages.append(objectsIn: messages)
      }
      try realm.commitWrite()
    } catch {
      print(error)
    }
  }
  
  func collectionUpdate(_ items: inout List<Message>?, _ token: inout NotificationToken?, _ collectionView: UICollectionView) {
    do {
      let realm = try Realm()
      guard let dialog = realm.object(ofType: Dialog.self, forPrimaryKey: userDefaults.integer(forKey: "DateID")) else { return }
      items = dialog.messages
      token = items?.observe { [weak collectionView] (changes: RealmCollectionChange) in
        
        switch changes {
        case .initial:
          collectionView?.reloadData()
        case .update(_, let deletions, let insertions, let modifications):
          collectionView?.performBatchUpdates({
            collectionView?.insertItems(at: insertions.map({ IndexPath(row: $0, section: 0) }))
            collectionView?.deleteItems(at: deletions.map({ IndexPath(row: $0, section: 0)}))
            collectionView?.reloadItems(at: modifications.map({ IndexPath(row: $0, section: 0) }))
          }, completion: nil)
        case .error(let error):
          fatalError("\(error)")
        }
      }
    } catch {
      print(error)
    }
  }
}
