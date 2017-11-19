//
//  MyGroupsCell.swift
//  vk
//
//  Created by Александр on 22.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit

class MyGroupsCell: UITableViewCell {
  
  @IBOutlet weak var photoOfMyGroup: UIImageView! {
    didSet {
      photoOfMyGroup.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  @IBOutlet weak var nameOfMyGroup: UILabel! {
    didSet {
      nameOfMyGroup.translatesAutoresizingMaskIntoConstraints = false
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
    
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: nameOfMyGroup.text!, font: nameOfMyGroup.font), label: nameOfMyGroup, originX: 70, originY: 25)
    handleSizingUI.imageFrame(image: photoOfMyGroup, imageSide: 60, originX: 0, originY: 5, round: true)
  }
  
  func setGroupName(text: String) {
    nameOfMyGroup.text = text
    
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: nameOfMyGroup.text!, font: nameOfMyGroup.font), label: nameOfMyGroup, originX: 70, originY: 25)
  }
  
}







