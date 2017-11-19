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
  func addTapGestureRecognizer(gesture: inout UITapGestureRecognizer) {
    gesture = UITapGestureRecognizer(target: self, action: #selector(userTappedOnLink))
    gesture.numberOfTapsRequired = 1
  }
  
  @objc func userTappedOnLink() {
    print("clicked!")
  }
  
  func cellType(_ new: New) -> [String: Any] {
    var dict = [String: Any]()
    
    switch new.typeOfAttachment {
    case .photo:
      dict["identifier"] = "NewsCellPhotoPost"
      dict["imageOfPost"] = new.photoOfPost.urlOfImage
      dict["ratio"] = new.photoOfPost.ratio
      dict["addedHeight"] = 150.0
    case .link:
      dict["identifier"] = "NewsCellLinkPost"
      dict["imageOfPost"] = new.linkOfPost.image ?? ""
      dict["ratio"] = 0.5
      dict["addedHeight"] = 190.0
    case .video:
      dict["identifier"] = "NewsCellPhotoPost"
      dict["imageOfPost"] = new.photoOfPost.urlOfImage
      dict["ratio"] = 0.75
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
}

