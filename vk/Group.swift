//
//  Group.swift
//  vk
//
//  Created by Александр on 29.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import RealmSwift

class Group: Object, Codable {
    @objc dynamic var name = ""
    @objc dynamic var photo_100 = ""
    @objc dynamic var id = 0
    @objc dynamic var membersCount = 0
    
    @objc dynamic var toAnyObject: Any {
        return [
            "name": name,
            "photo_100": photo_100,
            "id": id,
            "membersCount": membersCount
        ]
    }
    
    convenience init(name: String, photo_100: String, id: Int, membersCount: Int) {
        self.init()
        self.name = name
        self.photo_100 = photo_100
        self.id = id
        self.membersCount = membersCount
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
