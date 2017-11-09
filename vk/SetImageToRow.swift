//
//  SetImageToRow.swift
//  vk
//
//  Created by Александр on 26.10.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import UIKit

class SetImageToRow: Operation {
  private let indexPath: IndexPath
  private weak var tableView: UITableView?
  
  init(indexPath: IndexPath, tableView: UITableView) {
    self.indexPath = indexPath
    self.tableView = tableView
  }
  
  override func main() {
    guard let tableView = tableView,
    let getCacheImage = dependencies[0] as? GetCacheImage,
      let image = getCacheImage.outputImage else { return }
    
    if let cell = tableView.cellForRow(at: indexPath) as? AllFriendsCell {
      cell.avatar.image = image
    }
  }
}
