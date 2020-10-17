//
//  ProfileVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import RappleProgressHUD
import SwiftyJSON
import JKNotificationPanel
import FBSDKLoginKit
import GoogleSignIn

import AVKit

class ProfileVC: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate  {
    
    @IBOutlet weak var alertTransparentBack: UIView!
    @IBOutlet weak var alertView: UIView!
    
    @IBAction func AlertBackScreen(_ sender: Any) {
        alertTransparentBack.isHidden = true
    }
    
    @IBAction func cancel(_ sender: Any) {
        showAlertMsg(showalert: "no")
                        pr1 = false
                         pr2 = false
                          self.navigationController?.popToRootViewController(animated: true)
                         
                          if r == 1{
                         //r = 0
                         self.navigationController?.popViewController(animated: true)
                         }else{
                              GLOBAL_IMG  = GLOBAL_IMG2
                              pr1 = false
                              pr2 = false
                              self.navigationController?.popToRootViewController(animated: true)
                              }
       
       NotificationMsgShowText = "You didnt save"

    }
    @IBAction func save(_ sender: Any) {
        showAlertMsg(showalert: "no")
self.updateProfile()
        edited = 0
       
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            NotificationMsgShowText = "Saved Sucessfully"

        pr1 = false
        pr2 = false
         self.navigationController?.popToRootViewController(animated: true)
        
         if r == 1{
        //r = 0
        self.navigationController?.popViewController(animated: true)
        }else{
             GLOBAL_IMG  = GLOBAL_IMG2
             pr1 = false
             pr2 = false
             self.navigationController?.popToRootViewController(animated: true)
             }
        }
        }
    
    
    
    @IBOutlet var btnShareApp: UIButton!
    @IBOutlet var circleView: UIView!
    @IBOutlet var versionLabel: UILabel!
    
    //@IBOutlet var imgView: UIImageView!
    @IBOutlet var notificationButton: SSBadgeButton!
    var imagePicked = 0
    var i = 0
    let pannel = JKNotificationPanel()
    @IBOutlet var txtFirst_name: UITextField!
    
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtLast_name: UITextField!
    @IBOutlet var txtPhone: UITextField!
    
    @IBOutlet var btnConfirm: UIButton!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var txtEmail: UITextField!
    
    @IBOutlet var imgProfile: UIButton!
    @IBOutlet var imgProfileView: UIImageView! {
        didSet {
           // imgProfileView.contentMode = .scaleAspectFill
            //imgProfileView.contentMode = .scaleAspectFit

        }
    }

    @IBOutlet var HeaderView: UIView!
    let user_detais = UserModel.sharedInstance
    @IBOutlet var btnLogout: UIButton!
    @IBOutlet weak var btnLogoView: UIButton!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var imgUserView: UIImageView!
    
    @IBOutlet weak var GemBackground: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.versionLabel.text = (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)! + " (" + ((Bundle.main.infoDictionary?["CFBundleVersion"] as? String)!) + ")"
        //self.circleView.layer.cornerRadius = self.circleView.frame.size.width/2;
        //self.circleView.layer.cornerRadius = 35
        //self.circleView.layer.borderColor = UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0).cgColor
       // self.circleView.layer.borderWidth = 2
        self.notificationButton.badgeBackgroundColor = UIColor.red
       // notificationButton.addTarget(self, action: #selector(self.notificationButtonAction), for: .touchUpInside)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 4)
        
        //self.loadXib(SView: HeaderView, value: self.navigationController!)
        
        
       // self.btnConfirm.layer.cornerRadius = 15
        //self.btnLogout.layer.cornerRadius = 15
        //self.btnConfirm.layer.borderWidth = 2
        //self.btnConfirm.layer.borderColor = UIColor(red:0.02, green:0.69, blue:0.15, alpha:1.0).cgColor
       // self.btnLogout.layer.borderWidth = 2
        //self.btnLogout.layer.borderColor = UIColor(red:0.91, green:0.25, blue:0.20, alpha:1.0).cgColor
        self.showProfile()
        
        self.navigationController?.isNavigationBarHidden = true


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.notificationButton.badge = String(pendingNotifications.count)
        self.lblUsername.text = user_detais.first_name
        if(user_detais.image != nil && user_detais.image != "") {
            self.imgUserView.layer.borderWidth = 1
            self.imgUserView.layer.masksToBounds = false
            self.imgUserView.layer.borderColor = UIColor.clear.cgColor
            self.imgUserView.layer.cornerRadius = self.imgUserView.frame.height/2
            self.imgUserView.clipsToBounds = true
            let myLogoImage = user_detais.image
        //self.imgUserView.setImageWithURL(urlString: myLogoImage!, placeholderImageName: "")
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.pannel.dismiss(withFadeDuration: 1)
    }
    
    @objc func notificationButtonAction() {
           
           let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
           let vc  = storyboard.instantiateViewController(withIdentifier: "PendingNotificationVC") as! PendingNotificationVC
           self.present(vc, animated: true, completion: nil)
           //        self.navigationController?.pushViewController(vc, animated: true)
           
       }
    
   
    
    @IBAction func Back_btn(_ sender: Any) {
        txtFirst_name.resignFirstResponder()
        txtLast_name.resignFirstResponder()
        txtPhone.resignFirstResponder()
        txtEmail.resignFirstResponder()

        if(edited == 1){
            showAlertMsg(showalert: "yes")
      // let alert = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .alert)
       //alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
       //    print("save has been clicked")
      //  self.updateProfile()
       
    //   }))
  //     alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { _ in
   //        print("cancel has been clicked")
    //    self.navigationController?.popToRootViewController(animated: true)

    //   }))
            
    //   self.present(alert, animated: true, completion: {
     //   self.navigationController?.popToRootViewController(animated: true)

      // })
        
        }else{
            
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.reveal
            transition.subtype = CATransitionSubtype.fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            tabBarController?.view.layer.add(transition, forKey: kCATransition)

            self.navigationController?.popToRootViewController(animated: false)

            
        }
    }
    
    @IBAction func clickProfile(_ sender: Any) {
        print("back has been clicked")
       // let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        //let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
       // self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.popToRootViewController(animated: true)

    }
    
    func requestCameraPermission() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: {accessGranted in
            guard accessGranted == true else { return }
            self.presentCamera()
        })
    }
    func presentCamera() {
        let photoPicker = UIImagePickerController()
        photoPicker.sourceType = .camera
        photoPicker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        
        self.present(photoPicker, animated: true, completion: nil)
    }
    func alertCameraAccessNeeded() {
        let settingsAppURL = URL(string: UIApplication.openSettingsURLString)!
        
        let alert = UIAlertController(
            title: "Need Camera Access",
            message: "Camera access is required to make full use of this app.",
            preferredStyle: UIAlertController.Style.alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.open(settingsAppURL, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    @IBAction func clickChangeImage(_ sender: Any) {
        
        imagePicked = 0
        let actionSheetControllerIOS8: UIAlertController = UIAlertController(title: "Please select", message: "", preferredStyle: .actionSheet)
        
        let cameraActionButton = UIAlertAction(title: "Camera", style: .default) { _ in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                
                let cameraAuthorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
                
                switch cameraAuthorizationStatus {
                case .notDetermined: self.requestCameraPermission()
                case .authorized: self.presentCamera()
                case .restricted, .denied: self.alertCameraAccessNeeded()
                }
                
                let imagePicker = UIImagePickerController()
                imagePicker.allowsEditing = false
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.camera
                imagePicker.cameraCaptureMode = .photo
                imagePicker.modalPresentationStyle = .fullScreen
                self.present(imagePicker,animated: true,completion: nil)
            }
        }
        actionSheetControllerIOS8.addAction(cameraActionButton)
        
        let libraryActionButton = UIAlertAction(title: "Library", style: .default)
        { _ in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary) {
                
                
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
                
                
                //   }
                
            }
            
        }
        actionSheetControllerIOS8.addAction(libraryActionButton)
        
        let cancelActionButton = UIAlertAction(title: "Cancel",style: .cancel)
        actionSheetControllerIOS8.addAction(cancelActionButton)
        
        self.present(actionSheetControllerIOS8, animated: true, completion: nil)
        
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
// Local variable inserted by Swift 4.2 migrator.
let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        var  chosenImage = UIImage()
        
        chosenImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage ?? info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as! UIImage //2
    
        self.imgProfile.setImage(chosenImage, for: .normal)
        self.imgProfile.roundButton()
        self.imgProfileView.image = chosenImage
       // self.imgProfileView.roundImage()
        
        dismiss(animated:true, completion: nil)
        GemBackground.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        edited = 1
        //self.updateProfile()
    }
    
    
    @IBAction func Gem(_ sender: Any) {
        self.updateProfile()

    }
    
    @IBAction func clickConfirm(_ sender: Any) {
        self.updateProfile()
    }
    
    func showProfile(){
        //RappleActivityIndicatorView.startAnimating()
        
        var parameterDict =  [
            "user_id": user_detais.user_id ?? "",
            ] as [String : Any]
        
        DashboardManager.showProfile(information: parameterDict as! [String : String]) { (json, wsResponse, error) in
           // RappleActivityIndicatorView.stopAnimating()
            
            if error == nil {
                
                if json["status"] == true {
                    

                    self.txtEmail.text = json["data"]["email"].stringValue
                    self.txtPhone.text = json["data"]["phone_no"].stringValue
                    
                    self.txtUsername.text = json["data"]["user_name"].stringValue
                    
                    self.txtFirst_name.text = json["data"]["first_name"].stringValue
                    self.txtLast_name.text = json["data"]["last_name"].stringValue
                    
                    var myLogoImage:String?
                    if (json["data"]["image"].stringValue != "") {
                        
                        myLogoImage = json["data"]["image"].stringValue
                        self.imgProfileView.setImageWithURL(urlString: myLogoImage!, placeholderImageName: "")
                      //  self.imgProfileView.roundImage()

//                        self.imgView.setImageWithURL(urlString: myLogoImage!, placeholderImageName: "")

                    }
                    
                    let model = UserModel.sharedInstance
                    model.setUserInformationNew(json: json)
                    self.lblUsername.text = self.user_detais.first_name

//                    let prefs = UserDefaults.standard
//
//                    var  user_id = json["data"]["id"].stringValue
//                    prefs.set(user_id, forKey: "user_id")
                    
                    if(self.i == 1) {
                    let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                    self.navigationController?.pushViewController(vc, animated: false)
                    }
                }else {
                    self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: wsResponse.message)
                }
            }else{
                
                self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: wsResponse.message)
            }
        }
        
    }
    func updateProfile(){
       RappleActivityIndicatorView.startAnimating()
        var imgData:Data?
        if(imgProfileView.image == nil){
            let image = UIImage(named: "user.png")!
            imgProfileView.image = image
            imgData = imgProfileView.image!.jpegData(compressionQuality: 0.2)!
        }else{
            imgData = imgProfileView.image!.jpegData(compressionQuality: 0.2)!
        }
        var parameterDict =  [
            "user_id": user_detais.user_id ?? "",
            "phone_no": self.txtPhone.text ?? "",
            "first_name":self.txtFirst_name.text ?? "",
            "last_name": self.txtLast_name.text ?? "",
            ] as [String : Any]
        if(self.txtPassword.text != ""){
            parameterDict["password"] = self.txtPassword.text
        }
        DashboardManager.updateProfile(information: parameterDict as! [String : String],profileImg: imgData!) { (json, wsResponse, error) in
           // RappleActivityIndicatorView.stopAnimating()
            if error==nil{
                
                if json["status"] == true{
                    self.i = 1
//                    self.pannel.showNotify(withStatus: .success, belowNavigation: self.navigationController!,title: "Profile updated successfully")
                   // self.showProfile()
                 }else {
  //                  self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: wsResponse.message)
                }
            }else{
                
    //            self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: wsResponse.message)
            }
        }
        GemBackground.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        edited = 0
       // if(imgData == nil){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            RappleActivityIndicatorView.stopAnimating()
        NotificationMsgShowText = "Profilen er opdateret."
self.navigationController?.popToRootViewController(animated: true)
        }
      //  }
    }
    
    @IBAction func clickLogout(_ sender: Any) {
        
        let alert = UIAlertController(title: "Logout?", message: "Do you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            
            let fbLoginManager = FBSDKLoginManager()
            fbLoginManager.logOut()
            let cookies = HTTPCookieStorage.shared
            let facebookCookies = cookies.cookies(for: URL(string: "https://facebook.com/")!)
            for cookie in facebookCookies! {
                cookies.deleteCookie(cookie )
            }
            
            GIDSignIn.sharedInstance().signOut()
            
            // Apple:
            let defaults = UserDefaults.standard
            defaults.set(nil, forKey: "apple_userIdentifieer")

            
            var navigationArray = self.navigationController?.viewControllers //To get all UIViewController stack as Array
            navigationArray!.remove(at: (navigationArray?.count)! - 2) // To remove previous UIViewController
            self.navigationController?.viewControllers = navigationArray!
            
            let prefs = UserDefaults.standard
            let model = UserModel.sharedInstance
            
            prefs.removeObject(forKey: "loginKey")
            prefs.set("0", forKey: "loginKey")
            let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(vc, animated: false)
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                //print("cancel")
            }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func clickLogo(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func clickShareApp(_ sender: Any) {
        
        let text = "Prismatch, garanti etc. et klik og du er sikker"
        let image = UIImage(named: "AppIconLarge")
        let appLink = NSURL(string:"https://apps.apple.com/us/app/tivovi/id1478858134?ls=1")
        let shareAll = [text, image!, appLink!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func onBtnCube(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func onBtnHeart(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
        self.tabBarController?.selectedIndex = 1
    }
    func showAlertMsg(showalert : String)
          
          {     if(showalert == "yes"){
                         
                         let x = (self.alertView.frame.width)/2+(self.alertView.frame.minX)
                         let y = (self.alertTransparentBack.frame.height - self.alertView.frame.height)+(self.alertView.frame.height)*2
                                                       
                          self.alertView.center = CGPoint(x: x, y: y)
                         
                        alertTransparentBack.isHidden = false
                                    self.alertTransparentBack.alpha = 1
                                    UIView.animate(withDuration: 0.5,
                                       delay: 0.1,
                                       options: [.transitionFlipFromRight],
                                       animations: {
                                         
                                        let x = (self.alertView.frame.width)/2+(self.alertView.frame.minX)
                                        let y = (self.alertTransparentBack.frame.height - self.alertView.frame.height)+(self.alertView.frame.height)/2+40
                                        
                                         self.alertView.center = CGPoint(x: x, y: y)
                                        
                                        },
                                                   completion: { finished in
                                                    print("Bug moved right!")
                                        })
                         
                         
                         
                         
                         
                         
                        }else{
                         let x = (self.alertView.frame.width)/2+(self.alertView.frame.minX)
                         let y = (self.alertTransparentBack.frame.height - self.alertView.frame.height)+(self.alertView.frame.height)/2+40
                         
                          self.alertView.center = CGPoint(x: x, y: y)
                            alertTransparentBack.isHidden = true
                         self.alertTransparentBack.alpha = 0
                         UIView.animate(withDuration: 0.5,
                            delay: 0.1,
                            options: [.transitionFlipFromRight],
                            animations: {
                              
                             let x = (self.alertView.frame.width)/2+(self.alertView.frame.minX)
                             let y = (self.alertTransparentBack.frame.height - self.alertView.frame.height)+(self.alertView.frame.height)*2
                                                           
                              self.alertView.center = CGPoint(x: x, y: y)
                             
                             },
                                        completion: { finished in
                                         print("Bug moved right!")
                             })
                        }
          }
}
var edited: Int = 0
extension ProfileVC : UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
       
    }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == txtPassword) {
                                   
                                   if (txtPassword.text?.count ?? 0) > 0 {
                                      // self.updateProfile()
                                       GemBackground.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                                       edited = 1
                                   }
                               }else{
                                  // self.updateProfile()
                                   GemBackground.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                                   edited = 1
                               }
              return  true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if (textField == txtPassword) {
            
            if (txtPassword.text?.count ?? 0) > 0 {
               // self.updateProfile()
                GemBackground.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
                edited = 1
            }
        }else{
           // self.updateProfile()
            GemBackground.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            edited = 1
        }
        
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
