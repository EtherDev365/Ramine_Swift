//
//  SenderTableViewCell.swift
//  Tivovi
//
//  Created by Kamal Thakur on 06/03/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit

class SenderTableViewCell: UITableViewCell {

    @IBOutlet weak var imgUser: UIImageView!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblSenderComment: UILabel!
    @IBOutlet weak var viewComments: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

extension SenderTableViewCell {
    func configureSenderCell(model: CommentModel?, indexPath: IndexPath) {
        self.viewComments.layer.cornerRadius = 16.0
        self.viewComments.layer.masksToBounds = true
        self.lblUserName.text = model?.username
        self.lblSenderComment.text = model?.comment
        self.lblSenderComment.translatesAutoresizingMaskIntoConstraints = false
        let lblSize:CGSize = self.lblSenderComment.sizeThatFits(CGSize(width: (self.bounds.size.width-50), height: CGFloat.greatestFiniteMagnitude))
        let xAxis = self.bounds.size.width - (55+lblSize.width)
        self.lblSenderComment.frame = CGRect(x: xAxis, y: self.lblSenderComment.frame.origin.y, width: lblSize.width, height: lblSize.height)
    }
}
