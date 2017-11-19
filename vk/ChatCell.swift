//
//  ChatCell.swift
//  vk
//
//  Created by Александр on 12.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
  @IBOutlet weak var photoID: UIImageView! {
    didSet {
      photoID.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  @IBOutlet weak var nameID: UILabel! {
    didSet {
      nameID.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  @IBOutlet weak var photoIDLastMessage: UIImageView! {
    didSet {
      photoIDLastMessage.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  @IBOutlet weak var lastMessage: UILabel! {
    didSet {
      lastMessage.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  @IBOutlet weak var date: UILabel! {
    didSet {
      date.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  
  let handleSizingUI = HandleSizingUI()
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    // nameID
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: nameID.text!, font: nameID.font), label: nameID, originX: 70, originY: 10)
    // photoID
    handleSizingUI.imageFrame(image: photoID, imageSide: 60, originX: 0, originY: 10, round: true)
  }
  // date
  func setDate(text: String, width: CGFloat) {
    date.text = text
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: date.text!, font: date.font), label: date, originX: width - 70, originY: 10)
  }
  // lastMessage
  func setLastMessage(text: inout String) {
    if text.count >= 30 { text = text.dropLast(text.count - 30) + "..." }
    if text == "Стикер" { lastMessage.textColor = UIColor.blue } else { lastMessage.textColor = UIColor.gray }
    lastMessage.text = text
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: lastMessage.text!, font: lastMessage.font), label: lastMessage, originX: 70, originY: 30)
  }
  
}
















