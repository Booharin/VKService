//
//  RealmMethodsForFriends.swift
//  vk
//
//  Created by Александр on 10.10.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import RealmSwift

class RealmMethodsForFriends {
    
    func saveFriendsData(_ friends: [Friend]) {
        do {
            let realm = try Realm()
            let oldFriends = realm.objects(Friend.self)
            realm.beginWrite()
            if oldFriends.count != friends.count {
                realm.delete(oldFriends)
                realm.add(friends)
            }
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func tableUpdate<T: Friend>(_ items: inout Results<T>?, _ token: inout NotificationToken?, _ tableView: UITableView) {
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
