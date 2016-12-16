//
//  JobCell.swift
//  E-Hired
//
//  Created by Rui Caneira on 9/19/16.
//  Copyright © 2016 Rui Caneira. All rights reserved.
//

import UIKit
class JobCell: UITableViewCell, CellInterface {
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var company: UILabel!
    
    @IBOutlet weak var address: UILabel!
    @IBOutlet weak var snippet: UILabel!
}
