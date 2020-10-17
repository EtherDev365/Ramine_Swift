//
//  FriendsTableViewCell.swift
//  Tivovi
//
//  Created by Raminde on 29/06/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    @IBOutlet weak var firimage: UIImageView!
    @IBOutlet weak var t1l1: UILabel!
    
    @IBOutlet weak var secimage: UIImageView!
    @IBOutlet weak var t2l2: UILabel!
    
    @IBOutlet weak var thirimage: UIImageView!
    @IBOutlet weak var t3l3: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
