//
//  ButtonItem.swift
//  vk
//
//  Created by Александр on 19.12.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit

class ButtonItem {
    let textField: UITextField = {
        let tf = UITextField(frame: CGRect(x: 30, y: 0, width: 300, height: 30))
        tf.textColor = .black
        tf.backgroundColor = .white
        
        tf.layer.cornerRadius = 10.0
        tf.layer.masksToBounds = true
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.layer.borderWidth = 1.0
        
        return tf
        
    }()
    
    
}
