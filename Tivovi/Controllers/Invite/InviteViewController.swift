//
//  InviteViewController.swift
//  Tivovi
//
//  Created by Suhas Arvind Patil on 24/09/19.
//  Copyright © 2019 DevelopersGroup. All rights reserved.
//

import UIKit
import JKNotificationPanel
import RappleProgressHUD


class InviteViewController: UIViewController {
    
    let appDelegateObj = UIApplication.shared.delegate
    let pannel = JKNotificationPanel()
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtName: UITextField!
    let user_detais = UserModel.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnNext.layer.cornerRadius = 20
        self.txtEmail.setBottomBorder()
        self.txtName.setBottomBorder()
        txtName.attributedPlaceholder = NSAttributedString(string: "fulde navn",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)])
        txtEmail.attributedPlaceholder = NSAttributedString(string: "e-mail",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)])

    }
    
    
    @IBAction func clickNext(_ sender: Any) {
        
        guard self.txtName.text != "" else {
            //self.pannel.showNotify(withStatus: .failed, belowNavigation: appDelegateObj..navigationController!,title: "Please enter full name")
            return
        }
        guard self.txtEmail.text != "" else {
            //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Please enter email id")
            return
        }
        
        self.inviteAPI()
    }
    
    // MARK: API CALLS

    func inviteAPI() {
        RappleActivityIndicatorView.startAnimating()
        let parameterDict =  [
            "email": self.txtEmail.text ?? "",
            "ToName": self.txtName.text ?? "",
            "user_id": user_detais.user_id!
            ] as [String : Any]
        
        AuthManager.inviteUser(information: parameterDict as! [String : String]) { (json, wsResponse, error) in
            
            RappleActivityIndicatorView.stopAnimating()
            if error==nil {
                //print(json)
                if json["status"] == true {
                    self.dismiss(animated: false, completion: {
                        
                    })
                }else {
                   // self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: wsResponse.message)
                    self.dismiss(animated: false, completion: {
                        
                    })
                }
            }else{
                
                //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: wsResponse.message)
            }
        }
    }


}
