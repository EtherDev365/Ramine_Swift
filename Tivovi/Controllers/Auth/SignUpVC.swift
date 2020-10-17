//
//  SignUpVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import RappleProgressHUD
import SwiftyJSON
import JKNotificationPanel
import Firebase

class SignUpVC: UIViewController {

    let prefs = UserDefaults.standard
    var terms = "0"
    let pannel = JKNotificationPanel()
    @IBOutlet weak var firstStack: UIStackView!
    @IBOutlet weak var secondStack: UIStackView!
    @IBOutlet weak var stackTopHeight: NSLayoutConstraint!
    @IBOutlet weak var lblTerms: UIButton!
    @IBOutlet weak var lblPrivacy: UIButton!
    @IBOutlet weak var btnSignup: UIButton!
    
    @IBOutlet var lblAnd: UILabel!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    
    @IBOutlet weak var txtEmail: UITextField!
    
    @IBOutlet weak var txtPhone: UITextField!
    
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnCheckBox: UIButton!
    @IBOutlet weak var txtVerifyPassword: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.btnSignup.layer.cornerRadius = 20
        self.btnContinue.layer.cornerRadius = 20
        self.btnCheckBox.setImage(UIImage(named:"uncheck"), for: .normal)
        self.txtFirstName.setBottomBorder()
        self.txtUsername.setBottomBorder()
        self.txtLastName.setBottomBorder()
        self.txtEmail.setBottomBorder()
        self.txtPassword.setBottomBorder()
        self.txtPhone.setBottomBorder()
        self.txtVerifyPassword.setBottomBorder()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.view.addGestureRecognizer(swipeLeft)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = UISwipeGestureRecognizer.Direction.down
        self.view.addGestureRecognizer(swipeDown)
        
        
        
        txtFirstName.attributedPlaceholder = NSAttributedString(string: "Fornavn",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)])
        txtLastName.attributedPlaceholder = NSAttributedString(string: "Efternavn",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)])
        txtUsername.attributedPlaceholder = NSAttributedString(string: "Brugernavn",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)])
        txtEmail.attributedPlaceholder = NSAttributedString(string: "Email",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)])
        txtPhone.attributedPlaceholder = NSAttributedString(string: "Mobil",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)])
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Adgangskode",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)])
        txtVerifyPassword.attributedPlaceholder = NSAttributedString(string: "Gentag adgangskode",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)])
        
        
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
                let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                self.navigationController?.pushViewController(vc, animated: true)
            case UISwipeGestureRecognizer.Direction.up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
       // self.navigationController?.navigationBar.isHidden = false
    }
    @IBAction func clickContinue(_ sender: Any) {
        
        guard (self.txtFirstName.text?.count)! > 0 else {
            self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Please enter the firstname")
            return
        }
        guard (self.txtLastName.text?.count)! > 0 else {
            self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Please enter the lastname")
            return
        }
        guard (self.txtUsername.text?.count)! > 0 else {
            self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Please enter the username")
            return
        }
        
        self.btnContinue.isHidden = true
        self.txtFirstName.isHidden = true
        self.txtLastName.isHidden = true
        self.txtUsername.isHidden = true
        
        self.btnCheckBox.isHidden = false
        self.txtEmail.isHidden = false
        self.txtPhone.isHidden = false
        self.txtPassword.isHidden = false
        self.txtVerifyPassword.isHidden = false
        self.btnSignup.isHidden = false
        self.lblTerms.isHidden = false
        self.lblPrivacy.isHidden = false
        self.lblAnd.isHidden = false
    }
    
    @IBAction func clickSignup(_ sender: Any) {
        
        guard (self.txtEmail.text?.count)! > 0 else {
            self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Please enter the email")
            return
        }
        guard (self.txtPhone.text?.count)! > 0 else {
            self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Please enter the phone")
            return
        }
        guard (self.txtPassword.text?.count)! > 0 else {
            self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Please enter the password")
            return
        }
        guard (self.txtVerifyPassword.text?.count)! > 0 else {
            self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Please enter the confirm password")
            return
        }
        
        if(self.terms == "1"){
            self.callWebserviceForSignup()
        }else{
            self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Please accept terms & condition")
        }
        
    }
    @IBAction func clickCheckbox(_ sender: Any) {
        let isSelected = !self.btnCheckBox.isSelected
        self.btnCheckBox.isSelected = isSelected
        if isSelected {
            self.btnCheckBox.setImage(UIImage(named:"checked"), for: .selected)
            self.terms = "1"
        }else{
            self.btnCheckBox.setImage(UIImage(named:"uncheck"), for: .normal)
            self.terms = "0"
        }
    }
    @IBAction func clickLogin(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func clickCompanySignup(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CompanySignupVC") as! CompanySignupVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    //function for login webservice
    func callWebserviceForSignup()
    {
        
        if let instanceIdToken = FIRInstanceID.instanceID().token() {
            ////print("New token \(instanceIdToken)")
            prefs.set(instanceIdToken, forKey: "device_token")
        }
        
        RappleActivityIndicatorView.startAnimating()
        let parameterDict =  [
            "user_name": self.txtUsername.text ?? "",
            "first_name": self.txtFirstName.text ?? "",
            "last_name" : self.txtLastName.text ?? "",
            "email" : self.txtEmail.text ?? "",
            "password" : self.txtPassword.text ?? "",
            "password_confirmation": self.txtVerifyPassword.text ?? "",
            "phone_no": self.txtPhone.text ?? "",
            "terms": self.terms ,
            "device_token": prefs.object(forKey: "device_token") as! String? ?? "",
            ] as [String : Any]
        AuthManager.signUp(information: parameterDict as! [String : String]) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimating()
            if error==nil{
                //print(json)
                
                if json["status"] == true {
                    
//                    let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
//                    let vc = storyboard.instantiateViewController(withIdentifier: "CustomTabBarController") as! CustomTabBarController
//                    self.navigationController?.pushViewController(vc, animated: true)
                    
                
                           let vc = MainViewController()
                                  let navOne = UINavigationController(rootViewController: vc)
                           navOne.setNavigationBarHidden(true, animated: false)
                           let mainVC = navOne
                           appdelegate.window?.rootViewController = mainVC
                }else {
                    
                    self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: wsResponse.message)
                }
            }else{
                
                self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: wsResponse.message)
            }
        }
        
    }
    
    @IBAction func clickTermsAndCondition(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TermsAndConditionVC") as! TermsAndConditionVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickPrivacyPolicy(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
