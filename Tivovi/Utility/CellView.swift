//
//  CellView.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import RappleProgressHUD
import JKNotificationPanel
import TKSubmitTransition

class CellView: UIView {
    let pannel = JKNotificationPanel()

    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    
    @IBOutlet weak var testAAA: UIButton!
    @IBOutlet var lblCat: UILabel!
    
    @IBOutlet var lblTitle: UILabel!
    
    
    @IBOutlet var lblNumber: UILabel!
    
    
    @IBOutlet var imgStatus: UIButton!
    
    @IBOutlet var lblStatus: UILabel!
    
    @IBOutlet var lblPlace: UILabel!
    
    @IBOutlet var lblShares: UILabel!
    
    @IBOutlet var lblComments: UILabel!
    var abc = ""
    
    
    @IBOutlet weak var btnUpdate: UIButton!

    @IBOutlet var lblLastUpdate: UILabel!
    var nav:UINavigationController?
    func fillCellVal(frame:CGRect,value:UINavigationController,lblCat:String,lblTitle:String,lblStatus:String,lblPlace:String,lblShares:String,lblComments:String,lblLastUpdate:String,lblNumber:String,m_id:String,comment_count:String)->CellView{
        let xibView = Bundle.main.loadNibNamed("CellView", owner: self, options: nil)!.first as! CellView
        xibView.frame = frame
        xibView.lblCat.text = lblCat
        xibView.lblTitle.text = lblTitle
        xibView.lblStatus.text = lblStatus
        xibView.lblNumber.text = lblNumber
        xibView.lblComments.text = "Comment: "+comment_count
        xibView.btnUpdate.isEnabled = true
        xibView.btnUpdate.addTarget(self, action: #selector(self.openPopup), for: .touchUpInside)
        
        xibView.btnUpdate.tag = Int(m_id)!
        xibView.btnComment.addTarget(self, action: #selector(self.commentPopup), for: .touchUpInside)
        xibView.btnComment.tag = Int(m_id)!
        
        xibView.btnShare.addTarget(self, action: #selector(self.sharePopup), for: .touchUpInside)
        xibView.btnShare.tag = Int(m_id)!
        
        xibView.nav = value
        
        
      
        
        
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return xibView
    }
    @objc func sharePopup(sender: UIButton){
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "PackageShareVC") as! PackageShareVC
        vc.shipmentId = String(sender.tag)
        //self.nav?.pushViewController(vc, animated: true)
        self.nav?.present(vc, animated: true, completion: nil)
    }
    @objc func openPopup(sender: UIButton){
       
        //self.btnUpdate.startLoadingAnimation()
        UIButton.animate(withDuration: 0.5) { () -> Void in
           sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }

        UIButton.animate(withDuration: 0.5, delay: 0.45, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
            sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
        }, completion: nil)

        self.API_shipment_action(lblNumber: String(sender.tag))
    }
    @objc func commentPopup(sender: UIButton){
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "CommentVC") as! CommentVC
        vc.shipmentId = String(sender.tag)
        //self.nav?.pushViewController(vc, animated: true)
        self.nav?.present(vc, animated: true, completion: nil)
    }
    func API_shipment_action(lblNumber:String){
        let user_details = UserModel.sharedInstance
        RappleActivityIndicatorView.startAnimating()
        let parameterDict =  [
            "user_id":  user_details.user_id ?? "",
            "shipmentId": lblNumber ?? "",
            "status": "1"
        ]
        DashboardManager.API_shipment_action(information: parameterDict) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            if error==nil{
                if(json["status"]==true){
                    //self.btnUpdate.hideLoading()
                    let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "CustomTabBarController") as! CustomTabBarController
                    self.nav?.pushViewController(vc, animated: false)
                }else{
                    self.pannel.showNotify(withStatus: .failed, belowNavigation: self.nav!,title: json["message"].stringValue)
                    
                }
            }
        }
    }

}

