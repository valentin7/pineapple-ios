//
//  PlaceTableViewCell.swift
//  Pineapple
//
//  Created by Valentin Perez on 5/23/15.
//  Copyright (c) 2015 Valpe Technologies. All rights reserved.
//

import UIKit

class PlaceTableViewCell: UITableViewCell {

  @IBOutlet var placeImage: UIImageView!
  @IBOutlet var placeName: UILabel!
  @IBOutlet var placePrice: UILabel!
  @IBOutlet var placeDescription: UILabel!
  @IBOutlet var placeCity: UILabel!
  @IBOutlet var shadeView: UIView!
    
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }

  override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)

    // Configure the view for the selected state
  }

}
