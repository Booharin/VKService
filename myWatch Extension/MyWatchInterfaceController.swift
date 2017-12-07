//
//  MyWatchInterfaceController.swift
//  myWatch Extension
//
//  Created by Александр on 04.12.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit
import WatchKit

class MyWatchInterfaceController: WKInterfaceController {
  @IBOutlet var imageView: WKInterfaceImage!
  @IBOutlet var labelView: WKInterfaceLabel!
  
  override func awake(withContext context: Any?) {
    super.awake(withContext: context)
    
    if let image = context as? UIImage {
    self.imageView.setImage(image)
    }
  }
}

