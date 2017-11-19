//
//  Photo.swift
//  vk
//
//  Created by Александр on 28.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class Photo: Object {
  @objc dynamic var photo = ""
  convenience init(json: JSON) {
    self.init()
    self.photo = json["src_big"].stringValue
  }
  convenience init(photo: String) {
    self.init()
    self.photo = photo
  }
}


