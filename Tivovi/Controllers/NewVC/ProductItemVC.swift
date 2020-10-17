//
//  ProductItemVC.swift
//  TruckTrace
//
//  Created by Admin on 1/20/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class ProductItemVC: UIViewController {

    @IBOutlet weak var viewDateBG: UIView!
    @IBOutlet weak var lblDate: UILabel!
    
    @IBOutlet weak var imgViewAvatar: UIImageView!
    @IBOutlet weak var lblComment: UILabel!
    
    var packageModel: PackageModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initControls()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.refreshContent()
    }
    
    func initControls() {
        let height = self.viewDateBG.frame.height
        self.viewDateBG.layer.cornerRadius = height/2
        self.viewDateBG.layer.masksToBounds = true
        
        self.imgViewAvatar.layer.cornerRadius = 10
        self.imgViewAvatar.layer.masksToBounds = true
    }
    
    func refreshContent() {
        guard let model = self.packageModel else {
            return
        }
        
        if model.time != nil {
            lblDate.text = String(model.time!.prefix(10))
        }
        
        lblComment.text = model.text_description
    }

}
