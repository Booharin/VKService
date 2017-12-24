//
//  RealmMethodsForPhoto.swift
//  vk
//
//  Created by Александр on 10.10.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import RealmSwift

class RealmMethodsForPhoto {
    
    func savePhotoData(_ photos: [Photo], userID: String) {
        do {
            let realm = try Realm()
            guard let friend = realm.object(ofType: Friend.self, forPrimaryKey: userID) else { return }
            let oldPhotos = friend.photos
            realm.beginWrite()
            if photos.count != oldPhotos.count {
                realm.delete(oldPhotos)
                friend.photos.append(objectsIn: photos)
            }
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func collectionUpdate(_ items: inout List<Photo>?, _ token: inout NotificationToken?, _ collectionView: UICollectionView) {
        do {
            let realm = try Realm()
            guard let friend = realm.object(ofType: Friend.self, forPrimaryKey: userDefaults.string(forKey: "whoIsYourFriend")) else { return }
            items = friend.photos
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

