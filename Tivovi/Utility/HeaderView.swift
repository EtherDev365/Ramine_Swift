//
//  HeaderView.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
 

class HeaderView: UIView {
    
    @IBOutlet weak var btnLogoView: UIButton!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var imgUserView: UIImageView!
    var navCon: UINavigationController?
    @IBOutlet var btnLeft: UIButton!
    @IBOutlet var btnPlus: UIButton!
    @IBOutlet var btnSearch: UIButton!
    let user_details = UserModel.sharedInstance
    func instantXib(frame:CGRect,value:UINavigationController)->HeaderView
    {
        let xibView = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)!.first as! HeaderView
        xibView.frame = frame
        xibView.navCon = value
        xibView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        xibView.lblUsername.text = user_details.first_name
        if(user_details.image != nil && user_details.image != ""){
            xibView.imgUserView.layer.borderWidth = 1
            xibView.imgUserView.layer.masksToBounds = false
            xibView.imgUserView.layer.borderColor = UIColor.clear.cgColor
            xibView.imgUserView.layer.cornerRadius = xibView.imgUserView.frame.height/2
            xibView.imgUserView.clipsToBounds = true
            
            let myLogoImage = user_details.image
            xibView.imgUserView.setImageWithURL(urlString: myLogoImage!, placeholderImageName: "")
        }
        
        return xibView
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    @IBAction func clickProfile(_ sender: Any) {
        let alert = UIAlertController(title: "Please Select an Option", message: "", preferredStyle: .actionSheet)
        
        
        alert.addAction(UIAlertAction(title: "Profile", style: .default , handler:{ (UIAlertAction)in
            let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
            self.navCon?.pushViewController(vc, animated: true)
        }))
        
       
        
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive , handler:{ (UIAlertAction)in
            //print("User click Delete button")
            let prefs = UserDefaults.standard
            let model = UserModel.sharedInstance
            prefs.set("0", forKey: "loginKey")
            let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navCon?.pushViewController(vc, animated: true)
            //self.navCon?.interactivePopGestureRecognizer?.isEnabled = true
        }))
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in
            NSLog("Cancel Pressed")
        }
        
        alert.addAction(cancelAction)
        self.navCon!.present(alert, animated: true,completion: {
           
        })
        
        
    }
    
    @IBAction func clickLogo(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CustomTabBarController") as! CustomTabBarController
        self.navCon?.pushViewController(vc, animated: true)
    }
    

}
