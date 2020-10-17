//
//  FavoriteVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import Koloda
import Nuke
import RappleProgressHUD
import AppImageViewer
import Flurry_iOS_SDK
import JKNotificationPanel

private var numberOfCards: Int = 10
class FavoriteVC: UIViewController {
    
    var web_url = ""
    var like_status = "0"
    var like_id = "0"
    let cardImageViewFull = UIImageView()
    var viewer = AppImageViewer()
    let dummyImageView = UIImageView()
    let pannel = JKNotificationPanel()

    @IBOutlet var notificationButton: SSBadgeButton!
    @IBOutlet var lblLikeTwo: UILabel!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAll: UILabel!
    @IBOutlet var lblNew: UILabel!
    @IBOutlet var lblLIke: UILabel!
    @IBOutlet var circleView: UIView!
    @IBOutlet var circleView1: UIView!
    @IBOutlet var circleView2: UIView!
    @IBOutlet var circleView3: UIView!
    @IBOutlet var lblLike: UILabel!
    @IBOutlet weak var btnLogoView: UIButton!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var imgUserView: UIImageView!
    @IBOutlet weak var kolodaView: KolodaView!

    let user_detais = UserModel.sharedInstance
    
    fileprivate var dataSource: [UIImage] = {
        var array: [UIImage] = []
        for index in 0..<numberOfCards {
            array.append(UIImage(named: "Card_like_\(index + 1)")!)
        }
        return array
    }()
    var swipeArr = [SwipeModel]()
    var loader_status = 0
    
override func viewDidLoad() {
    
    super.viewDidLoad()

    self.notificationButton.badgeBackgroundColor = UIColor.red
    notificationButton.addTarget(self, action: #selector(self.notificationButtonAction), for: .touchUpInside)
    notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 4)
   
    self.circleView3.layer.cornerRadius = self.circleView.frame.size.width/2;
    self.circleView3.layer.borderColor = UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0).cgColor
    self.circleView3.layer.borderWidth = 2
    

    kolodaView.dataSource = self
    kolodaView.delegate = self
//    self.kolodaView.layer.borderWidth = 1
//    self.kolodaView.layer.borderColor = UIColor.lightGray.cgColor
    self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
}
    
 
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)

        self.lblUsername.text = user_detais.first_name
        if(user_detais.image != nil && user_detais.image != "") {
            
            self.imgUserView.layer.borderWidth = 1
            self.imgUserView.layer.masksToBounds = false
            self.imgUserView.layer.borderColor = UIColor.clear.cgColor
            self.imgUserView.layer.cornerRadius = self.imgUserView.frame.height/2
            self.imgUserView.clipsToBounds = true
            let myLogoImage = user_detais.image
            self.imgUserView.setImageWithURL(urlString: myLogoImage!, placeholderImageName: "")
        }
        
        
        let id = UserDefaults.standard.string(forKey: "dk_id")
        if(id != ""){
            self.swipeArr.removeAll()
            self.kolodaView.reloadData()
        }
        
        loader_status = 0
        self.getAllCards()
        
        self.notificationButton.badge = String(pendingNotifications.count)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.notificationReceived),
            name: NSNotification.Name(rawValue: NOTIFICATIONS.USER_NOTIFICATION_BADGE),
            object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATIONS.USER_NOTIFICATION_BADGE), object: nil)
    }
    
    
    @objc func notificationReceived() {
        self.getAllCards()
    }
    

    @objc func notificationButtonAction() {
        
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "PendingNotificationVC") as! PendingNotificationVC
//        vc.pendingModel = self.pendingPackage
//        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        //        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickProfile(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func clickLogo(_ sender: Any) {
//        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardNewVC") as! DashboardNewVC
//        self.navigationController?.pushViewController(vc, animated: false)
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
       // self.like_status = "0"
       // let id = ((kolodaView!.currentCardIndex)-1)
      //  self.like_id = self.swipeArr[id].id!
     //   self.likeUnlike()
        //print(kolodaView?.currentCardIndex)
    }
    
    @IBAction func rightButtonTapped() {
       // self.like_status = "1"
          //  let id = ((kolodaView!.currentCardIndex)-1)
          //  self.like_id = self.swipeArr[id].id!
       //     self.likeUnlike()
        kolodaView?.swipe(.right)
    }
    
    @IBAction func undoButtonTapped() {
        let id = ((kolodaView!.currentCardIndex)-1)
        if(id >= 0){
        self.like_id = self.swipeArr[id].id!
        self.lblLikeTwo.text = self.swipeArr[id].likeCount!
        self.lblName.text = self.swipeArr[id].weburl!
        self.undoCard()
        }
        kolodaView?.revertAction()
    }
    
    @IBAction func clickLiked(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LikedVC") as! LikedVC
        vc.lblAllPrev  = self.lblAll.text ?? ""
        vc.lblNewPrev  = self.lblNew.text ?? ""
        vc.lblLIkePrev = self.lblLIke.text ?? ""
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func getAllCards() {
        
        if(loader_status == 0) {
          self.swipeArr.removeAll()
          RappleActivityIndicatorView.startAnimating()
        }
        
        var parameterDict =  [
            "user_id":  self.user_detais.user_id ?? ""]
        let id = UserDefaults.standard.string(forKey: "dk_id")
        if(id != ""){
            parameterDict["dkscreen_id"] = id
        }
        
        DashboardManager.API_getRandomScreens(information: parameterDict ) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            
            if error == nil {
                for (_, subJson) in json["data"] {
                    
                    let modelList = SwipeModel.init(json: subJson)
                    self.swipeArr.append(modelList)
                    
                    if let url = URL(string: NetworkingConstants.baseURL+modelList.image!) {
                        self.dummyImageView.setImageWithURL(urlString: NetworkingConstants.baseURL+modelList.image!, placeholderImageName: "webshop_please_wait")
                    }
                }
                
                self.lblNew.layer.cornerRadius = self.lblNew.frame.size.width/2;
                self.lblNew.layer.borderColor = UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0).cgColor
                self.lblNew.layer.borderWidth = 2
                
                self.lblLIke.layer.cornerRadius = self.lblLIke.frame.size.width/2;
                self.lblLIke.layer.borderColor = UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0).cgColor
                self.lblLIke.layer.borderWidth = 2
                
                self.lblAll.layer.cornerRadius = self.lblLIke.frame.size.width/2;
                self.lblAll.layer.borderColor = UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0).cgColor
                self.lblAll.layer.borderWidth = 2
                
                self.lblAll.text = json["allCount"].stringValue
                self.lblNew.text = json["newCount"].stringValue
                
                if(self.swipeArr.count > 0) {
                    self.lblName.text = self.swipeArr[0].weburl
                    self.lblLikeTwo.text = self.swipeArr[0].likeCount
                    self.web_url = self.swipeArr[0].weburl!
                   
                }
                
                self.lblLIke.text = json["myLikesCount"].stringValue
                self.kolodaView.resetCurrentCardIndex()
                UserDefaults.standard.set("", forKey: "dk_id")
            }
        }
    }
    
    func likeUnlike(){
       // self.swipeArr.removeAll()
//        RappleActivityIndicatorView.startAnimating()
        self.kolodaView.isUserInteractionEnabled = false
        let parameterDict =  [ 
            "user_id":  self.user_detais.user_id ?? "",
            "dkscreen_id" : self.like_id,
            "liked_unliked": self.like_status
            ] as [String : Any]
        
        DashboardManager.API_screensLikeUnlike(information: parameterDict as! [String : String]) { (json, wsResponse, error) in
            
//            RappleActivityIndicatorView.stopAnimation()
            self.kolodaView.isUserInteractionEnabled = true
            
            if error==nil{
                //print(json)
                //self.lblNew.text = json["newCount"].stringValue
            }
        }
    }
    
    func undoCard() {
        // self.swipeArr.removeAll()
        //   RappleActivityIndicatorView.startAnimating()
        let parameterDict =  [
            "user_id":  self.user_detais.user_id ?? "",
            "dkscreen_id" : self.like_id,
            
            ] as [String : Any]
        DashboardManager.API_screensUndo(information: parameterDict as! [String : String]) { (json, wsResponse, error) in
            
            if error==nil{
                //print(json)
                
                if(json["like_status"].boolValue == true){
                    let newLike = self.lblLike.text
                    if newLike!.contains("K") {
                        
                    }else{
                        let newL = Int(newLike!)!-1
                        if(newL >= 0){
                            self.lblLike.text = String(newL)
                        }
                    }
                    
                    
                }
            }
        }
    }
    
    @IBAction func clickOpenWebsite(_ sender: Any) {
        
        let string = self.web_url
        if (string.contains("http://") || string.contains("https://")) {
           // self.web_url = self.web_url
        }else{
            self.web_url = "http://"+self.web_url
        }
        if let url = URL(string: self.web_url) {
            UIApplication.shared.open(url)
        }
        
        // Capture the author info & user status
        let articleParams = ["URL": self.web_url];
        Flurry.logEvent("Swipe_Page_URL", withParameters: articleParams);
    }
    
  
   
}


// MARK: KolodaViewDataSource

extension FavoriteVC: KolodaViewDataSource {
    
   
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return self.swipeArr.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .moderate
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
       
        let imageView : UIImageView! = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "webshop_placeholder")

        guard self.swipeArr[index].image != nil else {
            return imageView
        }
        
        if let url = URL(string: NetworkingConstants.baseURL+self.swipeArr[index].image!) {
            imageView.setImageWithURL(urlString: NetworkingConstants.baseURL+self.swipeArr[index].image!, placeholderImageName: "webshop_please_wait")
        }
        
        return imageView
    }
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        
        let lastIndex = self.swipeArr.count-25
        if(index == lastIndex) {
            loader_status = 1
            self.getAllCards()
        }
        
        self.like_id = self.swipeArr[index].id!
        if(direction.rawValue == "left"){
            
            Flurry.logEvent("Dislike_Swipe");
            
            self.like_status = "0"
            self.likeUnlike()
            
        }else if(direction.rawValue == "right"){
            
            Flurry.logEvent("Like_Swipe");
            
            self.like_status = "1"
            self.likeUnlike()
            let newLike = self.lblLike.text
            if newLike!.contains("K") {
                
            }else{
                let newL = Int(newLike!)!+1
                self.lblLike.text = String(newL)
            }
           
        }
        
        let id = index+1
        if(self.swipeArr.count > id){
        self.lblName.text = self.swipeArr[id].weburl
            self.web_url = self.swipeArr[id].weburl!
            if(self.swipeArr[id].likeCount != nil){
                self.lblLikeTwo.text = self.swipeArr[id].likeCount
            }else{
                self.lblLikeTwo.text = "0"
            }
            
        }
        
        
        // load iamge in advance
        if let url = URL(string: NetworkingConstants.baseURL+self.swipeArr[index+1].image!) {
            self.dummyImageView.setImageWithURL(urlString: NetworkingConstants.baseURL+self.swipeArr[index].image!, placeholderImageName: "webshop_please_wait")
        }
        if let url = URL(string: NetworkingConstants.baseURL+self.swipeArr[index+2].image!) {
            self.dummyImageView.setImageWithURL(urlString: NetworkingConstants.baseURL+self.swipeArr[index].image!, placeholderImageName: "webshop_please_wait")
        }
        if let url = URL(string: NetworkingConstants.baseURL+self.swipeArr[index+3].image!) {
            self.dummyImageView.setImageWithURL(urlString: NetworkingConstants.baseURL+self.swipeArr[index].image!, placeholderImageName: "webshop_please_wait")
        }
        if let url = URL(string: NetworkingConstants.baseURL+self.swipeArr[index+4].image!) {
            self.dummyImageView.setImageWithURL(urlString: NetworkingConstants.baseURL+self.swipeArr[index].image!, placeholderImageName: "webshop_please_wait")
        }
        
    }
    
    //    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
    //        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
    //        //return
    //    }
}


// MARK: - Unrelated to cards logic code

extension FavoriteVC: KolodaViewDelegate {
    
    //    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
    //        let position = kolodaView.currentCardIndex
    //        for i in 1...4 {
    //            dataSource.append(UIImage(named: "Card_like_\(i)")!)
    //        }
    //     //   kolodaView.insertCardAtIndexRange(position..<position + 4, animated: true)
    //    }
    
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        
        
        let dataStrArr = (self.swipeArr[index].image!).components(separatedBy: "/")
        var dataStr = dataStrArr[dataStrArr.count-1]
        dataStr = dataStr.replacingOccurrences(of: ".t.", with: ".d.")
        let imageUrl:URL = URL(string: NetworkingConstants.baseURL+NetworkingConstants.swipePage.API_max_image+dataStr)!

        RappleActivityIndicatorView.startAnimating()
        
        let request = NukeMethods.makeRequest(url: imageUrl, view: self.cardImageViewFull)
        
        Nuke.loadImage(with: request, options: .shared, into: self.cardImageViewFull, progress: nil) { (response, error) in
            
            RappleActivityIndicatorView.stopAnimation()
            
            guard let image = response?.image else {
                self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: error?.localizedDescription)
                return
                
            }
            NukeMethods.setImage(image, to: self.cardImageViewFull)
            
            let appImage = ViewerImage.appImage(forImage: image)
            self.viewer = AppImageViewer(originImage: image, photos: [appImage], animatedFromView: self.view)
            self.viewer.delegate = self as AppImageViewerDelegate
            self.viewer.isCustomShare = true
            self.present(self.viewer, animated: true, completion: nil)

        }
    }
    
    @IBAction func onBtnCube(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    @IBAction func onBtnHeart(_ sender: Any) {
        
    }
}

extension FavoriteVC : AppImageViewerDelegate {
    
    func didTapShareButton(atIndex index: Int, _ browser: AppImageViewer) {
        
        let text = "Check this web shop i found in tivovi app."
        let image = UIImage(named: "app-logo")
        let string = self.web_url
        if (string.contains("http://") || string.contains("https://")) {
        }else{
            self.web_url = "http://"+self.web_url
        }
        let appLink = NSURL(string:self.web_url)
        let shareAll = [text, image!, appLink!] as [Any]
        let activityViewController = UIActivityViewController(activityItems: shareAll, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.viewer.present(activityViewController, animated: true, completion: nil)
    }
}



