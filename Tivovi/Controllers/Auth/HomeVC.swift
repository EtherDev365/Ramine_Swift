//
//  HomeVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import SwiftyJSON
import RappleProgressHUD
import JKNotificationPanel
import AuthenticationServices

class HomeVC: UIViewController,UIGestureRecognizerDelegate,ASAuthorizationControllerDelegate {
    
    var fb_status = 0
    let pannel = JKNotificationPanel()
    @IBOutlet weak var btnSignup: UIButton!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnFBLogin: UIButton!

    @IBOutlet weak var thirdpartyLoginStackView: UIStackView!
            
    let prefs = UserDefaults.standard
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.btnLogin.layer.cornerRadius = 20
        self.btnSignup.layer.cornerRadius = 20
        self.tabBarController?.tabBar.isHidden = true
        
        self.btnFBLogin.layer.cornerRadius = 15
        self.setUpSignInAppleButton()
        
    }
    
    func setUpSignInAppleButton() {
        if #available(iOS 13.0, *) {
            let authorizationButton = ASAuthorizationAppleIDButton()
            authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
                 //authorizationButton.cornerRadius = 15
            
                 //Add button on some view or stack
            self.thirdpartyLoginStackView.addArrangedSubview(authorizationButton)
        } else {
            // Fallback on earlier versions
        }
     
    }
    
    @IBAction func clickLoginBtn(_ sender: Any) {
    }
    
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        switch UIDevice.current.orientation{
        case .portrait:
            self.btnLogin.layer.cornerRadius = 20
            self.btnSignup.layer.cornerRadius = 20
        case .portraitUpsideDown:
            self.btnLogin.layer.cornerRadius = 20
            self.btnSignup.layer.cornerRadius = 20
        case .landscapeLeft:
            self.btnLogin.layer.cornerRadius = 15
            self.btnSignup.layer.cornerRadius = 15
        case .landscapeRight:
            self.btnLogin.layer.cornerRadius = 15
            self.btnSignup.layer.cornerRadius = 15
        default:
            self.btnLogin.layer.cornerRadius = 20
            self.btnSignup.layer.cornerRadius = 20
        }
     
    }
    override func viewWillDisappear(_ animated: Bool) {
    //    self.navigationController?.setNavigationBarHidden(false, animated: animated)
    //    self.navigationController?.navigationBar.isHidden = false
        super.viewWillDisappear(true)
        // Hide the Navigation Bar
        if(fb_status == 0){
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false

       self.navigationController?.navigationBar.isHidden = true
        super.viewWillAppear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        if prefs.object(forKey: "loginKey") as! String? == "1"
//        {
//            let model = UserModel.sharedInstance
//            model.setUserDefaultsValues()
//            
//            let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
//            let vc = storyboard.instantiateViewController(withIdentifier: "CustomTabBarController") as! CustomTabBarController
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        self.fb_status = 0
        
    }
    @IBAction func clickLogin(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickSIgnup(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func clickFbLogin(_ sender: Any) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if fbloginresult.grantedPermissions != nil {
                    if(fbloginresult.grantedPermissions.contains("email"))
                    {
                        self.getFBUserData()
                        fbLoginManager.logOut()
                    }
                }
            }
        }
    }
    

    func getFBUserData() {
        
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    
                    let json1 = JSON(result)
                    RappleActivityIndicatorView.startAnimating()
                    let prefs = UserDefaults.standard
                    let parameterDict_facebook =
                        [
                            "first_name":json1["first_name"].stringValue,
                            "last_name": json1["last_name"].stringValue,
                            "email":json1["email"].stringValue,
                            "social_type":"facebook",
                            "social_id":json1["id"].stringValue,
                            "image": json1["picture"]["data"]["url"].stringValue ?? "",
                            "device_token": prefs.object(forKey: "device_token") as! String? ?? "",
                        ]
                    AuthManager.social_login(information: parameterDict_facebook ) { (json, wsResponse, error) in
                        RappleActivityIndicatorView.stopAnimating()
                        if error==nil {
                            //print(json)
                            if json["status"] == true{
                               // self.navigationController?.navigationBar.isHidden = false
                               self.submitFBLogin()
                            }else {
                                self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: wsResponse.message)
                            }
                        }else{
                            
                            self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: wsResponse.message)
                        }
                    }
                }
            })
        }
    }
        
    @IBAction func clickTwitterLogin(_ sender: Any) {
    }
    
    func submitFBLogin() {
        self.fb_status = 1
        
        let vc = MainViewController()
               let navOne = UINavigationController(rootViewController: vc)
        navOne.setNavigationBarHidden(true, animated: false)
        let mainVC = navOne
        appdelegate.window?.rootViewController = mainVC
    }
    
    
    // MARK: GOOGLE LOGIN
    @IBAction func clickGoogleLogin(_ sender: Any) {
    
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            GIDSignIn.sharedInstance().signInSilently()
        } else {
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    @IBAction func clickTerms(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "TermsAndConditionVC") as! TermsAndConditionVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickPrivacy(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PrivacyPolicyVC") as! PrivacyPolicyVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    // MARK: Apple LOGIN

    @IBAction func handleAppleIdRequest(_ sender: Any) {
    
        if #available(iOS 13.0, *) {
            
            if let userIdentifier = UserDefaults.standard.object(forKey: "apple_userIdentifieer") as? String {
                   let authorizationProvider = ASAuthorizationAppleIDProvider()
                   authorizationProvider.getCredentialState(forUserID: userIdentifier) { (state, error) in
                       switch (state) {
                       case .authorized:
                           //print("Account Found - Signed In")
                           //clear the session
                           self.callAppleLoginAPI()
                           break
                       case .revoked:
                           //print("No Account Found")
                           break
                       case .notFound:
                            //print("No Account Found")
                            let appleIDProvider = ASAuthorizationAppleIDProvider()
                                       let request = appleIDProvider.createRequest()
                                                     request.requestedScopes = [.fullName, .email]
                                                     let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                                                     authorizationController.delegate = self
                                                     authorizationController.performRequests()
                            break
                       default:
                           break
                       }
                   }
            } else {
                
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
                              request.requestedScopes = [.fullName, .email]
                              let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                              authorizationController.delegate = self
                              authorizationController.performRequests()
            }
            
            
            
           
        } else {
            // Fallback on earlier versions
        }
              
    }
    

    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
    let userIdentifier = appleIDCredential.user
    let fullName = appleIDCredential.fullName
    let email = appleIDCredential.email

        let defaults = UserDefaults.standard
        defaults.set(userIdentifier, forKey: "apple_userIdentifieer")
        defaults.set((fullName?.givenName ?? ""), forKey: "apple_firstname")
        defaults.set((fullName?.familyName ?? ""), forKey: "apple_lastname")
        defaults.set((email ?? "\(userIdentifier)@appleid.com"), forKey: "apple_email")

        self.callAppleLoginAPI()
        }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
        self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: error.localizedDescription)
    }
    
    func callAppleLoginAPI() {

        RappleActivityIndicatorView.startAnimating()
        let prefs = UserDefaults.standard
        let parameterDict_apple =
            [
                "first_name":UserDefaults.standard.object(forKey: "apple_firstname") as! String,
                "last_name":UserDefaults.standard.object(forKey: "apple_lastname") as! String,
                "email":UserDefaults.standard.object(forKey: "apple_email") as! String,
                "social_type":"apple",
                "social_id":UserDefaults.standard.object(forKey: "apple_userIdentifieer") as! String,
                "image": "",
                "device_token": prefs.object(forKey: "device_token") as! String? ?? "",
            ]
        
        AuthManager.social_login(information: parameterDict_apple ) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimating()
            if error == nil {
                //print(json)
                if json["status"] == true {
                   // self.navigationController?.navigationBar.isHidden = false
                   self.submitFBLogin()
                }else {
                    self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: wsResponse.message)
                }
            }else {
                
                self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: wsResponse.message)
            }
        }
    }
    
}

//MARK: Google SignIn Delegates

extension HomeVC: GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            
        } else {
            
            // PUT YOUR METHOD AFTER SIGNED-IN HERE
        }
    }
}
