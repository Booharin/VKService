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
    
    @discardableResult
    func saveMessages(_ messages: [Message], fromDialogWithId id: String) -> Bool {       
        do {
            let realm = try Realm()
            guard let dialog = realm.object(ofType: Dialog.self, forPrimaryKey: id) else { return false }
            try realm.write {
                realm.add(messages, update: true)
                dialog.messages.removeAll()
                dialog.messages.append(objectsIn: messages)
            }
        } catch {
            print(error.localizedDescription)
            return false
        }
        return true
    }
    
    func collectionUpdate(_ items: inout List<Message>?, _ token: inout NotificationToken?, _ collectionView: UICollectionView) {
        do {
            let realm = try Realm()
            guard let dialog = realm.object(ofType: Dialog.self, forPrimaryKey: userDefaults.value(forKey: "whatDialogID")) else { return }
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
