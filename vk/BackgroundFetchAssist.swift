//
//  Utils.swift
//  vk
//
//  Created by Александр on 20.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation

class BackgroundFetchAssist {
  let fetchCitiesWeatherGroup = DispatchGroup()
  var timer: DispatchSourceTimer?
  
  static let instance = BackgroundFetchAssist()
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
