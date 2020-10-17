//
//  CompanyLoginVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import RappleProgressHUD
import JKNotificationPanel
import SwiftyJSON

class CompanyLoginVC: UIViewController {
    let pannel = JKNotificationPanel()
    @IBOutlet var btnTerms: UIButton!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtEmail: UITextField!
    var terms = "0"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func clickSendNewPincode(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickLogin(_ sender: Any) {
        self.API_company_login()
    }
    
    @IBAction func clickTerms(_ sender: Any) {
        let isSelected = !self.btnTerms.isSelected
        self.btnTerms.isSelected = isSelected
        if isSelected {
            self.btnTerms.setImage(UIImage(named:"checked"), for: .selected)
            self.terms = "1"
        }else{
            self.btnTerms.setImage(UIImage(named:"uncheck"), for: .normal)
            self.terms = ""
        }
    }
    func API_company_login(){
        RappleActivityIndicatorView.startAnimating()
        let parameterDict =  [
            "email": self.txtEmail.text ?? "",
            "password": self.txtPassword.text ?? "",
            "terms": self.terms ?? "",
            ] as [String : Any]
        AuthManager.API_company_login(information: parameterDict as! [String : String]) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimating()
            if error==nil{
                //print(json)
                if json["status"] == true{
                     self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Login Succesfully")
                }else {
                    self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: wsResponse.message)
                }
            }else{
                
                self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: wsResponse.message)
            }
        }
    }
}
