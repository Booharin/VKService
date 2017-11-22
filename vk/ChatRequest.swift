//
//  ChatRequest.swift
//  vk
//
//  Created by Александр on 12.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class ChatRequest {
  let requestMethods = RequestMethods()
  let realm = RealmMethodsForDialogs()
  let realmMSG = RealmMethodsForMessages()
  
  func loadDialogsData() {
    userDefaults.set(0, forKey: "UnreadMessage")
    let parameters: Parameters = [
      "count": "200",
      "version": requestMethods.apiVersion,
      "access_token": userDefaults.string(forKey: "token") ?? print("no Token")
    ]
    print(Alamofire.request(requestMethods.baseURL + requestMethods.dialogsGet, parameters: parameters))
    Alamofire.request(requestMethods.baseURL + requestMethods.dialogsGet, parameters: parameters).responseJSON(queue: .global()) { response in
      let responseDialogsGet = response.value as! [String: Any]
      guard var array = responseDialogsGet["response"] as! [Any]? else { return }
      array.remove(at: 0)
      var dialogs = [Dialog]()
      var dialogItem = Dialog()
      var usersIDString = ""
      for value in array {
        let dialog = value as! [String: Any]
        dialogItem.id = String(dialog["uid"] as! Int)
        if dialog["photo_100"] != nil { dialogItem.photoID = dialog["photo_100"] as! String }
        if dialog["title"] as! String != "" { dialogItem.nameID = dialog["title"] as! String }
        if dialogItem.nameID != "" && dialogItem.photoID == "" { dialogItem.photoID = self.requestMethods.photoPlaceHolder }
        dialogItem.textLastMessage = dialog["body"] as! String
        if dialog["attachment"] != nil {
        let attachment = dialog["attachment"] as! [String: Any]
          if attachment["type"] as! String == "sticker" { dialogItem.textLastMessage = "Стикер" }
        }
        dialogItem.date = dialog["date"] as! Int
        dialogItem.readState = dialog["read_state"] as! Int
        
        if dialogItem.readState == 0 { userDefaults.set(1, forKey: "UnreadMessage") }
        
        dialogItem.out = dialog["out"] as! Int
        dialogs.append(dialogItem)
        dialogItem = Dialog(id: "", photoID: "", nameID: "", title: "", photoIDLastMessage: "", textLastMessage: "", date: 0, readState: 1, out: 1)
      }
      for i in dialogs {
        usersIDString = usersIDString + "," + i.id
      }
      // обновление числа на бэдже
      let application = UIApplication.shared
      DispatchQueue.main.async {
        application.applicationIconBadgeNumber = userDefaults.integer(forKey: "RequestsCount") + userDefaults.integer(forKey: "UnreadMessage")
      }
      
      let newParameters: Parameters = [
        "user_ids": usersIDString,
        "fields": "nickname,photo_100",
        "name_case": "nom",
        "version": self.requestMethods.apiVersion,
        "access_token": userDefaults.string(forKey: "token") ?? print("no Token")
      ]
      
      Alamofire.request(self.requestMethods.baseURL + self.requestMethods.getUsers, parameters: newParameters).responseJSON(queue: .global()) { response in
        let responseUsersGet = response.value as! [String: Any]
        let array = responseUsersGet["response"] as! [Any]
        
        for dialog in dialogs {
          for value in array {
            let user = value as! [String: Any]
            if String(user["uid"] as! Int) == dialog.id {
              if dialog.nameID == "" {
                dialog.photoID = user["photo_100"] as! String
                dialog.nameID = user["first_name"] as! String + " " + (user["last_name"] as! String)
              }
            }
          }
          if Int(dialog.id)! < 0 {
            
            let groupParameters: Parameters = [
              "group_id": dialog.id.dropFirst(),
              "fields": "members_count",
              "access_token": userDefaults.string(forKey: "token") ?? print("no Token")
            ]

            Alamofire.request(self.requestMethods.baseURL + self.requestMethods.groupsInfo, parameters: groupParameters).responseJSON(queue: .global()) { response in
              let responseGroups = response.value as! [String: Any]
              guard let array = responseGroups["response"] as! [Any]? else { return }
              for value in array {
                let groupJSON = value as! [String:Any]
                dialog.nameID = groupJSON["name"] as! String
                dialog.photoID = groupJSON["photo_medium"] as! String
              }
            }
          }
        }
        self.realm.saveDialogData(dialogs)
      }
    }
  }
  
  func loadHistoryOfMessages() {
    let parameters: Parameters = [
      "count": "200",
      "user_id": userDefaults.string(forKey: "whatDialogID") ?? print("no DialogID"),
      //"peer_id": "153984390",
      "version": self.requestMethods.apiVersion,
      "access_token": userDefaults.string(forKey: "token") ?? print("no Token")
    ]

    Alamofire.request(self.requestMethods.baseURL + requestMethods.historyOfMessagesGet, parameters: parameters).responseJSON(queue: .global()) { response in
      let responseMessagesGet = response.value as! [String: Any]
      guard var array = responseMessagesGet["response"] as! [Any]? else { return }
      array.remove(at: 0)
      var messages = [Message]()
      var messageItem = Message()
      for value in array {
        let message = value as! [String: Any]
        messageItem.text = message["body"] as! String
        messageItem.messageID = message["mid"] as! Int
        messageItem.fromID = String(message["from_id"] as! Int)
        messageItem.date = message["date"] as! Int
        messageItem.readState = message["read_state"] as! Int
        messageItem.out = message["out"] as! Int
        messages.append(messageItem)
        messageItem = Message(text: "", messageID: 1, fromID: "", date: 0, readState: 1, out: 1)
      }
      self.realmMSG.saveMessagesData(messages, date: messages[0].date)
      userDefaults.set(messages[0].date, forKey: "DateID")
    }
  }
}











