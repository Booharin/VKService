//
//  MapTableViewCell.swift
//  vk
//
//  Created by Александр on 16.11.2017.
//  Copyright © 2017 Александр. All rights reserved.
//

import UIKit

class MapTableCell: UITableViewCell {

  @IBOutlet weak var geoText: UILabel!
  
  override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
