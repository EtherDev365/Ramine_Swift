//
//  CompanySignupVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import SwiftyJSON
import RappleProgressHUD
import JKNotificationPanel

class CompanySignupVC: UIViewController {
    let pannel = JKNotificationPanel()
    @IBOutlet var txtVerifyPassword: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtPhone: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtUrl: UITextField!
    @IBOutlet var imgCompanyLogo: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
   
    @IBAction func clickUploadLogo(_ sender: Any) {
    }
    
    @IBAction func clickNext(_ sender: Any) {
        self.companySigup()
    }
    @IBAction func clickDiscard(_ sender: Any) {
    }
    
    @IBAction func clickCompanyLogin(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CompanyLoginVC") as! CompanyLoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func companySigup(){
        RappleActivityIndicatorView.startAnimating()
        let parameterDict =  [
            "email": self.txtEmail.text ?? "",
            "url": self.txtUrl.text ?? "",
            "phone_no": self.txtPhone.text ?? "",
            "password": self.txtPassword.text ?? "",
            "password_confirmation": self.txtVerifyPassword.text ?? "",
            ] as [String : Any]
        AuthManager.API_company_signup(information: parameterDict as! [String : String]) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimating()
            if error==nil{
                //print(json)
                if json["status"] == true{
                    let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "CompanyLoginVC") as! CompanyLoginVC
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
