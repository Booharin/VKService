//
//  HandleSizingUI.swift
//  vk
//
//  Created by Александр on 03.11.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import Foundation
import UIKit

class HandleSizingUI {
    let instets: CGFloat = 20.0
    
    func getLabelSize(bounds: CGRect, text: String, font: UIFont) -> CGSize {
        let maxWidth = bounds.width - instets
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font: font], context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    func labelFrame (labelSize: CGSize, label: UILabel, originX: CGFloat, originY: CGFloat) {
        let labelOrigin = CGPoint(x: originX, y: originY)
        label.frame = CGRect(origin: labelOrigin, size: labelSize)
    }
    
    func imageFrame(image: UIImageView, imageSide: Int, originX: Int, originY: Int, round: Bool) {
        let imageSize = CGSize(width: imageSide, height: imageSide)
        let imageOrigin = CGPoint(x: originX, y: originY)
        image.frame = CGRect(origin: imageOrigin, size: imageSize)
        if round {
            image.layer.cornerRadius = 30.0
            image.layer.masksToBounds = true
            image.layer.borderColor = UIColor.white.cgColor
            image.layer.borderWidth = 1.0
        }
    }
    
    func imageOfPost(image: UIImageView, width: CGFloat, ratio: Double, originX: Int, originY: Int) {
        let imageSize = CGSize(width: Int(width), height: Int(ceil(Double(width) * ratio)))
        let imageOrigin = CGPoint(x: originX, y: originY)
        image.frame = CGRect(origin: imageOrigin, size: imageSize)
    }
    
}
