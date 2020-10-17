//
//  LoginVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import SwiftyJSON
import RappleProgressHUD
import JKNotificationPanel
import Firebase
class LoginVC: UIViewController {

    let pannel = JKNotificationPanel()
    let prefs = UserDefaults.standard
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var lblPassword: UITextField!
    @IBOutlet weak var lblUsername: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        
        
        if prefs.object(forKey: "loginKey") as! String? == "1"
        {
            let model = UserModel.sharedInstance
            model.setUserDefaultsValues()
           
                   let vc = MainViewController()
                          let navOne = UINavigationController(rootViewController: vc)
                   navOne.setNavigationBarHidden(true, animated: false)
                   let mainVC = navOne
                   appdelegate.window?.rootViewController = mainVC
        }
        self.btnLogin.layer.cornerRadius = 20
        let border = CALayer()
        let width = CGFloat(2.0)
        var constant = 0
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 2436:
                border.borderColor = UIColor(red:0.90, green:0.00, blue:0.00, alpha:1.0).cgColor
                border.frame = CGRect(x: 0, y: self.lblUsername.frame.size.height - width, width: self.lblUsername.frame.size.width+30, height: self.lblUsername.frame.size.height)
                border.borderWidth = width
                lblUsername.layer.addSublayer(border)
                lblUsername.layer.masksToBounds = true
                let borderP = CALayer()
                let widthp = CGFloat(2.0)
                borderP.borderColor = UIColor(red:0.90, green:0.00, blue:0.00, alpha:1.0).cgColor
                borderP.frame = CGRect(x: 0, y: self.lblPassword.frame.size.height - widthp, width: self.lblPassword.frame.size.width+30, height: self.lblPassword.frame.size.height)
                borderP.borderWidth = widthp
                lblPassword.layer.addSublayer(borderP)
                lblPassword.layer.masksToBounds = true
            case 2688:
                border.borderColor = UIColor(red:0.90, green:0.00, blue:0.00, alpha:1.0).cgColor
                border.frame = CGRect(x: 0, y: self.lblUsername.frame.size.height - width, width: self.lblUsername.frame.size.width+30, height: self.lblUsername.frame.size.height)
                border.borderWidth = width
                lblUsername.layer.addSublayer(border)
                lblUsername.layer.masksToBounds = true
                let borderP = CALayer()
                let widthp = CGFloat(2.0)
                borderP.borderColor = UIColor(red:0.90, green:0.00, blue:0.00, alpha:1.0).cgColor
                borderP.frame = CGRect(x: 0, y: self.lblPassword.frame.size.height - widthp, width: self.lblPassword.frame.size.width+30, height: self.lblPassword.frame.size.height)
                borderP.borderWidth = widthp
                lblPassword.layer.addSublayer(borderP)
                lblPassword.layer.masksToBounds = true
                
            case 1792:
                border.borderColor = UIColor(red:0.90, green:0.00, blue:0.00, alpha:1.0).cgColor
                border.frame = CGRect(x: 0, y: self.lblUsername.frame.size.height - width, width: self.lblUsername.frame.size.width+30, height: self.lblUsername.frame.size.height)
                border.borderWidth = width
                lblUsername.layer.addSublayer(border)
                lblUsername.layer.masksToBounds = true
                let borderP = CALayer()
                let widthp = CGFloat(2.0)
                borderP.borderColor = UIColor(red:0.90, green:0.00, blue:0.00, alpha:1.0).cgColor
                borderP.frame = CGRect(x: 0, y: self.lblPassword.frame.size.height - widthp, width: self.lblPassword.frame.size.width+30, height: self.lblPassword.frame.size.height)
                borderP.borderWidth = widthp
                lblPassword.layer.addSublayer(borderP)
                lblPassword.layer.masksToBounds = true
                
            default:
                border.borderColor = UIColor(red:0.90, green:0.00, blue:0.00, alpha:1.0).cgColor
                border.frame = CGRect(x: 0, y: self.lblUsername.frame.size.height - width, width: self.lblUsername.frame.size.width, height: self.lblUsername.frame.size.height)
                border.borderWidth = width
                lblUsername.layer.addSublayer(border)
                lblUsername.layer.masksToBounds = true
                let borderP = CALayer()
                let widthp = CGFloat(2.0)
                borderP.borderColor = UIColor(red:0.90, green:0.00, blue:0.00, alpha:1.0).cgColor
                borderP.frame = CGRect(x: 0, y: self.lblPassword.frame.size.height - widthp, width: self.lblPassword.frame.size.width, height: self.lblPassword.frame.size.height)
                borderP.borderWidth = widthp
                lblPassword.layer.addSublayer(borderP)
                lblPassword.layer.masksToBounds = true
            }
        }
        
        lblUsername.attributedPlaceholder = NSAttributedString(string: "Brugernavn eller Email",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)])
        lblPassword.attributedPlaceholder = NSAttributedString(string: "Adgangskode",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)])
        
        
        //lblUsername.setBottomBorder()
        //lblPassword.setBottomBorder()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        
        
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
            case UISwipeGestureRecognizer.Direction.down:
                print("Swiped down")
            case UISwipeGestureRecognizer.Direction.left:
               let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
               let vc = storyboard.instantiateViewController(withIdentifier: "NViewController") as! NViewController
               self.navigationController?.pushViewController(vc, animated: true)
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
      //  self.tabBarController?.tabBar.isHidden = true
    //    self.navigationController?.navigationBar.isHidden = false
    }
    
    @IBAction func clickResetPassword(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickLoginBtn(_ sender: Any) {
        
        guard (self.lblUsername.text?.count)! > 0 else {
            self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Please enter the username")
            return
        }
        guard (self.lblPassword.text?.count)! > 0 else {
            self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Please enter the password")
            return
        }
        
       self.callWebserviceForLogin()
    }
    
    
    //function for login webservice
    func callWebserviceForLogin() {
        
        if let instanceIdToken = FIRInstanceID.instanceID().token() {
            ////print("New token \(instanceIdToken)")
            prefs.set(instanceIdToken, forKey: "device_token")
        }
        
        RappleActivityIndicatorView.startAnimating()
        let parameterDict =  [
            "user_name": self.lblUsername.text ?? "",
            "password" : self.lblPassword.text ?? "",
            "device_token": prefs.object(forKey: "device_token") as! String? ?? "",
            ] as [String : Any]
     
        AuthManager.login(information: parameterDict as! [String : String]) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimating()
            if error == nil {
                //print(json)
                if json["status"] == true {
                    
                   let vc = MainViewController()
                           let navOne = UINavigationController(rootViewController: vc)
                    navOne.setNavigationBarHidden(true, animated: false)
                
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.window?.rootViewController = navOne
                    
//                    let Obj_DashboardHomeViewController  = self.storyboard!.instantiateViewController(withIdentifier: "DashboardHomeViewController") as! DashboardHomeViewController
//                    self.navigationController?.pushViewController(Obj_DashboardHomeViewController, animated: true)
                    
                    
                } else {
                    self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: wsResponse.message)
                }
            }else{
                
                self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: wsResponse.message)
            }
        }
    }
}
