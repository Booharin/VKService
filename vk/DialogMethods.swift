//
//  DialogMethods.swift
//  vk
//
//  Created by Александр on 14.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit

class DialogMethods {
    let handleSizingUI = HandleSizingUI()
    var dateTextCache = [IndexPath: String]()
    
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale(identifier: "ru")
        df.dateFormat = "HH:mm"
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
    
    func getCellHeight(text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 15.0)
        let size = handleSizingUI.getLabelSize(bounds: UIScreen.main.bounds, text: text, font: font)
        
        return CGFloat(size.height)
    }
    
}
