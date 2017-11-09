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
  var photoOfPost = PhotoOfPost()
  var items = Item()
  
  convenience init(photoID: String, nameID: String, textOfPost: String, photoOfPost: PhotoOfPost, items: Item) {
    self.init()
    self.photoID = photoID
    self.nameID = nameID
    self.textOfPost = textOfPost
    self.photoOfPost = photoOfPost
    self.items = items
  }
}

class PhotoOfPost {
  var urlOfImage = ""
  var width = 1
  var height = 1
  var ratio: Double {
    return Double(height / width)
  }
}

class Item {
  var likes = ""
  var comments = ""
  var reposts = ""
}



