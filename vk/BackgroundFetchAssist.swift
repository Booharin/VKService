//
//  Utils.swift
//  vk
//
//  Created by Александр on 20.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation

class Utils {
  let fetchCitiesWeatherGroup = DispatchGroup()
  var timer: DispatchSourceTimer?
  
  static let instance = Utils()
  private init(){}
  
  var lastUpdate: Date? {
    get {
      return UserDefaults.standard.object(forKey: "Last Update") as? Date
    }
    set {
      UserDefaults.standard.setValue(Date(), forKey: "Last Update")
    }
  }
}
