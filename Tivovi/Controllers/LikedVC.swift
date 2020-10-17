//
//  LikedVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import RappleProgressHUD
import SwiftyJSON
 
class LikedVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet var notificationButton: SSBadgeButton!
    @IBOutlet var circleView: UIView!
    @IBOutlet var circleView1: UIView!
    @IBOutlet var circleView2: UIView!
    @IBOutlet var tblMain: UITableView!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var imgUserView: UIImageView!
    @IBOutlet var lblAll: UILabel!
    @IBOutlet var lblNew: UILabel!
    @IBOutlet var lblLIke: UILabel!
    var lblAllPrev = ""
    var lblNewPrev = ""
    var lblLIkePrev = ""
    var swipeArr = [SwipeModel]()
    let user_detais = UserModel.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.notificationButton.badgeBackgroundColor = UIColor.red
        notificationButton.addTarget(self, action: #selector(self.notificationButtonAction), for: .touchUpInside)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 4)

        self.getLiked()
        self.lblAll.text = self.lblAllPrev
        self.lblNew.text = self.lblNewPrev
        self.lblLIke.text = self.lblLIkePrev
//        self.circleView.layer.cornerRadius = self.circleView.frame.size.width/2;
//        self.circleView.layer.borderColor = UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0).cgColor
//        self.circleView.layer.borderWidth = 2
//
//        self.circleView1.layer.cornerRadius = self.circleView.frame.size.width/2;
//        self.circleView1.layer.borderColor = UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0).cgColor
//        self.circleView1.layer.borderWidth = 2
//
//        self.circleView2.layer.cornerRadius = self.circleView.frame.size.width/2;
//        self.circleView2.layer.borderColor = UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0).cgColor
//        self.circleView2.layer.borderWidth = 2
//
       
        
        self.lblNew.layer.cornerRadius = self.lblNew.frame.size.width/2;
        self.lblNew.layer.borderColor = UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0).cgColor
        self.lblNew.layer.borderWidth = 2
        
        self.lblLIke.layer.cornerRadius = self.lblLIke.frame.size.width/2;
        self.lblLIke.layer.borderColor = UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0).cgColor
        self.lblLIke.layer.borderWidth = 2
        
        self.lblAll.layer.cornerRadius = self.lblLIke.frame.size.width/2;
        self.lblAll.layer.borderColor = UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0).cgColor
        self.lblAll.layer.borderWidth = 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.lblUsername.text = user_detais.user_name
        if(user_detais.image != nil && user_detais.image != ""){
            self.imgUserView.layer.borderWidth = 1
            self.imgUserView.layer.masksToBounds = false
            self.imgUserView.layer.borderColor = UIColor.clear.cgColor
            self.imgUserView.layer.cornerRadius = self.imgUserView.frame.height/2
            self.imgUserView.clipsToBounds = true
            var myLogoImage = user_detais.image
            self.imgUserView.setImageWithURL(urlString: myLogoImage!, placeholderImageName: "")
        }
        
        self.notificationButton.badge = String(pendingNotifications.count)
    }
    
    @objc func notificationButtonAction() {
        
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "PendingNotificationVC") as! PendingNotificationVC
        self.present(vc, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return self.swipeArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LikedCell") as! LikedCell
        cell.lblCompanyName.text = self.swipeArr[indexPath.row].weburl
        
        var logoImg =  self.swipeArr[indexPath.row].name
        //logoImg =  logoImg!.replacingOccurrences(of: ".dk", with: "")
        let logoImgArr = logoImg?.components(separatedBy: ".")
        logoImg = logoImgArr![0]
        
        if(logoImg != "") {
            
            logoImg = logoImg?.lowercased()
            let escapedString = logoImg!.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
            
            var myLogoImage = escapedString! + ".l.dk.png"
            _ = randomString(length:2)
            
            myLogoImage = NetworkingConstants.baseURL + NetworkingConstants.swipePage.Company_logo + myLogoImage
            cell.imgCompany.setImageWithURL(urlString: myLogoImage, placeholderImage: cell.imgCompany.getPlaceHolderImage(text: self.swipeArr[indexPath.row].name!))
        }else{
            cell.imgCompany.setImageWithURL(urlString: "", placeholderImage: cell.imgCompany.getPlaceHolderImage(text: self.swipeArr[indexPath.row].name!))

        }
        
//        if(swipeArr[indexPath.row].image != nil && swipeArr[indexPath.row].image != "") {
//            cell.imgCompany.layer.borderWidth = 1
//            cell.imgCompany.layer.masksToBounds = false
//            cell.imgCompany.layer.borderColor = UIColor.clear.cgColor
//            cell.imgCompany.layer.cornerRadius = cell.imgCompany.frame.height/2
//            cell.imgCompany.clipsToBounds = true
//            let myLogoImage = NetworkingConstants.baseURL+swipeArr[indexPath.row].image!
//            cell.imgCompany.setImageWithURL(urlString: myLogoImage, placeholderImageName: "")
//        }

        cell.lblLikedNumber.text = self.swipeArr[indexPath.row].likeCount
        return cell
    }
    
    @IBAction func clickProfile(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    func getLiked() {

        self.swipeArr.removeAll()
        RappleActivityIndicatorView.startAnimating()
        let parameterDict =  ["user_id":  self.user_detais.user_id ?? ""]
        DashboardManager.API_getAllMyLikedScreens(information: parameterDict) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            if error==nil{
                for (_, subJson) in json["data"] {
                    let modelList = SwipeModel.init(json: subJson)
                    self.swipeArr.append(modelList)
                }
               self.tblMain.reloadData()
            }
        }
        RappleActivityIndicatorView.stopAnimation()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tabBarController?.selectedIndex = 1
        UserDefaults.standard.set(self.swipeArr[indexPath.row].id, forKey: "dk_id")
        if let vc = self.navigationController{
            vc.popViewController(animated: false);
        }
    }

    @IBAction func clickAllWebShop(_ sender: Any) {
        self.tabBarController?.selectedIndex = 1
        UserDefaults.standard.set("", forKey: "dk_id")
        if let vc = self.navigationController{
            vc.popViewController(animated: false);
        }
    }
}
