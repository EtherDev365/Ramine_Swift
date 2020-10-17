//
//  CustomCell.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet var lblCat: UILabel!
    
    @IBOutlet var lblTitle: UILabel!
    
    
    @IBOutlet var lblNumber: UILabel!
    
    
    @IBOutlet var imgStatus: UIButton!
    
    @IBOutlet var lblStatus: UILabel!
    
    @IBOutlet var lblPlace: UILabel!
    
    @IBOutlet var lblShares: UILabel!
    
    @IBOutlet var lblComments: UILabel!
    
    @IBOutlet var btnUpdate: UIButton!
    @IBOutlet var lblLastUpdate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func fillItem(){
        
    }
}
