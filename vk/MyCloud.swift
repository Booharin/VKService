//
//  MyCloud.swift
//  vk
//
//  Created by Александр on 22.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import CloudKit

class MyCloud {
    let myContainer = CKContainer(identifier: "iCloud.Umbrella.vk")
    let zoneID = CKRecordZoneID(zoneName: "groupsZone", ownerName: "_6081f44a56d1a17b8e7eceb33899677f")
    var dataBase: CKDatabase {
        return myContainer.database(with: .private)
    }
    
    func saveToiCloud(_ groupIncoming: Group) {
        let groupID = CKRecordID(recordName: groupIncoming.groupID, zoneID: zoneID)
        let groupGoingToTheCloud = CKRecord(recordType: "Group", recordID: groupID)
        
        groupGoingToTheCloud["name"] = groupIncoming.name as NSString
        groupGoingToTheCloud["groupID"] = groupIncoming.groupID as NSString
        groupGoingToTheCloud["image"] = groupIncoming.photo as NSString
        groupGoingToTheCloud["membersCount"] = groupIncoming.membersCount as NSNumber
        
        dataBase.save(groupGoingToTheCloud) {
            (record, error) in
            if let error = error {
                print(error)
                return
            }
        }
    }
    
    func loadFromiCloud(completion: @escaping ([Group]) -> ()) {
        let query = CKQuery(recordType: "Group", predicate: NSPredicate(value: true))
        dataBase.perform(query, inZoneWith: zoneID) { results, error in
            var groups = [Group]()
            if results != nil {
                for group in results! {
                    let name = group["name"] as! String
                    let groupID = group["groupID"] as! String
                    let photo = group["image"] as! String
                    let membersCount = group["membersCount"] as! Int
                    groups.append(Group(name: name, photo: photo, groupID: groupID, membersCount: membersCount))
                }
                completion(groups)
            }
        }
    }
    
    func deleteFromiCloud(_ groupID: String) {
        let groupID = CKRecordID(recordName: groupID, zoneID: zoneID)
        dataBase.delete(withRecordID: groupID) { _, _ in }
    }
    
}








