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
    
    @discardableResult
    static func saveDialogData(_ dialogs: [Dialog]) -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(dialogs, update: true)
            }
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        return true
    }
    
    @discardableResult
    static func modifyDialog(forPrimaryKey key: String, work: (Dialog?)->Void) -> Bool {
        do {
            let realm = try Realm()
            let dialog = realm.object(ofType: Dialog.self, forPrimaryKey: key)
            try realm.write {
                work(dialog)
            }
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        return true
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
