//
//  New.swift
//  vk
//
//  Created by Александр on 15.10.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation

class New {
    var photoID = ""
    var nameID = ""
    var textOfPost = ""
    var typeOfAttachment = TypeOfAttachment.none
    var photoOfPost = PhotoOfPost()
    var linkOfPost = LinkOfPost()
    var items = Item()
    
    convenience init(photoID: String, nameID: String, textOfPost: String, typeOfAttachment: TypeOfAttachment, photoOfPost: PhotoOfPost, linkOfPost: LinkOfPost, items: Item) {
        self.init()
        self.photoID = photoID
        self.nameID = nameID
        self.textOfPost = textOfPost
        self.typeOfAttachment = typeOfAttachment
        self.linkOfPost = linkOfPost
        self.photoOfPost = photoOfPost
        self.items = items
    }
}

class PhotoOfPost {
  var urlOfImage = ""
  var width = 1
  var height = 1
  var ratio: Double {
    return Double(height) / Double(width)
  }
}

class LinkOfPost {
  var urlOfLink = ""
  var title = ""
  var description = ""
  var image : String?
}

class Item {
  var likes = ""
  var comments = ""
  var reposts = ""
}

enum TypeOfAttachment {
  case photo
  case link
  case audio
  case video
  case poll
  case none
}

