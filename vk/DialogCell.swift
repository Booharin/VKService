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
    
    func setMessageText(text: String, out: Int) {
        let array = text.components(separatedBy: "<br>")
        let updateString = array.joined(separator: "\n")
        message.text = updateString
        
        let customBounds = CGRect(x: 0.0, y: 0.0, width: bounds.width - 80.0, height: 0.0)
        let size = handleSizingUI.getLabelSize(bounds: customBounds, text: message.text!, font: message.font)
        let sizeOfLabel = CGSize(width: size.width + 20.0, height: size.height + 10.0)
        handleSizingUI.labelFrame(labelSize: sizeOfLabel, label: message, originX: 10, originY: 0)
        if out == 1 { message.backgroundColor = #colorLiteral(red: 0.7509090551, green: 0.7755917149, blue: 0.9828761576, alpha: 1) } else { message.backgroundColor = .white }
        
        message.layer.cornerRadius = 5.0
        message.layer.masksToBounds = true
        message.layer.borderColor = #colorLiteral(red: 0.8961292574, green: 0.9088429323, blue: 1, alpha: 1)
        message.layer.borderWidth = 1.0
        
        message.textAlignment = .left
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.firstLineHeadIndent = 10.0
        paragraphStyle.headIndent = 10.0
        paragraphStyle.tailIndent = -10.0
        let attributes = [NSAttributedStringKey.paragraphStyle: paragraphStyle]
        
        let myMutableString = NSMutableAttributedString(
            string: updateString,
            attributes: attributes)
        message.attributedText = myMutableString
        
    }
    
    func setDate(text: String) {
        date.text = text
        
        handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: date.text!, font: date.font), label: date, originX: bounds.width - 60, originY: 2)
    }
    
}








