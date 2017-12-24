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
            textOfPost.numberOfLines = 0
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
            titleUrl.numberOfLines = 0
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
    
    var heightOfTextOfPost = 0.0
    var heightOfTitleOfURL = 0.0
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
        let array = text.components(separatedBy: "<br>")
        var updateString = array.joined(separator: "\n")
        if updateString.count >= 200 { updateString = updateString.dropLast(updateString.count - 200) + "..." }
        textOfPost.text = updateString
        
        handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: textOfPost.text!, font: textOfPost.font), label: textOfPost, originX: 10, originY: 70)
        let size = handleSizingUI.getLabelSize(bounds: bounds, text: textOfPost.text!, font: textOfPost.font)
        heightOfTextOfPost = Double(size.height)
    }
    // imageOfPost
    func setSizeImageOfPost(widthOfScreen: CGFloat, ratio: Double) {
        handleSizingUI.imageOfPost(image: photoOfPost, width: widthOfScreen, ratio: ratio, originX: 0, originY: 95 + Int(heightOfTextOfPost))
    }
    // link
    func setTitleOfLink(text: String, originY: CGFloat) {
        titleUrl.text = text
        let size = handleSizingUI.getLabelSize(bounds: bounds, text: titleUrl.text!, font: titleUrl.font)
        heightOfTitleOfURL = Double(size.height)
        handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: titleUrl.text!, font: titleUrl.font), label: titleUrl, originX: 10, originY: originY - (65 + CGFloat(heightOfTitleOfURL)))
    }
    // likes
    func setLikesCount(text: String, originY: CGFloat) {
        likes.text = text
        handleSizingUI.imageFrame(image: likesImage, imageSide: 20, originX: 25, originY: Int(originY - 35), round: false)
        handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: likes.text!, font: likes.font), label: likes, originX: 50, originY: originY - 33)
    }
    // comments
    func setCommentsCount(text: String, originY: CGFloat) {
        comments.text = text
        handleSizingUI.imageFrame(image: commentsImage, imageSide: 20, originX: 110, originY: Int(originY - 34), round: false)
        handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: comments.text!, font: comments.font), label: comments, originX: 135, originY: originY - 33)
    }
    // reposts
    func setRepostsCount(text: String, originY: CGFloat) {
        reposts.text = text
        handleSizingUI.imageFrame(image: repostsImage, imageSide: 20, originX: 185, originY: Int(originY - 34), round: false)
        handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: reposts.text!, font: reposts.font), label: reposts, originX: 210, originY: originY - 33)
    }
    
}






















