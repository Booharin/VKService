//
//  ToDayTableViewCell.swift
//  ToDayVK
//
//  Created by Александр on 27.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit

class ToDayTableViewCell: UITableViewCell {
    @IBOutlet weak var toDayText: UILabel! {
        didSet {
            toDayText.translatesAutoresizingMaskIntoConstraints = false
            toDayText.numberOfLines = 0
        }
    }
    @IBOutlet weak var toDayImage: UIImageView! {
        didSet {
            toDayImage.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    let handleSizingUI = HandleSizingUI()
    var widthOfMainScreen: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func setPostText(text: String) {
        let array = text.components(separatedBy: "<br>")
        var updateString = array.joined(separator: "\n")
        if updateString.count >= 200 { updateString = updateString.dropLast(updateString.count - 200) + "..." }
        toDayText.text = updateString
        let boundsOfText = CGRect(x: 10, y: 10, width: widthOfMainScreen - 90, height: bounds.height)
        handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: boundsOfText, text: toDayText.text!, font: toDayText.font), label: toDayText, originX: 10, originY: 10)
    }
    
    func setSizeImageOfPost(widthOfScreen: CGFloat, ratio: Double) {
        handleSizingUI.imageOfPost(image: toDayImage, width: widthOfScreen, ratio: ratio, originX: Int(widthOfMainScreen - 90), originY: 10)
    }
    
}
