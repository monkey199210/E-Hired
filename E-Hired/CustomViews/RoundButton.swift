//
//  RoundButton.swift
//  E-Hired
//
//  Created by Rui Caneira on 11/7/16.
//  Copyright © 2016 Rui Caneira. All rights reserved.
//

import UIKit

class RoundButton: UIButton {
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 8
    }

}
