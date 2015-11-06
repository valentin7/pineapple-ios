//
//  PAButton.swift
//  Pineapple
//
//  Created by Valentin Perez on 7/17/15.
//  Copyright (c) 2015 Valpe Technologies. All rights reserved.
//

import UIKit

class PAButton: UIButton {

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    self.layer.cornerRadius = 5
    self.clipsToBounds = true
  }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
