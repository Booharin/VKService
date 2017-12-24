//
//  AllGroupsCell.swift
//  vk
//
//  Created by Александр on 22.09.17.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit

class AllGroupsCell: UITableViewCell {
    
    @IBOutlet weak var nameOfGroup: UILabel! {
        didSet {
            nameOfGroup.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var groupPhoto: UIImageView! {
        didSet {
            groupPhoto.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var countMembers: UILabel! {
        didSet {
            countMembers.translatesAutoresizingMaskIntoConstraints = false
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
        // name
        handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: nameOfGroup.text!, font: nameOfGroup.font), label: nameOfGroup, originX: 70, originY: handleSizingUI.instets)
        // count members
        handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: countMembers.text!, font: countMembers.font), label: countMembers, originX: 70, originY: 50)
        // photo
        handleSizingUI.imageFrame(image: groupPhoto, imageSide: 60, originX: 0, originY: 5, round: true)
    }
    
    func setGroupName(text: String) {
        nameOfGroup.text = text
        
        handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: nameOfGroup.text!, font: nameOfGroup.font), label: nameOfGroup, originX: 70, originY: handleSizingUI.instets)
    }
    
    func setCountMembers(text: String) {
        countMembers.text = text
        
        handleSizingUI.labelFrame(labelSize: handleSizingUI.getLabelSize(bounds: bounds, text: countMembers.text!, font: countMembers.font), label: countMembers, originX: 70, originY: 50)
    }
    
}









