//
//  ContactViewCell.swift
//  Tivovi
//
//  Created by Raminde on 30/07/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit

class ContactViewCell: UITableViewCell {

    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Number: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
