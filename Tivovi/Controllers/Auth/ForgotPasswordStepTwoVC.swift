//
//  ForgotPasswordStepTwoVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import RappleProgressHUD
import SwiftyJSON
import JKNotificationPanel

class ForgotPasswordStepTwoVC: UIViewController {
    let pannel = JKNotificationPanel()
    var email:String?
    @IBOutlet var btnReset: UIButton!
    @IBOutlet var txtPincode: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnReset.layer.cornerRadius = 20
        self.txtPincode.setBottomBorder()
        self.txtPincode.attributedPlaceholder = NSAttributedString(string: "****",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)])
       
    }
    
    @IBAction func clickReset(_ sender: Any) {
        if(self.txtPincode.text == ""){
           self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Please enter pincode")
        }else{
            self.sendCode()
        }
    }
    
    
    func sendCode() {
        
        RappleActivityIndicatorView.startAnimating()
        let parameterDict =  [
            "token": self.txtPincode.text ?? "",
            "email": self.email ?? "",
            ] as [String : Any]
        AuthManager.API_resetAction(information: parameterDict as! [String : String]) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimating()
            if error==nil{
                
                if json["status"] == true{
                    let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ChangePasswordVC") as! ChangePasswordVC
                    vc.user_id = json["data"][0]["id"].stringValue
                    self.navigationController?.pushViewController(vc, animated: true)
                }else {
                    self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: wsResponse.message)
                }
            }else{
                
                self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: wsResponse.message)
            }
        }
    }
}
