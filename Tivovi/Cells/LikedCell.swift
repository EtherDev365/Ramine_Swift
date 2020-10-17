//
//  LikedCell.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit

class LikedCell: UITableViewCell {

    @IBOutlet var imgCompany: UIImageView!
    
    @IBOutlet var lblCompanyName: UILabel!
    
    @IBOutlet var CircleView: UIView!
    
    @IBOutlet var lblLikedNumber: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func draw(_ rect: CGRect) {
        self.CircleView.layer.cornerRadius = self.CircleView.frame.size.width/2;
        self.CircleView.layer.borderColor = UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0).cgColor
        self.CircleView.layer.borderWidth = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
