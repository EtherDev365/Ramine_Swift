//
//  ChangePasswordVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import RappleProgressHUD
import SwiftyJSON
import JKNotificationPanel

class ChangePasswordVC: UIViewController {
    let pannel = JKNotificationPanel()
    var user_id:String?
    @IBOutlet var txtVerify: UITextField!
    @IBOutlet var txtNewPassword: UITextField!
    @IBOutlet var btnLogin: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnLogin.layer.cornerRadius = 20
        self.txtVerify.setBottomBorder()
        self.txtNewPassword.setBottomBorder()
        self.txtVerify.attributedPlaceholder = NSAttributedString(string: "verify password",
                                                                   attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)])
        self.txtNewPassword.attributedPlaceholder = NSAttributedString(string: "new password",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)])
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        if(self.txtVerify.text == ""){
             self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Please enter password")
        }else if(self.txtNewPassword.text == ""){
            self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Please enter confirm password")
        }else if(self.txtNewPassword.text != self.txtVerify.text){
            self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Confirm password does not match to password")
        }else{
            self.API_resetPassword()
        }
    }
    
    func API_resetPassword(){
        RappleActivityIndicatorView.startAnimating()
        let parameterDict =  [
            "id": self.user_id ?? "",
            "password": self.txtNewPassword.text ?? "",
            "password_confirmation": self.txtVerify.text ?? ""
            ] as [String : Any]
        AuthManager.API_resetPassword(information: parameterDict as! [String : String]) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimating()
            if error==nil{
                
                if json["status"] == true{
                    let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
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
