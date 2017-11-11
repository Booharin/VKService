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
  @IBOutlet weak var titleUrl: UILabel! {
    didSet {
      titleUrl.translatesAutoresizingMaskIntoConstraints = false
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
    handleSizingUI.imageFrame(image: photoID, imageSide: 60, originX: 0, originY: 5, round: true)
  }
  
  // nameID
  func setName(text: String) {
    nameID.text = text
    
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: nameID.text!, font: nameID.font), label: nameID, originX: 70, originY: 25)
  }
  // textOfPost
  func setPostText(text: String) {
    textOfPost.text = text
    
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: textOfPost.text!, font: textOfPost.font), label: textOfPost, originX: 10, originY: 70)
  }
  // imageOfPost
  func setSizeImageOfPost(widthOfScreen: CGFloat, ratio: Double) {
    handleSizingUI.imageOfPost(image: photoOfPost, width: widthOfScreen, ratio: ratio, originY: 105)
  }
  // link
  func setTitleOfLink(text: String, originY: CGFloat) {
    titleUrl.text = text
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: titleUrl.text!, font: titleUrl.font), label: titleUrl, originX: 10, originY: originY - 60)
  }
  // likes
  func setLikesCount(text: String, originY: CGFloat) {
    likes.text = text
    handleSizingUI.imageFrame(image: likesImage, imageSide: 30, originX: 25, originY: Int(originY - 35), round: false)
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: likes.text!, font: likes.font), label: likes, originX: 60, originY: originY - 30)
  }
  // comments
  func setCommentsCount(text: String, originY: CGFloat) {
    comments.text = text
    handleSizingUI.imageFrame(image: commentsImage, imageSide: 30, originX: 110, originY: Int(originY - 35), round: false)
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: comments.text!, font: comments.font), label: comments, originX: 145, originY: originY - 30)
  }
  // reposts
  func setRepostsCount(text: String, originY: CGFloat) {
    reposts.text = text
    handleSizingUI.imageFrame(image: repostsImage, imageSide: 30, originX: 185, originY: Int(originY - 35), round: false)
    handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: reposts.text!, font: reposts.font), label: reposts, originX: 220, originY: originY - 30)
  }
  
}























