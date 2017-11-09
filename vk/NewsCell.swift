//
//  NewsCell.swift
//  vk
//
//  Created by Александр on 15.10.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit
import Alamofire

class NewsCell: UITableViewCell {
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
  @IBOutlet weak var textOfPost: UILabel! {
    didSet {
      textOfPost.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  @IBOutlet weak var photoOfPost: UIImageView! {
    didSet {
      photoOfPost.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  @IBOutlet weak var likesImage: UIImageView! {
    didSet {
      likesImage.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  @IBOutlet weak var likes: UILabel! {
    didSet {
      likes.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  @IBOutlet weak var commentsImage: UIImageView! {
    didSet {
      commentsImage.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  @IBOutlet weak var comments: UILabel! {
    didSet {
      comments.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  @IBOutlet weak var repostsImage: UIImageView! {
    didSet {
      repostsImage.translatesAutoresizingMaskIntoConstraints = false
    }
  }
  @IBOutlet weak var reposts: UILabel! {
    didSet {
      reposts.translatesAutoresizingMaskIntoConstraints = false
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
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: nameID.text!, font: nameID.font), instets: 25, label: nameID, originX: 70)
    // photoID
    handleSizingUI.imageFrame(image: photoID, imageSide: 60, originX: 0, originY: 5, round: true)
    // textOfPost
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: textOfPost.text!, font: textOfPost.font), instets: 70, label: textOfPost, originX: 10)
    // likes
    handleSizingUI.imageFrame(image: likesImage, imageSide: 20, originX: 5, originY: 375, round: false)
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: likes.text!, font: likes.font), instets: 380, label: likes, originX: 30)
    // comments
    handleSizingUI.imageFrame(image: commentsImage, imageSide: 20, originX: 60, originY: 375, round: false)
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: comments.text!, font: comments.font), instets: 380, label: comments, originX: 85)
    // reposts
    handleSizingUI.imageFrame(image: repostsImage, imageSide: 20, originX: 115, originY: 375, round: false)
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: reposts.text!, font: reposts.font), instets: 380, label: reposts, originX: 140)
  }
  
  // nameID
  func setName(text: String) {
    nameID.text = text
    
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: nameID.text!, font: nameID.font), instets: 25, label: nameID, originX: 70)
  }
  // textOfPost
  func setPostText(text: String) {
    textOfPost.text = text
    
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: textOfPost.text!, font: textOfPost.font), instets: 70, label: textOfPost, originX: 10)
  }
  // imageOfPost
  func setSizeImageOfPost(widthOfScreen: CGFloat, ratio: Double) {
    handleSizingUI.imageOfPost(image: photoOfPost, width: widthOfScreen, ratio: ratio, originY: 85)
  }
  // likes
  func setLikesCount(text: String) {
    likes.text = text
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: likes.text!, font: likes.font), instets: 380, label: likes, originX: 30)
  }
  // comments
  func setCommentsCount(text: String) {
    comments.text = text
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: comments.text!, font: comments.font), instets: 380, label: comments, originX: 85)
  }
  // reposts
  func setRepostsCount(text: String) {
    reposts.text = text
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: reposts.text!, font: reposts.font), instets: 380, label: reposts, originX: 140)
  }
  
}























