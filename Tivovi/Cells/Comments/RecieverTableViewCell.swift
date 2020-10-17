//
//  RecieverTableViewCell.swift
//  Tivovi
//
//  Created by Kamal Thakur on 06/03/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit

class RecieverTableViewCell: UITableViewCell {

    @IBOutlet weak var lblRecieverComment: UILabel!
    @IBOutlet weak var viewRounded: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension RecieverTableViewCell {
    func configureReceiverCell(model: CommentModel?, indexPath: IndexPath) {
        self.viewRounded.layer.cornerRadius = 16.0
        self.viewRounded.layer.masksToBounds = true
        self.lblRecieverComment.text = model?.comment
        self.lblRecieverComment.translatesAutoresizingMaskIntoConstraints = false
        let lblSize:CGSize = self.lblRecieverComment.sizeThatFits(CGSize(width: (self.bounds.size.width-50), height: CGFloat.greatestFiniteMagnitude))
        let xAxis = self.bounds.size.width - (55+lblSize.width)
        self.lblRecieverComment.frame = CGRect(x: xAxis, y: self.lblRecieverComment.frame.origin.y, width: lblSize.width, height: lblSize.height)
    }
}
