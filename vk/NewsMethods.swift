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
    
    func cellType(_ new: ItemVK, _ response: ResponseNewsVK) -> [String: Any] {
        var dict = [String: Any]()
        
        switch new.attachments?[0].type {
        case .photo?:
            dict["identifier"] = "NewsCellPhotoPost"
            dict["imageOfPost"] = new.attachments?[0].photo?.photo_604
            dict["ratio"] = new.attachments?[0].photo?.ratio ?? 0.5
            dict["addedHeight"] = 150.0
        case .link?:
            dict["identifier"] = "NewsCellLinkPost"
            dict["imageOfPost"] = new.attachments?[0].link?.photo?.photo_604
            dict["ratio"] = new.attachments?[0].photo?.ratio ?? 0.5
            dict["addedHeight"] = 190.0
        case .video?:
            dict["identifier"] = "NewsCellPhotoPost"
            dict["imageOfPost"] =
                new.attachments?[0].video?.photo_800 ??
                new.attachments?[0].video?.photo_640 ??
                new.attachments?[0].video?.photo_320
            dict["ratio"] = 0.75
            dict["addedHeight"] = 150.0
        case .doc?:
            dict["identifier"] = "NewsCellGifPost"
            dict["imageOfPost"] = new.attachments?[0].doc?.url
            dict["ratio"] = new.attachments?[0].doc?.ratioForGif ?? 0.5
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
        
        // MARK: - Setting photo & name of creator of post
        
        if new.source_id > 0 {
            response.profiles.forEach { profile in
                if profile.id == new.source_id {
                    dict["nameID"] = profile.fullName 
                    dict["photoID"] = profile.photo_100
                }
            }
        } else {
            response.groups.forEach { group in
                if group.id == -new.source_id {
                    dict["nameID"] = group.name
                    dict["photoID"] = group.photo_100
                }
            }
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

