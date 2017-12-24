//
//  ChatMethods.swift
//  vk
//
//  Created by Александр on 13.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation

class ChatMethods {
    
    var dateTextCache = [IndexPath: String]()
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru")
        df.dateFormat = "d MMM"//"dd.MM.yyyy HH.mm"
        return df
    }()
    
    func getCellDateText(_ indexPath: IndexPath,_ timeStamp: Double) -> String {
        
        if let stringDate = dateTextCache[indexPath] {
            return stringDate
        } else {
            let date = Date(timeIntervalSince1970: timeStamp)
            let stringDate = dateFormatter.string(from: date)
            dateTextCache[indexPath] = stringDate
            return stringDate
        }
    }
}
