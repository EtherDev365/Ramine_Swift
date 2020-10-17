//
//  SwipeVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import Koloda

private var numberOfCards: Int = 5

class SwipeVC: UIViewController {

    @IBOutlet var notificationButton: SSBadgeButton!
    @IBOutlet weak var btnLogoView: UIButton!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var imgUserView: UIImageView!
     let user_detais = UserModel.sharedInstance
    @IBOutlet weak var kolodaView: KolodaView!
    fileprivate var dataSource: [UIImage] = {
        var array: [UIImage] = []
        for index in 0..<numberOfCards {
            array.append(UIImage(named: "Card_like_\(index + 1)")!)
        }
        
        return array
    }()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        kolodaView.dataSource = self
        kolodaView.delegate = self
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        
        self.notificationButton.badgeBackgroundColor = UIColor.red
        notificationButton.addTarget(self, action: #selector(self.notificationButtonAction), for: .touchUpInside)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 4)
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
        self.notificationButton.badge = String(pendingNotifications.count)
        
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
    }
    
    @objc func notificationButtonAction() {
        
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "PendingNotificationVC") as! PendingNotificationVC
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func clickProfile(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func clickLogo(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DashboardNewVC") as! DashboardNewVC
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

// MARK: KolodaViewDelegate
extension SwipeVC: KolodaViewDelegate {
    
//    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
//        let position = kolodaView.currentCardIndex
//        for i in 1...4 {
//            dataSource.append(UIImage(named: "Card_like_\(i)")!)
//        }
//        kolodaView.insertCardAtIndexRange(position..<position + 4, animated: true)
//    }
//    
//    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
//        UIApplication.shared.openURL(URL(string: "https://yalantis.com/")!)
//    }
}

// MARK: KolodaViewDataSource
extension SwipeVC: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return dataSource.count
    }
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        return UIImageView(image: dataSource[Int(index)])
    }
    
//    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
//        return Bundle.main.loadNibNamed("OverlayView", owner: self, options: nil)?[0] as? OverlayView
//    }
}
