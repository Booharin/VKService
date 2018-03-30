//
//  NewsMethods.swift
//  vk
//
//  Created by Александр on 11.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import UIKit

class NewsMethods {
    let handleSizingUI = HandleSizingUI()
    
    func addTapGestureRecognizer(gesture: inout UITapGestureRecognizer) {
        gesture = UITapGestureRecognizer(target: self, action: #selector(userTappedOnLink))
        gesture.numberOfTapsRequired = 1
    }
    
    @objc func userTappedOnLink() {
        print("clicked!")
    }
    
    func cellType(_ new: ItemVK) -> [String: Any] {
        var dict = [String: Any]()
        
        switch new.attachments[0].type {
        case .photo:
            dict["identifier"] = "NewsCellPhotoPost"
            dict["imageOfPost"] = new.attachments[0].photo?.photo_604
            dict["ratio"] = new.attachments[0].photo?.ratio
            dict["addedHeight"] = 150.0
        case .link:
            dict["identifier"] = "NewsCellLinkPost"
            dict["imageOfPost"] = new.attachments[0].photo?.photo_604
            dict["ratio"] = new.attachments[0].photo?.ratio
            dict["addedHeight"] = 190.0
        case .video:
            dict["identifier"] = "NewsCellPhotoPost"
            dict["imageOfPost"] = new.attachments[0].photo?.photo_800
            dict["ratio"] = 0.75
            dict["addedHeight"] = 150.0
        case .doc:
            dict["identifier"] = "NewsCellGifPost"
            dict["imageOfPost"] = new.attachments[0].url
            dict["ratio"] = new.attachments[0].photo?.ratio
            dict["addedHeight"] = 150.0
        case .none:
            dict["identifier"] = "NewsCellPhotoPost"
            dict["imageOfPost"] = ""
            dict["ratio"] = 0.5
            dict["addedHeight"] = -50.0
        default:
            dict["identifier"] = "NewsCellPhotoPost"
            dict["imageOfPost"] = ""
            dict["ratio"] = 0.5
            dict["addedHeight"] = 150.0
        }
        return dict
    }
    
    func setHeightOfText(text: String) -> CGFloat {
        let font = UIFont.systemFont(ofSize: 14.0)
        let array = text.components(separatedBy: "<br>")
        var updateString = array.joined(separator: "\n")
        if updateString.count >= 200 { updateString = updateString.dropLast(updateString.count - 200) + "..." }
        
        let size = handleSizingUI.getLabelSize(bounds: UIScreen.main.bounds, text: updateString, font: font)
        
        return CGFloat(size.height)
    }
    
}

