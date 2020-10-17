//
//  ForgotPasswordVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import RappleProgressHUD
import SwiftyJSON
import JKNotificationPanel

class ForgotPasswordVC: UIViewController {

    let pannel = JKNotificationPanel()
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var txtEmail: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnNext.layer.cornerRadius = 20
        self.txtEmail.setBottomBorder()
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)])
    }
    

    @IBAction func clickNext(_ sender: Any) {
        if(self.txtEmail.text != ""){
            self.sendCode()
        }else{
            self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Please enter email id")
        }
    }
    
    func sendCode(){
        RappleActivityIndicatorView.startAnimating()
        let parameterDict =  [
            "email": self.txtEmail.text ?? "",
            ] as [String : Any]
        AuthManager.forgotPassword(information: parameterDict as! [String : String]) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimating()
            if error==nil{
                //print(json)
                if json["status"] == true{
                    let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordStepTwoVC") as! ForgotPasswordStepTwoVC
                    vc.email = self.txtEmail.text
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
