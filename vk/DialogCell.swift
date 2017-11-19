//
//  DialogCell.swift
//  vk
//
//  Created by Александр on 14.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit

class DialogCell: UICollectionViewCell {
  
  @IBOutlet weak var message: UILabel! {
    didSet {
      message.translatesAutoresizingMaskIntoConstraints = false
      message.numberOfLines = 0
    }
  }
  @IBOutlet weak var date: UILabel! {
    didSet {
      date.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  
  let handleSizingUI = HandleSizingUI()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
  }
  
  func setMessageText(text: String) {
    message.text = text
    
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: message.text!, font: message.font), label: message, originX: 10, originY: 15)
    
  }
  func setDate(text: String) {
    date.text = text
    
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: date.text!, font: date.font), label: date, originX: bounds.width - 60, originY: 2)
  }
  
}
