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
   
    func loadDialogsData(completion: @escaping ()->Void) {
        let requestMethods = RequestMethods()
        let parameters: Parameters = [
            "count": "200",
            "version": requestMethods.apiVersion,
            "access_token": userDefaults.string(forKey: "token") ?? print("no Token")
        ]
        
        Alamofire.request(requestMethods.baseURL + requestMethods.dialogsGet,
                          parameters: parameters).responseJSON(queue: .global()) { response in
            
            guard let responseDialogsGet = response.value as? [String: Any],
                let dialogJsons =
                (responseDialogsGet["response"] as? [Any])?
                    .compactMap({ $0 as? [String: Any] }) else {
                return
            }
            
            userDefaults.set(0, forKey: "UnreadMessage")
            userDefaults.set("", forKey: "NameOfLastMessage")
            userDefaults.set("", forKey: "TextOfLastMessage")
           
            var dialogs = [Dialog]()
            dialogJsons.forEach { json in
                let dialogItem = Dialog(withJson: json,
                                        andImgPlaceholderUrl: requestMethods.photoPlaceHolder)
                
                if dialogItem.readState == 0 && dialogItem.out == 0 {
                    userDefaults.set(1, forKey: "UnreadMessage")
                    userDefaults.set(dialogItem.textLastMessage, forKey: "TextOfLastMessage")
                }
                
                dialogs.append(dialogItem)
            }
            
            guard RealmMethodsForDialogs.saveDialogData(dialogs) else {
                print("Error! Data couldn't be save!")
                return
            }
            
            let usersIDs: String = dialogs
                .filter({ !$0.isGroup })
                .compactMap({ String($0.id) })
                .joined(separator: ",")
            
            let groupIDs: [String] = dialogs
                .filter({ $0.isGroup })
                .compactMap({ $0.id })
            
            // MARK: - Обновление числа на бэдже
            let application = UIApplication.shared
            DispatchQueue.main.async {
                application.applicationIconBadgeNumber = userDefaults
                    .integer(forKey: "RequestsCount") + userDefaults
                        .integer(forKey: "UnreadMessage")
            }
            
            let dispGroup = DispatchGroup()

            // MARK: - Запрос по пользователям
            dispGroup.enter()
            
            let usersParameters: Parameters = [
                "user_ids": usersIDs,
                "fields": "nickname,photo_100",
                "name_case": "nom",
                "version": requestMethods.apiVersion,
                "access_token": userDefaults.string(forKey: "token") ?? print("no Token")
            ]
            
            Alamofire.request(requestMethods.baseURL + requestMethods.getUsers,
                              parameters: usersParameters)
                .responseJSON(queue: .global()) { response in
                
                guard let responseUsersGet = response.value as? [String: Any],
                    let array = (responseUsersGet["response"] as? [Any])?
                        .compactMap({ $0 as? [String: Any] }) else {
                        return
                }
                        
                for (index, user) in array.enumerated() {
                    if let key = user["uid"] as? Int {
                        RealmMethodsForDialogs.modifyDialog(forPrimaryKey: String(key),
                                                            work: { (dialog) in
                            guard let dialog = dialog else { return }
                            
                            if dialog.nameID == "" {
                                dialog.photoID = user["photo_100"] as! String
                                dialog.nameID = user["first_name"] as! String +
                                    " " + (user["last_name"] as! String)
                            }
                        })
                    }
                    //установка имени в заголовок уведомления
                    if index == 0 { userDefaults.set(user["first_name"] as! String,
                                                     forKey: "NameOfLastMessage") }
                }
                                
                dispGroup.leave()
            }
            
            // MARK: Запросы по группам
            groupIDs.forEach({ (groupId) in
                dispGroup.enter()
                
                let groupParameters: Parameters = [
                    "group_id": groupId.dropFirst(),
                    "fields": "members_count",
                    "version": requestMethods.apiVersion,
                    "access_token": userDefaults.string(forKey: "token") ?? print("no Token")
                ]
                
                Alamofire.request(requestMethods.baseURL + requestMethods.groupsInfo,
                                  parameters: groupParameters)
                    .responseJSON(queue: .global()) { response in
                    
                    guard let responseGroups = response.value as? [String: Any],
                        let array = (responseGroups["response"] as? [Any])?
                            .compactMap({ $0 as? [String: Any] }),
                        let groupJson = array.first else {
                            return
                    }
                    
                    RealmMethodsForDialogs.modifyDialog(forPrimaryKey: groupId, work: { (dialog) in
                        guard let dialog = dialog else { return }
                        
                        dialog.nameID = groupJson["name"] as! String
                        dialog.photoID = groupJson["photo_medium"] as! String
                    })
                    
                    dispGroup.leave()
                }
            })
            
            // MARK: Оповещение об окончании загрузки -
            dispGroup.notify(queue: DispatchQueue.global(), execute: {
                // RealmMethodsForDialogs.saveDialogData(dialogs)
                if userDefaults.string(forKey: "NameOfLastMessage") == "" {
                    // установка названия группы в заголовок уведомления
                    userDefaults.set(dialogs[0].nameID, forKey: "NameOfLastMessage")
                }
                
                DispatchQueue.main.async {
                    completion()
                }
            })
        }
    }
    
    func loadHistoryOfMessages(completion: (()->Void)? = nil) {
        guard let dialogId = userDefaults.string(forKey: "whatDialogID") else {
            print("no DialogID")
            return
        }
        
        let requestMethods = RequestMethods()
        let parameters: Parameters = [
            "count": "200",
            "user_id": dialogId,
            "version": requestMethods.apiVersion,
            "access_token": userDefaults.string(forKey: "token") ?? print("no Token")
        ]
        
        Alamofire.request(requestMethods.baseURL + requestMethods.historyOfMessagesGet,
                          parameters: parameters).responseJSON(queue: .global()) { response in
            guard let responseMessagesGet = response.value as? [String: Any],
            let array = (responseMessagesGet["response"] as? [Any])?
                .compactMap({ $0 as? [String: Any] }) else {
                return
            }

            var messages = [Message]()
            for message in array {
                let messageItem = Message(withJson: message)
                messages.append(messageItem)
            }
            
            if RealmMethodsForMessages().saveMessages(messages, fromDialogWithId: dialogId) {
                DispatchQueue.main.async {
                    completion?()
                }
                
                //userDefaults.set(messages[0].date, forKey: "DateID")
            }
        }
    }
    
    func sendMessage() {
        let requestMethods = RequestMethods()
        let parameters: Parameters = [
            "user_id": userDefaults.string(forKey: "whatDialogID") ?? print("no DialogID"),
            "random_id": Int(Date().timeIntervalSince1970),
            "message": userDefaults.string(forKey: "TextOfSendMessage") ?? "Прувет",
            "access_token": userDefaults.string(forKey: "token") ?? print("no Token"),
            "v": requestMethods.apiVersion
        ]
        
        Alamofire.request(requestMethods.baseURL + requestMethods.sendMessage,
                          parameters: parameters)
    }
    
}











