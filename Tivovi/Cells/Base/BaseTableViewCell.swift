//
//  BaseTableViewCell.swift
//  Tivovi
//
//  Created by Đinh Trọng Tú on 2/21/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {

    var index: IndexPath?
    var model: AnyObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(model: AnyObject, atIndex: IndexPath) {
        self.index = atIndex
        self.model = model
    }

}
