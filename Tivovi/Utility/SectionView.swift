//
//  SectionView.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
 

class SectionView: UIView,refreshDataMessageDelegets {
    
    @IBOutlet weak var bottomViewSection: UIView!
    

    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var btnImageView: UIImageView!

    @IBOutlet weak var lblSecondNumber: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    
    @IBOutlet weak var lblPostnord: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    var package_id:String?
    @IBOutlet weak var imgOpenClose: UIImageView!
    var nav:UINavigationController?
    
    func loadSection(frame:CGRect,value:UINavigationController,lblnumber:String,status:String,imgArr:String,logoImg:String,tagId:Int)->SectionView
    {
        let xibView = Bundle.main.loadNibNamed("SectionView", owner: self, options: nil)!.first as! SectionView
        xibView.frame = frame
        package_id = lblnumber
        xibView.lblStatus.text = status
        xibView.imgOpenClose.image = UIImage(named: imgArr)!
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        xibView.btnPlus.addTarget(self, action: #selector(self.openPopup), for: .touchUpInside)
        xibView.nav = value
        xibView.btnPlus.tag = tagId
        let first4 = lblnumber.substring(to:lblnumber.index(lblnumber.startIndex, offsetBy: 4))
        xibView.lblNumber.text = first4
        xibView.lblSecondNumber.text = lblnumber
        
        if(logoImg != "") {            
            var myLogoImage = logoImg
            xibView.btnImageView.setImageWithURL(urlString: myLogoImage, placeholderImageName: "")
        }
        
        return xibView
    }
    @objc func openPopup(sender: UIButton){
        
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopupVC") as! PopupVC
        vc.package_id = String(sender.tag)
        vc.delegets = self
        self.nav?.present(vc, animated: true, completion: nil)
    }
    override func draw(_ rect: CGRect) {
        
    }
    func getSuccessMessage() {
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CustomTabBarController") as! CustomTabBarController
        self.nav?.pushViewController(vc, animated: false)
    }
    
    
}
