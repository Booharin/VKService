//
//  Chat.swift
//  vk
//
//  Created by Александр on 12.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Dialog: Object {
    @objc dynamic var id = ""
    @objc dynamic var photoID = ""
    @objc dynamic var nameID = ""
    @objc dynamic var title = ""
    @objc dynamic var photoIDLastMessage = ""
    @objc dynamic var textLastMessage = ""
    @objc dynamic var date = 0
    @objc dynamic var readState = 1
    @objc dynamic var out = 1
    let messages = List<Message>()
    
    var isGroup: Bool {
        return id.first == "-"
    }
    
    convenience init(id: String, photoID: String, nameID: String, title: String, photoIDLastMessage: String, textLastMessage: String, date: Int, readState: Int, out: Int) {
        self.init()
        self.id = id
        self.photoID = photoID
        self.nameID = nameID
        self.title = title
        self.photoIDLastMessage = photoIDLastMessage
        self.textLastMessage = textLastMessage
        self.date = date
        self.readState = readState
        self.out = out
    }
    
    convenience init(withJson json: [String: Any], andImgPlaceholderUrl placeholder: String) {
        self.init()
        
        let json = JSON(json)
        
        id = json["uid"].stringValue
        photoID = json["photo_100"].stringValue
        nameID = json["title"].stringValue
        
        if nameID != "" && photoID == "" {
            photoID = placeholder
        }
        
        textLastMessage = json["body"].stringValue
        
        let attachment = json["attachment"]
        if attachment["type"].stringValue == "sticker" {
            textLastMessage = "Стикер"
        }
        
        date = json["date"].intValue
        readState = json["read_state"].intValue
        out = json["out"].intValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

class Message: Object {
    @objc dynamic var text = ""
    @objc dynamic var messageID = 0
    @objc dynamic var fromID = ""
    @objc dynamic var date = 0
    @objc dynamic var readState = 1
    @objc dynamic var out = 1

    convenience init(text: String, messageID: Int, fromID: String, date: Int, readState: Int, out: Int) {
        self.init()
        self.text = text
        self.messageID = messageID
        self.fromID = fromID
        self.date = date
        self.readState = readState
        self.out = out
    }
    
    convenience init(withJson json: [String: Any]) {
        self.init()
        let json = JSON(json)
        
        text = json["body"].stringValue
        messageID = json["mid"].intValue
        fromID = String(json["from_id"].intValue)
        date = json["date"].intValue
        readState = json["read_state"].intValue
        out = json["out"].intValue
    }
    
    override static func primaryKey() -> String? {
        return "messageID"
    }
}







