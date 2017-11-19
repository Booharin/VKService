//
//  AllFriendsCell.swift
//  vk
//
//  Created by Александр on 21.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit

class AllFriendsCell: UITableViewCell {
  
  @IBOutlet weak var friendsName: UILabel! {
    didSet {
      friendsName.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  @IBOutlet weak var avatar: UIImageView! {
    didSet {
      avatar.translatesAutoresizingMaskIntoConstraints = false
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
    
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: friendsName.text!, font: friendsName.font), label: friendsName, originX: 70, originY: 25)
    handleSizingUI.imageFrame(image: avatar, imageSide: 60, originX: 0, originY: 5, round: true)
  }
  
  func setFriendName(text: String) {
    friendsName.text = text
    
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: friendsName.text!, font: friendsName.font), label: friendsName, originX: 70, originY: 25)
  }
  
}


























