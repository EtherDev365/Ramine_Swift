//
//  ViewController.swift
//  TruckTrace
//
//  Created by Admin on 1/18/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import RappleProgressHUD
import SwiftyJSON
//import JKNotificationPanel
import Nuke
import BubbleTransition
import Lightbox
import DatePickerDialog
import IQKeyboardManagerSwift
var pr1 = true
var btnNotificationS : SSBadgeButton? = nil
var NotificationMsgShowText: String = ""
var arrowStatus = 0
var MAX_PACKAGE_PER_LOAD = 21
var MenuViewG:UIView? = nil
var LeftLineG:UIView? = nil
var RightLineG:UIView? = nil
var btnPlusG:UIButton? = nil
var BtnCubeG:UIButton? = nil
var BtnHeartG:UIButton? = nil
var btntype = "dashboard"
var showmenu = true
var isFromDetail = false

var shouldRefreshDashboardData = false
class DashboardFirstCollectionViewCell :UICollectionViewCell
{
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var view_backGroundShopName: UIView!
    
    @IBOutlet weak var img_first: UIImageView!
}

class DashboardmiddleCollectionViewCell :UICollectionViewCell
{
    @IBOutlet weak var img_middle: UIImageView!
}

class DashboardCollectionViewCell :UICollectionViewCell
{
    @IBOutlet weak var img_images: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img_logo: UIImageView!
    @IBOutlet weak var view_backGroundShopName: UIView!
    
    @IBOutlet weak var lbl_date: UILabel!
    @IBOutlet weak var shared_icon: UIView!
    @IBOutlet weak var shared_icon_view: UIView!
}
var X = 0
var Y = 0

protocol DashboardMainVCDelegate: class {
    func callViewLifeCycle()
}

var activeVC = 0

class DashboardMainVC: BaseViewController, UITableViewDataSource, UIScrollViewDelegate, TruckCellDelegate, ProductListVCDelegate, refreshData, refreshDataMessageDelegets, updateRequirement, GalleryVCDelegate, CommentVCDelegate, LightboxControllerPageDelegate,LightboxControllerDismissalDelegate, UIViewControllerTransitioningDelegate, CustomCameraVCDelegate, DashboardMainVCDelegate {
    
    var firstviewcount = 0
    var secondviewcount = 0
    var singlePackageDetail : PackageModel!
    var NotifiedPackageDetail : PackageModel!
    var fromDetailScreen : Bool = false
    var hideButtomButtonDelegate: HideBottomButtonDelegate?
    
    @IBOutlet weak var NotificationMsgView: UIView!
    @IBOutlet weak var NotificationMsgLabel: UILabel!
    @IBOutlet weak var constant_team_collectionView_height: NSLayoutConstraint!
    
    @IBOutlet weak var addboxesTitle: UILabel!
    var refreshController: UIRefreshControl?
    
    //CustomCellDelegate,UIViewControllerTransitioningDelegate, UIGestureRecognizerDelegate, YourCellDelegate,PopupCellDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    @IBOutlet weak var view_collectionviewfirst: UIView!
    @IBOutlet weak var view_collectionviewsScond: UIView!
    
    @IBOutlet weak var contentScrollView: UIScrollView!
    
    
    @IBOutlet weak var collectionviewfirst: UICollectionView!
    
    @IBOutlet weak var collectionviewmiddle: UICollectionView!
    @IBOutlet weak var collectionview: UICollectionView!{
        didSet{
            collectionview.reloadData()
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            //            tableView.rowHeight = UITableViewAutomaticDimension
            //            tableView.estimatedRowHeight = 450
            tableView.register(UINib(nibName: "PackageTableViewCell", bundle: nil), forCellReuseIdentifier: "PackageTableViewCell")
            
            //            tableView.register(PackageTableViewCell.self, forCellReuseIdentifier: "PackageTableViewCell")
        }
    }
    
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnNotification: SSBadgeButton!
    @IBOutlet weak var viewPopup: UIView!
   
    @IBOutlet weak var btnPopup1: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var btnPopup2: UIButton!
    @IBOutlet weak var btnPopup3: UIButton!
    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            collectionview.reloadData()
        }
    }
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var arrowView: UIView!
    
    
    @IBOutlet weak var alertTransparentBack: UIView!
    @IBOutlet weak var alertView: UIView!
    
    @IBAction func AlertBackScreen(_ sender: Any) {
        alertTransparentBack.isHidden = true
    }
    
    
    @IBOutlet weak var loadmoreBtn: UIButton!
    var isloadmorerunning = false
    @IBAction func loadmore(_ sender: Any) {
        if(isloadmorerunning == false){
            isloadmorerunning = true
        didTapLoadMoreButton()
        }
    }
    
    func showAlertMsg(showalert : String)
           
           {
               if(showalert == "yes"){
                
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
    @IBAction func cancel(_ sender: Any) {
        let parameterDict =  ["user_id":  self.singlePackageDetail.user_id ?? "", "shop_id": self.singlePackageDetail.id ?? ""]
        print("parameters here")
                                  print(parameterDict)
                                  APIManager.shared().requestWith(NetworkingConstants.baseURL + NetworkingConstants.company.API_updatesharednotification, method: .post, andParameters: parameterDict) { response in

                                              if response.status {

                                                  let responseDic = response.object! as [String: Any]
                                                 print(responseDic)
                                             
                                                
                                              }else {
                                                  //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: response.errorMessage)
                                              }
                                              
                                          }
                                      showAlertMsg(showalert: "No")
                                            
                                      
                                  }

    
    @IBAction func save(_ sender: Any) {
        
        let parameterDict =  ["user_id":  self.singlePackageDetail.user_id ?? "", "shop_id": self.singlePackageDetail.id ?? ""]
              print("parameters here")
                                        print(parameterDict)
                                        APIManager.shared().requestWith(NetworkingConstants.baseURL + NetworkingConstants.company.API_updatesharednotification, method: .post, andParameters: parameterDict) { response in

                                                    if response.status {

                                                        let responseDic = response.object! as [String: Any]
                                                       print(responseDic)
                                                   
                                                      
                                                    }else {
                                                        //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: response.errorMessage)
                                                    }

                                                }
    showAlertMsg(showalert: "No")

        let storyboard = UIStoryboard.init(name: "NewBoard", bundle: nil)
                                                    let vc = storyboard.instantiateViewController(withIdentifier: "DetailScreenViewController") as! DetailScreenViewController
        vc.singlePackageDetail = singlePackageDetail
                                                 pr1 = true
                                                 self.navigationController?.pushViewController(vc, animated: true)
        }
    
    
    var bJustPopup: Bool = false
    var bMenuPopup: Bool = false
    var tableview_scoll_index = 0
    
    enum CenterButtonType: Int {
        case plus = 1, camera = 2, radio = 3
    }
    
    private var centerButtonType: CenterButtonType = .plus
    var productListVC: ProductListVC!
    var returnDateVC: ReturnDateVC!
    
    enum ScrollDirection {
        case up, down
    }
    
    var shouldCalculateScrollDirection = false
    private var lastContentOffset: CGFloat = 0
    private var scrollDirection: ScrollDirection = .up {
        didSet {
            //            if scrollDirection == .down {
            //                viewBottomMenu.isHidden = false
            //                headerView.isHidden = false
            //
            //                UIView.animate(withDuration: 0.5, animations: {
            //                    self.viewBottomMenu.alpha = 1.0
            //                    self.headerView.alpha = 1.0
            //                }) { (isCompeleted) in
            //
            //                }
            //
            //            } else {
            //                UIView.animate(withDuration: 0.5, animations: {
            //                    self.viewBottomMenu.alpha = 0.0
            //                    self.headerView.alpha = 0.0
            //
            //                }) { (isCompeleted) in
            //                    self.viewBottomMenu.isHidden = true
            //                    self.headerView.isHidden = true
            //                }
            //
            //            }
        }
    }
    private var longGestureRecognizer: UILongPressGestureRecognizer?
    
    var photomanager:BWPhotoManager!
    var im_staus = 0
    var isExplaned = false
    
    enum Const {
        static let closeCellHeight: CGFloat = 200
        static let openCellHeight: CGFloat = 220
        static let rowsCount = 10
    }
    
    var cellHeights: [IndexPath: CGFloat] = [:]
    var isExtend:Bool = false
    var selectedElement = [Int]()
    var selectedImage = -1
    var temArray = [Int]()
    
    var delete_id = "0"
    
    let user_details = UserModel.sharedInstance
    var selectedPackage:PackageModel!
    var returnvaluse : PackageModel!
    var selectedIndex = -1
    let transition = BubbleTransition()
    let interactiveTransition = BubbleInteractiveTransition()
    
    var bGotoCameraAfterAddEmpty: Bool = false
    
    var packageModel = [PackageModel]()
    var dataList = [PackageModel]()
    
    var packageShowExtendLog = (IndexPath(row: -1, section: 0), PackageExtendMode.None, false, 0, 0, false)
    var stateAnimationAction: [[OptionPackageEnum]] = []
    
    var pickerViewController: PickerVC = (UIStoryboard(name: "NewBoard", bundle: nil).instantiateViewController(withIdentifier: "PickerVC") as! PickerVC)
    var strTxtComments: String = "Please enter comment"
    static let txtPlaceholderText: String = "Please enter comment"
    var commentModel = [CommentModel]()
    var datesModel = [String]()
    var refreshTable: Bool = false
    
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    var orignalY: CGFloat!

    @IBOutlet weak var userinfo: UIView!
    var myNewView:UIView? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        btnPlusG = btnPlus
        BtnCubeG = BtnCube
        BtnHeartG = BtnHeart
        MenuViewG?.isHidden = false
            
        let transition = CATransition()
                              transition.duration = 0.25
                              transition.type = CATransitionType.fade
                              transition.subtype = CATransitionSubtype.fromBottom
                              transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                              tabBarController?.view.layer.add(transition, forKey: kCATransition)
                
             //  self.navigationController?.pushViewController(vc, animated: false)
                //vc.modalPresentationStyle = .overFullScreen
                //self.present(vc, animated: true, completion: nil)
        self.viewPopup.isHidden = true
     btnNotificationS = btnNotification

        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        
        
        if let value = UserDefaults.standard.value(forKey: "CenterButtonType") as? Int {
            if let centerType = CenterButtonType(rawValue: value) {
                centerButtonType = centerType
                switch centerType {
                case .plus:
                    break
                case .radio:
                    break
                case .camera:
                    break
                }
                
                popDownMenu()
            }
            
        }
        
        self.productListVC = (UIStoryboard(name: "NewBoard", bundle: nil).instantiateViewController(withIdentifier: "ProductListVC") as! ProductListVC)
        self.addChild(self.productListVC)
        self.productListVC.delegate = self
        
        self.returnDateVC = (UIStoryboard(name: "NewBoard", bundle: nil).instantiateViewController(withIdentifier: "ReturnDateVC") as! ReturnDateVC)
        self.addChild(self.returnDateVC)
        
        longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressOnCenterButton))
        //btnCenter.addGestureRecognizer(longGestureRecognizer!)
        self.viewPopup.isHidden = true
        //refreshSetButtonStatus()
        //        addNotificationIcon()
        self.tabBarController?.tabBar.isHidden = true
        
        //        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        //        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        //        self.view.addGestureRecognizer(swipeRight)
        
        //Setup UI
        setupPickerView()
        swipeGestureActivateCamera()
        refreshTable = true
        self.perform(#selector(initTableViewData), with: self, afterDelay: 0.5)
        
        self.rightSettingButton()
        self.leftSearchButton()
        //        self.searchBar.isHidden = true
        
        
            print("sdsd2 \(btntype)")

        searchLogo(keyword: "")
      
        refreshController = UIRefreshControl()
               refreshController?.addTarget(self, action:  #selector(refreshTableData), for: .valueChanged)
               self.contentScrollView.refreshControl = refreshController
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showNotificationMsg(showtext: NotificationMsgShowText)
        MenuViewG?.isHidden = false
        if(btntype == "webshop"){
            btntype = "dashboard"
        }
    }
    
    func callViewLifeCycle() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            if activeVC != 2 { return }
            if  self.orignalY == nil {
                        self.orignalY = self.NotificationMsgView.center.y
                   }
            self.NotificationMsgView.center.y = self.orignalY
                   self.viewWillAppear(true)
                   self.viewDidAppear(true)
        })
    }
    
    func showNotificationMsg(showtext : String)
    {
        if(showtext != ""){
            
            let x = (self.NotificationMsgView.frame.width)/2+(self.NotificationMsgView.frame.minX)
            let y = (self.NotificationMsgView.frame.height)/2+(self.NotificationMsgView.frame.minY)-170
            
             self.NotificationMsgView.center = CGPoint(x: x, y: y)
               self.NotificationMsgView.alpha = 0.0
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                 print("Loaded with delay")
                 self.NotificationMsgLabel.text = showtext
                 self.NotificationMsgView.isHidden = false
                 self.NotificationMsgView.alpha = 1
                 UIView.animate(withDuration: 0.5,
                    delay: 0.1,
                    options: [.transitionFlipFromRight],
                    animations: {
                      
                     let x = (self.NotificationMsgView.frame.width)/2+(self.NotificationMsgView.frame.minX)
                     let y = (self.NotificationMsgView.frame.height)/2+(self.NotificationMsgView.frame.minY)+170
                       
                      self.NotificationMsgView.center = CGPoint(x: x, y: y)
                     
                     },
                                completion: { finished in
                                 print("Bug moved right!")
                     })
              }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {

            UIView.animate(withDuration: 0.5,
                            delay: 0.1,
                            options: [.transitionFlipFromRight],
                            animations: {
                              
                             let x = (self.NotificationMsgView.frame.width)/2+(self.NotificationMsgView.frame.minX)
                             let y = (self.NotificationMsgView.frame.height)/2+(self.NotificationMsgView.frame.minY)-170
                             
                              self.NotificationMsgView.center = CGPoint(x: x, y: y)
                                self.NotificationMsgView.alpha = 0.0
                             },
                                        completion: { finished in
                                         print("Bug moved right!")
                             })
            
            
            }
            
             DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                     print("Loaded with delay")
                 self.NotificationMsgLabel.text = ""
                NotificationMsgShowText = ""
                 self.NotificationMsgView.isHidden = true
                
             }
        }
        
    }
    func leftSearchButton()
    {
        let frameimg = CGRect(x: 0, y: 0, width: 30, height: 30)
        let someButton = UIButton(frame: frameimg)
        someButton.setImage(UIImage(named: "search"), for: .normal)
        someButton.addTarget(self, action: #selector(self.searchButtonHiddenAction), for: .touchUpInside)
        
        let mailbutton = UIBarButtonItem(customView: someButton)
        navigationItem.leftBarButtonItem = mailbutton
        
        let heightConstraint = NSLayoutConstraint(item: someButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameimg.height)
        let widthConstraint = NSLayoutConstraint(item: someButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameimg.width)
        heightConstraint.isActive = true;
        widthConstraint.isActive = true;
    }
    
    @objc func searchButtonHiddenAction(_ sender: Any)
    {
        if (self.searchBar.isHidden == true)
        {
            self.contentScrollView.setContentOffset(.zero, animated:true)
            
            self.searchBar.isHidden = false
        }else
        {
            self.searchBar.isHidden = true
        }
    }
    
    
    
    func rightSettingButton()
    {
        let frameimg = CGRect(x: 0, y: 0, width: 30, height: 30)
        let someButton = UIButton(frame: frameimg)
        someButton.setImage(UIImage(named: "Setting"), for: .normal)
        someButton.addTarget(self, action: #selector(self.doneButton), for: .touchUpInside)
        
        
        let mailbutton = UIBarButtonItem(customView: someButton)
        let notificatiobutton_frameimg = CGRect(x: 0, y: 0, width: 25, height: 25)
        let notificatiobutton = UIButton(frame: notificatiobutton_frameimg)
        let image = UIImage(named: "E_3")
        notificatiobutton.setTitleColor(.black, for: .normal)
        notificatiobutton.setImage(image, for: .normal)
        notificatiobutton.addTarget(self, action: #selector(self.notificationButton), for: .touchUpInside)
        
        let notificatiobutton_item = UIBarButtonItem(customView: notificatiobutton)
        
        navigationItem.rightBarButtonItems = [mailbutton,notificatiobutton_item]
        
        let heightConstraint = NSLayoutConstraint(item: someButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameimg.height)
        let widthConstraint = NSLayoutConstraint(item: someButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameimg.width)
        heightConstraint.isActive = true;
        widthConstraint.isActive = true;
        
        let heightConstraint1 = NSLayoutConstraint(item: notificatiobutton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: notificatiobutton_frameimg.height)
        let widthConstraint1 = NSLayoutConstraint(item: notificatiobutton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: notificatiobutton_frameimg.width)
        heightConstraint1.isActive = true;
        widthConstraint1.isActive = true;
        
    }
    
    @objc func doneButton(_ sender: Any)
    {
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func notificationButton(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "PendingNotificationVC") as! PendingNotificationVC
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func addNotificationIcon() {
        let image = UIImage(named: "E_3")?.withRenderingMode(.alwaysTemplate)
        btnNotification.setImage(image, for: .normal)
        btnNotification.tintColor = UIColor.white
        btnNotification.badgeBackgroundColor = UIColor.red
        btnNotification.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 4)
        
    }
    
    func showBadgeIcon() {
       // btnNotification.badge = String(pendingNotifications.count)
       // btnNotification.badge = "6"
       // btnNotification.badgeBackgroundColor = .red
        getfriends(FtableS)
}
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer)
    {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer
        {
            switch swipeGesture.direction
            {
                
            case UISwipeGestureRecognizer.Direction.right:
                
                self.bGotoCameraAfterAddEmpty = true
                self.API_shipment_action2()
                
            default:
                break
            }
        }
    }
    @objc func refreshTableData() {
        if !refreshTable {
            self.perform(#selector(initTableViewData), with: self, afterDelay: 2)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        contentScrollView.setContentOffset(CGPoint(x: X, y: Y), animated: false)
        self.collectionview.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
     
       
        IQKeyboardManager.sharedManager().enable = false
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = false
        if isFromDetail {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isFromDetail = false
                   Y = 0
            }
            return
            
        }
        
                showBadgeIcon()
        if shouldRefreshDashboardData {
            refreshTableData()
        }
        self.navigationController?.isNavigationBarHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshTable = false
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().shouldResignOnTouchOutside = true
        self.collectionview.removeObserver(self, forKeyPath: "contentSize", context: nil)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @objc func initTableViewData() {
        if (fromDetailScreen == false)
        {
            self.API_getPackageByUserId(setup: true)
        }else
        {
            refreshController?.endRefreshing()
            fromDetailScreen = false
            shouldRefreshDashboardData = false
        }
    }
    
    func API_getPackageByUserId(setup: Bool = false) {
        self.im_staus = 1
      
        //RappleActivityIndicatorView.startAnimating()
        let parameterDict =  ["user_id":  user_details.user_id ?? ""]
        
        //print(parameterDict)
        shouldRefreshDashboardData = false
        self.view.isUserInteractionEnabled = false
        DashboardManager.API_getPackageByUserId(information: parameterDict) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            self.refreshController?.endRefreshing()
            if error == nil {
                //print(json)
                
                self.packageModel.removeAll()
                self.dataList.removeAll()
                
                
                var notification_day_array = [String]()
                for (_, subJson) in json["message"] {
                    let modelList = PackageModel.init(json: subJson)
                    
                    self.dataList.append(modelList)
                    //                    notification_day_array.append("Warranty&\(modelList.title.count == 0 ? "Unknown" : modelList.title)&\(modelList.notification_days == nil ? 1 : modelList.notification_days)&\(modelList.getNotificationReturnDateDisplay())")
                    //                    notification_day_array.append("PriceMatch&\(modelList.title.count == 0 ? "Unknown" : modelList.title)&\(modelList.w_notification_days == nil ? 1 : modelList.w_notification_days)&\(modelList.getNotificationWarrantyDateDisplay())")
                    //                    notification_day_array.append("Return&\(modelList.title.count == 0 ? "Unknown" : modelList.title)&\(modelList.priceMatchNotificationDay == nil ? 1 : modelList.priceMatchNotificationDay)&\(modelList.getNotificationPriceMatchDateDisplay())")
                }
                
                UserDefaults.standard.set(notification_day_array, forKey: "notificationDayArray")
                
                if !(UserDefaults.standard.object(forKey: "notification_set_status") != nil) {
                    UserDefaults.standard.set(true, forKey: "notification_set_status")
                }
                
                //                self.packageModel = self.dataList
                
                //
                if self.dataList.count >= MAX_PACKAGE_PER_LOAD {
                    self.loadmoreBtn.isHidden = false

                    self.packageModel = Array(self.dataList[0...(MAX_PACKAGE_PER_LOAD - 1)])
                } else {
                    self.loadmoreBtn.isHidden = true

                    self.packageModel = self.dataList
                }
                
                self.scheduleLocal()
                self.refreshTable = false
                DispatchQueue.main.async {
                    // self.tableView.reloadData()
                }
                
                //
                
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    // your code here
                    //var indexPath = IndexPath(row: self.packageModel.count-1, section: 0)
                    //self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    // your code here
                    //var indexPath = IndexPath(row: self.tableview_scoll_index, section: 0)
                    //self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
                self.collectionview.reloadData()
                self.collectionviewmiddle.reloadData()
                self.collectionviewfirst.reloadData()
                
                
            }else {
                DispatchQueue.main.async {
                    //self.tableView.reloadData()
                    self.collectionview.reloadData()
                    
                    
                    //                    self.tableView.layoutIfNeeded()
                    //                    self.view.layoutIfNeeded()
                }
            }
              self.view.isUserInteractionEnabled = true
        }
    }
    
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        if(keyPath == "contentSize"){
            if let newvalue = change?[.newKey]
            {
                let newsize  = newvalue as! CGSize
                
                let collectionView = object as? UICollectionView
                
                if (collectionView == self.collectionview)
                {
                    constant_team_collectionView_height.constant = newsize.height
                    self.collectionview.layoutIfNeeded()
                    
                }else
                {
                }
                
            }
        }
    }
    
    
    
    func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        
        let notification_day_array = UserDefaults.standard.stringArray(forKey: "notificationDayArray") ?? [String]()
        
        let content = UNMutableNotificationContent()
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "notification_day"
        content.userInfo = ["customData": "notification_day"]
        
        for item in notification_day_array
        {
            let array = item.split(separator: "&").map(String.init)
            
            content.title = "Notification for \(array[0]) Day of \(array[1])"
            content.body = "\(array[0]) Day of \(array[1]) will come after \(array[2]) days"
            
            var dateComponent = DateComponents()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let return_notification_day = formatter.date(from: array[3])!
            dateComponent.year = Calendar.current.component(.year, from: return_notification_day)
            dateComponent.month = Calendar.current.component(.month, from: return_notification_day)
            dateComponent.day = Calendar.current.component(.day, from: return_notification_day)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: true)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
    }
    
    @objc func alertAdboxAdded() {
        let alertController = UIAlertController(title: "Empty adbox added successfully", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.refresNewData()
            if self.packageModel.count == 0 {
                //   self.tableView.reloadData()
            } else {
                // self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func API_shipment_action2() {
       // RappleActivityIndicatorView.startAnimating()
        
      //  DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
           // let parameterDict =  ["user_id":  self.user_details.user_id ?? ""]
            
           // DashboardManager.API_shipment_action2(information: parameterDict) { (json, wsResponse, error) in
             //   RappleActivityIndicatorView.stopAnimation()
              //  if error == nil {
                    ////print(json)
                //    if self.bGotoCameraAfterAddEmpty == false {
                //        self.alertAdboxAdded()
               //     } else {
                   //     let packageId = json["id"].stringValue
                    //    self.API_addimage(packageId: packageId)
                  //  }
              //  } else {
                    
               // }
            //}
       // })
       // self.API_addimage(packageId: "")
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
                           let vc = storyboard.instantiateViewController(withIdentifier: "CustomCameraViewController") as! CustomCameraViewController
                         //  vc.packageId = packageId!
                           vc.delegate = self
                          // vc.modalPresentationStyle = .overFullScreen
                          // self.present(vc, animated: true, completion: nil)
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromTop
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        tabBarController?.view.layer.add(transition, forKey: kCATransition)
                      //self.navigationController?.popToRootViewController(animated: true)
                      self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func onBtnSetting(_ sender: Any) {
        //GLOBAL_IMG = btnNotification.imageView
        //self.navigationController?.delegate = self
        pr1 = true
        GLOBAL_IMG = nil
        pr1 = false
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        tabBarController?.view.layer.add(transition, forKey: kCATransition)
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func didTappedNotificationIcon(_ sender: Any) {
        GLOBAL_IMG = btnNotification.imageView
        self.navigationController?.delegate = self
        pr1 = true
        
        GLOBAL_IMG = nil
        pr1 = false
        
        let storyboard = UIStoryboard.init(name: "NewBoard", bundle: nil)
        
       // let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        //let vc = storyboard.instantiateViewController(withIdentifier: "PackageShareVC") as! PackageShareVC
       // vc.shipmentId = singlePackageDetail.id
        

         let vc = storyboard.instantiateViewController(withIdentifier: "FriendsVC2") as! FriendsV
        // vc.shipmentId = singlePackageDetail.id
        
        
          let transition = CATransition()
          transition.duration = 0.25
          transition.type = CATransitionType.moveIn
          transition.subtype = CATransitionSubtype.fromRight
          transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
          tabBarController?.view.layer.add(transition, forKey: kCATransition)

        
        //self.navigationController?.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: true)
        
        
        
       // let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
      //  let vc  = storyboard.instantiateViewController(withIdentifier: "PendingNotificationVC") as! PendingNotificationVC
       // vc.modalPresentationStyle = .fullScreen
       // self.present(vc, animated: true, completion: nil)
    }
   
    @IBOutlet weak var btnPlus: UIButton!
    
    @IBOutlet weak var BtnCube: UIButton!
    
    @IBOutlet weak var BtnHeart: UIButton!
    
   
    @IBAction func onBtnWebshop(_ sender: Any)
    {
        //if(self.LeftLine.center.x != self.BtnCube.center.x){
         
            UIView.animate(withDuration: 0.2, delay: 0.0,
                           options: [.curveEaseInOut], animations: {
                           
            }) { (isCompeleted) in
                //  self.Vback.isHidden = false
            }
            
            let storyboard = UIStoryboard(name: "NewBoard", bundle: nil)
            
            let vc = storyboard.instantiateViewController(withIdentifier: "webshopsVC") as! webshopsVC
            // vc.shipmentId = singlePackageDetail.id
            GLOBAL_IMG = nil
            //self.navigationController?.present(vc, animated: true, completion: nil)
            // self.navigationController?.pushViewController(vc, animated: true)
            
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.moveIn
            transition.subtype = CATransitionSubtype.fromLeft
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
            tabBarController?.view.layer.add(transition, forKey: kCATransition)
            //self.navigationController?.popToRootViewController(animated: true)
            self.navigationController?.pushViewController(vc, animated: false)
            
        //}
    }
  
    @IBAction func onBtnAdded(_ sender: Any) {
        //if(self.RightLine.center.x != self.BtnHeart.center.x){
        
        UIView.animate(withDuration: 0.2, delay: 0.0,
        options: [.curveEaseInOut], animations: {
            print("updating position")
     
            }) { (isCompeleted) in
                                 //  self.Vback.isHidden = false
                                             }
        //self.tabBarController?.selectedIndex = 1
        //self.dismiss(animated: true, completion: nil)
                 let transition = CATransition()
                       transition.duration = 0.25
                       transition.type = CATransitionType.moveIn
                       transition.subtype = CATransitionSubtype.fromRight
                       transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                       tabBarController?.view.layer.add(transition, forKey: kCATransition)
                       //self.navigationController?.popToRootViewController(animated: true)
                                  self.navigationController?.popToRootViewController(animated: false)

       // }
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    @IBAction func onBtnCenter(_ sender: Any) {
       // self.btnPlus.frame = CGRect(x: self.btnPlus.frame.origin.x, y: self.btnPlus.frame.origin.y-50, width: 100, height: 100)
        /*if self.bJustPopup {
            self.bJustPopup = false
            return
        }
        
        if self.bMenuPopup {
            popDownMenu()
        }*/
        
        /*if self.centerButtonType == .plus {
            self.bGotoCameraAfterAddEmpty = false
            self.API_shipment_action2()
        } else if self.centerButtonType == .camera {*/
            self.bGotoCameraAfterAddEmpty = true
            self.API_shipment_action2()
        /*} else if self.centerButtonType == .radio {
            navigateToAddNewPackages()
        }*/
    }
    
    @IBAction func onBtnPopup1(_ sender: Any) {
        
        btnPopup1.layer.zPosition = 1
        btnPopup2.layer.zPosition = 0
        btnPopup3.layer.zPosition = 0
        
        if self.centerButtonType == .plus {
            self.centerButtonType = .radio
        } else if self.centerButtonType == .camera {
            self.centerButtonType = .radio
        } else {
            self.centerButtonType = .camera
        }
        
        UserDefaults.standard.set(centerButtonType.rawValue, forKey: "CenterButtonType")
        
        
        popDownMenu()
    }
    @IBOutlet weak var GoUpImg: UIImageView!
    @IBAction func arrowup(_ sender: Any) {
        self.line1.isHidden = true
        self.line2.isHidden = true
        UIView.animate(withDuration: 0.2,
                                        delay: 0.1,
                                        options: [.curveEaseInOut],
                                        animations: {
                                           
        //view_collectionviewfirst.isHidden = true
        //view_collectionviewmiddle.isHidden = true
        print("Arrow is clicked")
        if(arrowStatus == 0){
            self.view_collectionviewfirst.isHidden = true
            self.view_collectionviewsScond.isHidden = true
            self.line1.isHidden = true
            self.line2.isHidden = true
            self.GoUpImg.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi))
            arrowStatus = 1
        }else{
            if(self.firstviewcount != 0){
                self.view_collectionviewfirst.isHidden = false
                self.line1.isHidden = false

            }
            if(self.secondviewcount != 0){
                self.view_collectionviewsScond.isHidden = false
                self.line2.isHidden = false

            }
            self.GoUpImg.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi*2))

            arrowStatus = 0
        }
                                            },
                                                                                   completion: { finished in
                                                                                   // print("Bug moved right!")
                                                                    })
    }
    
    @IBAction func onBtnPopup2(_ sender: Any) {
        
        btnPopup1.layer.zPosition = 0
        btnPopup2.layer.zPosition = 1
        btnPopup3.layer.zPosition = 0
        
        if self.centerButtonType == .plus {
            self.centerButtonType = .camera
        } else if self.centerButtonType == .camera {
            self.centerButtonType = .plus
        } else {
            self.centerButtonType = .plus
        }
        
        UserDefaults.standard.set(centerButtonType.rawValue, forKey: "CenterButtonType")
        
        popDownMenu()
    }
    
    @IBAction func onBtnPopup3(_ sender: Any) {
        btnPopup1.layer.zPosition = 0
        btnPopup2.layer.zPosition = 0
        btnPopup3.layer.zPosition = 1
        // keep status
        
        UserDefaults.standard.set(centerButtonType.rawValue, forKey: "CenterButtonType")
        
        popDownMenu()
    }
    
    @objc func handleLongPressOnCenterButton() {
        popupMenu()
    }
    
    func setButtonImages(button: UIButton, type: CenterButtonType) {
        if type == .plus {
            button.setBackgroundImage(UIImage(named: "btn_plus_white"), for: .normal)
            button.setBackgroundImage(UIImage(named: "btn_plus_red"), for: .highlighted)
        } else if type == .camera {
            button.setBackgroundImage(UIImage(named: "btn_camera_white"), for: .normal)
            button.setBackgroundImage(UIImage(named: "btn_camera_red"), for: .highlighted)
        } else {
            button.setBackgroundImage(UIImage(named: "btn_audio_white"), for: .normal)
            button.setBackgroundImage(UIImage(named: "btn_audio_red"), for: .highlighted)
        }
    }
    
    func refreshSetButtonStatus() {
       
        
        if self.centerButtonType == .plus {
            setButtonImages(button: btnPopup1, type: .radio)
            setButtonImages(button: btnPopup2, type: .camera)
            setButtonImages(button: btnPopup3, type: .plus)
        } else if self.centerButtonType == .camera {
            setButtonImages(button: btnPopup1, type: .radio)
            setButtonImages(button: btnPopup2, type: .plus)
            setButtonImages(button: btnPopup3, type: .camera)
        } else {
            setButtonImages(button: btnPopup1, type: .camera)
            setButtonImages(button: btnPopup2, type: .plus)
            setButtonImages(button: btnPopup3, type: .radio)
        }
    }
    
    func popupMenu() {
        self.viewPopup.isHidden = false
        print("popupMenu")
        let width = viewPopup.bounds.width
        let height = viewPopup.bounds.height
        let w:CGFloat = 0
        let x = (width - w)/2
        
        btnPopup1.frame = CGRect(x: x, y: height-w, width: w, height: w)
        btnPopup2.frame = CGRect(x: x, y: height-w, width: w, height: w)
        btnPopup3.frame = CGRect(x: x, y: height-w, width: w, height: w)
        
        self.perform(#selector(animatePopup), with: nil, afterDelay: 0.01)
        
       
        self.bMenuPopup = true
        self.bJustPopup = true
    }
    
    @objc func animatePopup() {
        print("animatePopup")
        let width = viewPopup.bounds.width
        let height = viewPopup.bounds.height
        let w:CGFloat = 0
        let x = (width - w)/2
        
        UIView.animate(withDuration: 0.2, animations: {
            self.btnPopup1.frame = CGRect(x: x, y: height - w*3.3, width: w, height: w)
            self.btnPopup2.frame = CGRect(x: x, y: height - w*2.2, width: w, height: w)
            //let transform = CGAffineTransform(rotationAngle: CGFloat(45.0*3.141592/180))
            //self.btnCenter.transform = transform
        }) { (success) in
            if success {
                UIView.animate(withDuration: 0.05, delay: 0.2, options: .layoutSubviews, animations: {
                    self.btnPopup1.frame = CGRect(x: x, y: height - w*3.2, width: w, height: w)
                    self.btnPopup2.frame = CGRect(x: x, y: height - w*2.1, width: w, height: w)
                }) { (success) in
                    
                }
            }
        }
    }
    
    func popDownMenu() {
        print("popDownMenu")
        let width = viewPopup.bounds.width
        let height = viewPopup.bounds.height
        let w: CGFloat = 0
        let x = (width - w)/2
        
        UIView.animate(withDuration: 0.2, animations: {
            self.btnPopup1.frame = CGRect(x: x, y: height-w, width: w, height: w)
            self.btnPopup2.frame = self.btnPopup1.frame
            //let transform = CGAffineTransform(rotationAngle: CGFloat(45.0*3.141592/180))
            //self.btnCenter.transform = transform
        }) { (success) in
            self.viewPopup.isHidden = true
            //self.btnCenter.addGestureRecognizer(self.longGestureRecognizer!)
            
            //self.refreshSetButtonStatus()
        }
        
        self.bMenuPopup = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.packageModel.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = .clear
        
        return header
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageTableViewCell", for:indexPath) as! PackageTableViewCell
        cell.setup(model: packageModel[indexPath.row], atIndex: indexPath, mode: (packageShowExtendLog.0.row == indexPath.row ? packageShowExtendLog.1 : .None))
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageTableViewCell", for:indexPath) as! PackageTableViewCell
        cell.setup(model: packageModel[indexPath.row], atIndex: indexPath, mode: (packageShowExtendLog.0.row == indexPath.row ? packageShowExtendLog.1 : .None))
        cell.updateWarrantyAndReutDateUI(numberLeft: packageShowExtendLog.3, numberRight: packageShowExtendLog.4, activeSubmit: packageShowExtendLog.2, switchState: packageShowExtendLog.5)
        cell.delegate = self
        
        if isExplaned == false {
            cell.reorderAction()
        }
        
        if (dataList.count - packageModel.count > 0) && indexPath.row == (packageModel.count - 1) && packageModel.count >= MAX_PACKAGE_PER_LOAD {
            cell.moreView.isHidden = false
        } else {
            cell.moreView.isHidden = true
        }
        
        cell.btnSend.tag = indexPath.row
        cell.btnSend.addTarget(self, action: #selector(didTappedSendButtons(_:)), for: .touchUpInside)
        cell.txtComments.text = strTxtComments
        cell.commentModel = self.commentModel
        cell.commentDateModel = self.datesModel
        
        if packageShowExtendLog.0.row == indexPath.row && packageShowExtendLog.1 == .Comments {
            cell.reloadTableView()
        }
        //        cell.layoutIfNeeded()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToCameraSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        guard containsGestureRecognizer(recognizers: cell.contentView.gestureRecognizers, find: swipeRight) == false else { return cell }
        cell.contentView.addGestureRecognizer(swipeRight)
        return cell
    }
    
    func containsGestureRecognizer(recognizers: [UIGestureRecognizer]?, find: UIGestureRecognizer) -> Bool {
        if let recognizers = recognizers {
            for gr in recognizers {
                if gr == find {
                    return true
                }
            }
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            
            let model_data = self.packageModel[indexPath.row]
            self.delete_id = model_data.id!
            
            let alert = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
                self.API_deletePackage(id: self.delete_id)
            }))
            alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func randomString(length: Int) -> String {
        let letters =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    func isVisible(_ view: UIView) -> Bool {
        if view.isHidden || view.superview == nil {
            return false
        }

        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController,
            let rootView = rootViewController.view {

            let viewFrame = view.convert(view.bounds, to: rootView)

            let topSafeArea: CGFloat
            let bottomSafeArea: CGFloat

            if #available(iOS 11.0, *) {
                topSafeArea = rootView.safeAreaInsets.top
                bottomSafeArea = rootView.safeAreaInsets.bottom
            } else {
                topSafeArea = rootViewController.topLayoutGuide.length
                bottomSafeArea = rootViewController.bottomLayoutGuide.length
            }

            return viewFrame.minX >= 0 &&
                   viewFrame.maxX <= rootView.bounds.width &&
                   viewFrame.minY >= topSafeArea &&
                   viewFrame.maxY <= rootView.bounds.height - bottomSafeArea
        }

        return false
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // The current offset
        let offset = scrollView.contentOffset.y
        //print("offset", offset)
        // Determine the scolling direction
        if offset == 0.0 {
            hideButtomButtonDelegate?.hideButton(false)
            hideHeaderButtons(false)
        } else
        if lastContentOffset > offset && shouldCalculateScrollDirection {
            scrollDirection = .down
              hideButtomButtonDelegate?.hideButton(false)
            hideHeaderButtons(false)
        }
        else if lastContentOffset < offset && shouldCalculateScrollDirection {
            scrollDirection = .up
            hideButtomButtonDelegate?.hideButton(true)
            hideHeaderButtons(true)
        }
        
        //print(isloadmorerunning)
        let xxx = isVisible(loadmoreBtn)
       // print(xxx)
        loadmoreBtn.setTitle("Loading..", for: .normal)
        if(xxx == true){
            //loadmoreBtn.setTitle("Loading..", for: .normal)
            if(isloadmorerunning == false){
                isloadmorerunning = true

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {

                self.didTapLoadMoreButton()
                }
            }
        }
 
        view.endEditing(true)
        // This needs to be in the last line
        lastContentOffset = offset
    }
    func hideHeaderButtons(_ bool: Bool) {
        UIView.animate(withDuration: 0.5, animations: {
                self.headerView.alpha = bool ? 0 : 1
            self.arrowView.alpha = bool ? 0 : 1
            }) { v in
              //  self.headerView.isHidden = bool
            }
    
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
     
     
            
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        shouldCalculateScrollDirection = false
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        shouldCalculateScrollDirection = false
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        shouldCalculateScrollDirection = true
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
          hideButtomButtonDelegate?.hideButton(false)
        hideHeaderButtons(false)
    }
   
    
    func showReturnDateView(cell: TruckCell) {
        self.view.addSubview(self.returnDateVC.view)
        self.returnDateVC.view.frame = self.view.bounds
        
        let packageObj = self.packageModel[cell.rowIndex]
        self.returnDateVC.user_id = packageObj.user_id
        self.returnDateVC.package_id = packageObj.id
        self.returnDateVC.packageModel = packageObj
        
        self.returnDateVC.set(returnMode: true, leftNum: packageObj.return_days, rightNum: packageObj.notification_days)
    }
    
    func showWarrantyDateView(cell: TruckCell) {
        self.view.addSubview(self.returnDateVC.view)
        self.returnDateVC.view.frame = self.view.bounds
        
        let packageObj = self.packageModel[cell.rowIndex]
        self.returnDateVC.user_id = packageObj.user_id
        self.returnDateVC.package_id = packageObj.id
        self.returnDateVC.packageModel = packageObj
        
        self.returnDateVC.set(returnMode: false, leftNum: packageObj.waranty_months, rightNum: packageObj.w_notification_days)
    }
    
    func showProductListView() {
        self.productListVC.packageModel = self.packageModel
        self.view.addSubview(self.productListVC.view)
        self.productListVC.refreshList()
        
        let frame = self.view.bounds
        let rectFrom = CGRect(x: 300, y: 0, width: frame.width, height: frame.height)
        self.productListVC.view.frame = rectFrom
        
        UIView.animate(withDuration: 0.2) {
            let rect = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            self.productListVC.view.frame = rect
        }
    }
    
    func hideProductListView() {
        let frame = self.view.bounds
        
        UIView.animate(withDuration: 0.2) {
            let rectTo = CGRect(x: frame.width, y: 0, width: frame.width, height: frame.height)
            self.productListVC.view.frame = rectTo
        }
    }
    
    func didClickOnTitleArea(cell: TruckCell) {
        self.showProductListView()
    }
    
    func didClickOnReturnDateButton(cell: TruckCell) {
        self.showReturnDateView(cell: cell)
    }
    
    func didClickOnWarrantyDateButton(cell: TruckCell) {
        self.showWarrantyDateView(cell: cell)
    }
    
    func didClickOnCamera(cell: TruckCell) {
        let packageObj = self.packageModel[cell.rowIndex]
        selectedPackage = packageObj
        self.API_addimage(packageId: packageObj.id)
    }
    
    func didClickOnRefresh(cell: TruckCell) {
        self.refresNewData()
    }
    
    func didClickOnShare(cell: TruckCell) {
        "Date to Share".share()
    }
    
    func didClickOnTruck(cell: TruckCell) {
        let packageObj = self.packageModel[cell.rowIndex]
        selectedPackage = packageObj
        self.inputCourierNumber(packageID: packageObj.id ?? "", shipmentID: packageObj.shipmentId ?? "")
    }
    
    func inputCourierNumber(packageID: String, shipmentID: String) {
        let alertController = UIAlertController(title: "Update courier number", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Update", style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                self.updateCourierNumber(packageID: packageID, shipmentID: text)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.text = shipmentID
            textField.placeholder = "Courier Number"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateCourierNumber(packageID: String, shipmentID: String) {
        let type = "courier"
        let value = "\(shipmentID)"
        let parameterDict =  ["user_id":  self.user_details.user_id ?? "", "id": packageID, "type": type, "value": value]
        
        API_updatePackage(parameterDict: parameterDict)
    }
    
    func didClickOnComment(cell: TruckCell) {
        let packageObj = self.packageModel[cell.rowIndex]
        selectedPackage = packageObj
        
        /*
         let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
         let vc = storyboard.instantiateViewController(withIdentifier: "CommentVC") as! CommentVC
         vc.shipmentId = packageObj.id
         self.navigationController?.pushViewController(vc, animated: false)
         */
        self.inputComment(packageID: packageObj.id ?? "", comments: packageObj.text_description ?? "")
    }
    
    func inputComment(packageID: String, comments: String) {
        let alertController = UIAlertController(title: "Update comments", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Update", style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                self.updateComment(packageID: packageID, comments: text)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.text = comments
            textField.placeholder = "Comment"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateComment(packageID: String, comments: String) {
        let type = "comment"
        let value = "\(comments)"
        let parameterDict =  ["user_id":  self.user_details.user_id ?? "", "id": packageID, "type": type, "value": value]
        API_updatePackage(parameterDict: parameterDict)
    }
    
    func API_updatePackage(parameterDict: [String: String], completion: ((Bool) -> Void)? = nil) {
        //RappleActivityIndicatorView.startAnimating()
        ////print(parameterDict)
        
        DashboardManager.API_updatePackage(information: parameterDict) { (json, wsResponse, error) in
            //RappleActivityIndicatorView.stopAnimation()
            if error == nil {
                ////print(json)
                
                if parameterDict["type"] == "courier" {
                    self.callShipAction(shipNumber: parameterDict["value"] ?? "", isActive: 0)
                } else {
                    self.refresNewData()
                }
                
                //                let index = self.inddexOfPackage(packahe: self.selectedPackage)
                //                if index >= 0 {
                //
                //                    var type: OptionPackageEnum = .Track
                //                    if parameterDict["type"] == "comment" {
                //                        type = .Message
                ////                        self.selectedPackage.text_description = parameterDict["value"] ?? ""
                //                    } else if parameterDict["type"] == "courier" {
                //                        type = .Track
                ////                        self.selectedPackage.shipmentId = parameterDict["value"] ?? ""
                //                    }
                //
                //                    if let packageCell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? PackageTableViewCell {
                //
                //                        packageCell.reloadActionOrder(changeType: type) { (isCompleted) in
                //                            self.refresNewData()
                //                        }
                //                    } else {
                //                        self.refresNewData()
                //                    }
                //                } else {
                //                    self.refresNewData()
                //                }
                
            } else {
                
                ////print("API_updatePackage failed")
            }
        }
    }
    
    
    @IBAction func didTapSearchButton(_ sender: Any) {
        if searchButton.tag == 0 {
            searchButton.tag = 1
            searchBar.alpha = 1
        } else {
            searchButton.tag = 0
            searchBar.alpha = 0
            // self.tableView.reloadData()
        }
    }
    
    func onHideProductList(vc: ProductListVC) {
        self.hideProductListView()
    }
    
    //=====================================================================================//
    func refresNewData() {
        API_getPackageByUserId()
        
    }
    
    
    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        
    }
    
    func inddexOfPackage(packahe: PackageModel) -> Int {
        var index = 0
        for packageTemp in packageModel {
            if packageTemp.id == packahe.id {
                return index
            }
            
            index+=1
        }
        
        return -1
    }
    
    func lightboxControllerWillDismiss(_ controller: LightboxController) {
        self.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        let images = [
            LightboxImage(imageURL: URL(string: "https://cdn.arstechnica.net/2011/10/05/iphone4s_sample_apple-4e8c706-intro.jpg")!),
        ]
        
        // Create an instance of LightboxController.
        let controller = LightboxController(images: images)
        
        // Set delegates.
        controller.pageDelegate = self
        controller.dismissalDelegate = self
        
        // Use dynamic background.
        controller.dynamicBackground = true
        // Present your controller.
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil);
    }
    
    func updateR() {
        self.API_getPendingNotificationByUserId()
    }
    
    @objc func notificationReceived() {
        self.API_getPendingNotificationByUserId()
        self.API_getPackageByUserId()
    }
    
    @objc func notificationButtonAction() {
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let vc  = storyboard.instantiateViewController(withIdentifier: "PendingNotificationVC") as! PendingNotificationVC
        self.present(vc, animated: true, completion: nil)
    }
    
    func API_deletePackage(id:String?) {
        RappleActivityIndicatorView.startAnimating()
        let parameterDict =  ["id":  id ?? ""]
        
        DashboardManager.API_deletePackage(information: parameterDict ) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            
            if error == nil {
                self.API_getPackageByUserId(setup: true)
                self.API_getPendingNotificationByUserId()
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func addBlock(_ sender: UIButton) {
        self.tableView.reloadData()
    }
    
    func imageUploadedSuccssfully() {
        self.API_getPackageByUserId(setup: true)
        //        self.API_addimage(packageId: selectedPackage.id)
    }
    
    @objc func share(_ sender: UIButton) {
        "Date to Share".share()
    }
    
    @objc func makeComment(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add new Comments", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                ////print("Text==>" + text)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.placeholder = "Comments"
        }
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func didPressButton(_ tag: Int) {
        ////print("I have pressed a button with a tag: \(tag)")
        
        let myIndexPath = NSIndexPath(row: tag, section: 0)
        let cell = tableView.cellForRow(at: myIndexPath as IndexPath) as! DashboardCell
        if (cell.imgNExt.tag == tag) {
            if (self.selectedImage == tag) {
                cell.imgNExt.image = UIImage(named: "next")
                self.selectedImage = -1
            } else {
                cell.imgNExt.image = UIImage(named: "down-arrow")
                self.selectedImage = tag
            }
        } else {
            self.selectedImage = -1
            cell.imgNExt.image = UIImage(named: "next")
        }
    }
    
    @objc func changeImage(_ sender: UIButton) {
        //let myIndexPath = NSIndexPath(row: sender.tag, section: 0)
        //let cell = tableView.cellForRow(at: myIndexPath as IndexPath) as! DashboardCell
    }
    
    func updateTableView(row: Int) {
        if(selectedIndex == row) {
            selectedIndex = -1
        } else {
            selectedIndex = row
        }
        let path: NSIndexPath = NSIndexPath(row: row, section: 0)
        self.tableView.beginUpdates()
        self.tableView.reloadRows(at: [path as IndexPath], with: UITableView.RowAnimation.none )
        self.tableView.endUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AddNewPackageVC {
            controller.transitioningDelegate = self
            controller.delegate = self
            controller.modalPresentationStyle = .custom
            interactiveTransition.attach(to: controller)
            self.navigationController?.isNavigationBarHidden = true 
        }
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        print("interactionControllerForDismissal")
        return interactiveTransition
    }
    
    @IBAction func clickProfile(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func clickLogo(_ sender: Any) {
        //let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        //let vc = storyboard.instantiateViewController(withIdentifier: "DashboardNewVC") as! DashboardNewVC
        //self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func returnBackFromCommentVC() {
        self.refresNewData()
    }
    
    func returnBackFromGalleryVC() {
        self.refresNewData()
    }
    
    
    func API_addimage(packageId:String?) {
        RappleActivityIndicatorView.startAnimating()
        
        let parameterDict =  ["user_id":  self.user_details.user_id ?? "", "p_id": packageId ?? "", "local": local_Id]
        DashboardManager.API_getPackageGallery(information: parameterDict) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            
            if error == nil {
                ////print(json)
                if json["error"] == 1 {
                    let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "CustomCameraViewController") as! CustomCameraViewController
                    vc.packageId = packageId!
                    vc.delegate = self
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                } else {
                    ////print(json["files"])
                    var filesArray = [String]()
                    for (_, subJson) in json["files"] {
                        ////print(subJson)
                        filesArray.append(subJson.stringValue)
                    }
                    
                    let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "GalleryVC") as! GalleryVC
                    vc.filesArray = filesArray
                    vc.packageId = packageId!
                    vc.modalPresentationStyle = .overFullScreen
                    vc.delegate = self
                    self.present(vc, animated: true, completion: nil)
                }
            } else {
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func API_getPendingNotificationByUserId() {
        pendingNotifications.removeAll()
        //   RappleActivityIndicatorView.startAnimating()
        let parameterDict =  ["user_id":  self.user_details.user_id ?? ""]
        DashboardManager.API_getPendingNotificationByUserId(information: parameterDict ) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            if error == nil {
                pendingNotifications.removeAll()
                for (_, subJson) in json["message"] {
                    let modelList = PackageModel.init(json: subJson)
                    pendingNotifications.append(modelList)
                    //self.notificationButton.badge = String(pendingNotifications.count)
                }
                
                //self.tableView.reloadData()
            }
        }
    }
    
    @objc func sharePopup(sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShareVC") as! ShareVC
        vc.nav = self.navigationController
        vc.shipmentId = String(sender.tag)
        vc.delegate = self
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    @objc func openPopup(sender: UIButton) {
        let buttonPosition:CGPoint = sender.convert(.zero, to: self.tableView)
        let indexPath:IndexPath = self.tableView.indexPathForRow(at: buttonPosition)!
        self.API_shipment_action(lblNumber: String(sender.tag), sender: sender,indexPath: indexPath)
    }
    
    @objc func commentPopup(sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CommentVC") as! CommentVC
        vc.shipmentId = String(sender.tag)
        //self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func API_shipment_action(lblNumber:String,sender: UIButton,indexPath:IndexPath) {
        var imgarr:[UIImage]! = []
        for index in 0...114 {
            //    imgarr.append(UIImage(named: "a\(index)")!)
            imgarr.insert(UIImage(named: "a\(index+1)")!, at: index)
        }
        sender.imageView!.animationImages = imgarr
        sender.imageView!.animationDuration = 3.0
        sender.imageView!.startAnimating()
        
        let cell = self.tableView.cellForRow(at: indexPath) as! DashboardCell
        var imgarrUpdateDeliveryArr:[UIImage]! = []
        let model_data = self.packageModel[indexPath.row]
        var animationTime = 3.0
        
        if( model_data.status! == "DELIVERED" || model_data.status! == "Being Delivered" ) {
            for index in 0...134 {
                //imgarrUpdateDeliveryArr.insert(UIImage(named: String(format: "%.4d",index+1))!, at: index)
                imgarrUpdateDeliveryArr.insert(UIImage(named: "ssss\(index+1)")!, at: index)
                animationTime = 3.7
            }
        } else if(model_data.status! == "AVAILABLE_FOR_DELIVERY"  || model_data.status! == "INDELIVERY" || model_data.status! == "EN_ROUTE" ){
            for index in 0...129 {
                //imgarr.append(UIImage(named: "a\(index)")!)
                imgarrUpdateDeliveryArr.insert(UIImage(named: "sss\(index+1)")!, at: index)
            }
        } else if(model_data.status! == "INTRANSIT" || model_data.status! == "INWAREHOUSE" ){
            for index in 0...130 {
                //    imgarr.append(UIImage(named: "a\(index)")!)
                imgarrUpdateDeliveryArr.insert(UIImage(named: "ss\(index+1)")!, at: index)
            }
        } else {
            for index in 0...121 {
                //    imgarr.append(UIImage(named: "a\(index)")!)
                imgarrUpdateDeliveryArr.insert(UIImage(named: "s\(index+1)")!, at: index)
                animationTime = 2.4
            }
        }
        
        cell.imgStatus.imageView!.animationImages = imgarrUpdateDeliveryArr
        cell.imgStatus.imageView!.animationDuration = animationTime
        cell.imgStatus.imageView!.startAnimating()
        cell.lblUpdateText.text = "Updating"
        
        let user_details = UserModel.sharedInstance
        //RappleActivityIndicatorView.startAnimating()
        let parameterDict =  [
            "user_id":  user_details.user_id ?? "",
            "shipmentId": lblNumber ,
            "status": "1"
        ]
        
        DashboardManager.API_shipment_action(information: parameterDict) { (json, wsResponse, error) in
            //  RappleActivityIndicatorView.stopAnimation()
            sleep(UInt32(2.9))
            sender.imageView!.stopAnimating()
            cell.imgStatus.imageView!.startAnimating()
            //imageView1.image = imageArray.last
            cell.lblUpdateText.text = "Opdater"
            self.tableView.reloadData()
            if error == nil{
                if(json["status"]==true) {
                    self.API_getPackageByUserId()
                    // sender.imageView!.stopAnimating()
                }else{
                    self.API_getPackageByUserId()
                    //sender.imageView!.stopAnimating()
                    //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: json["message"].stringValue)
                }
            } else {
                self.API_getPackageByUserId()
            }
        }
    }
    
    @objc func openPopupSection(sender: UIButton) {
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopupVC") as! PopupVC
        vc.package_id = String(sender.tag)
        vc.delegets = self
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func getSuccessMessage() {
        self.API_getPackageByUserId()
    }
    
    @IBAction func clickAddPackage(_ sender: Any) {
        navigateToAddNewPackages()
    }
    
    @IBAction func clickAddNewPackage(_ sender: Any) {
        navigateToAddNewPackages()
    }
    
    func didToggleRadioButton(_ indexPath: IndexPath) {
        //let room_data = self.packageModel[indexPath.section]
        selectedElement.insert(indexPath.row, at: 0)
    }
    
    //MARK: Image Changing Logic on tap
    @objc func packageImageViewTapped(_ sender: UIButton) {
        let searchLogoVC = SearchLogoViewController()
        searchLogoVC.package = self.packageModel[sender.tag]
        self.navigationController?.pushViewController(searchLogoVC, animated: true)
    }
    
    func navigateToAddNewPackages() {
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddNewPackageVC") as! AddNewPackageVC
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: false)
    }
}

//MARK: - Setup UI
extension DashboardMainVC {
    
    private func setupPickerView() {
        addChild(pickerViewController)
        pickerViewController.delegate = self
    }
}

//MARK: - Private Method
extension DashboardMainVC {
    
    private func loadMore() {
        
    }
    
    private func showPickerView() {
        view.addSubview(pickerViewController.view)
        pickerViewController.view.frame = view.bounds
    }
    
    private func showPackageExtend(row: Int, mode: PackageExtendMode) {
        
        let package = packageModel[row]
        packageShowExtendLog.0.row = row
        packageShowExtendLog.1 = mode
        packageShowExtendLog.2 = false
        
        switch mode {
        case .Warranty:
            
            packageShowExtendLog.3 = package.waranty_months - 1
            packageShowExtendLog.4 = package.w_notification_days
            packageShowExtendLog.5 = (package.setNotificationWarrantyDay.lowercased() == "on" ? true : false)
            break
            
        case .ReturnDate:
            
            packageShowExtendLog.3 = package.return_days
            packageShowExtendLog.4 = package.notification_days
            packageShowExtendLog.5 = (package.setNotificationReturnDay.lowercased() == "on" ? true : false)
            break
            
        case .PriceMatch:
            
            packageShowExtendLog.3 = package.priceMatchDay
            packageShowExtendLog.4 = package.priceMatchNotificationDay
            packageShowExtendLog.5 = (package.setNotificationPriceMatchDay.lowercased() == "on" ? true : false)
            break
            
        case .TraceAndTruck:
            break
            
        case .Comments:
            break
            
        default:
            break
        }
        
        if let cell = self.tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? PackageTableViewCell {
            cell.extendMode = self.packageShowExtendLog.1
        }
        
        isExplaned = true
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        isExplaned = false
    }
    
    private func hiddenPackageExtend(row: Int) {
        
        self.tableview_scoll_index = row
        resetExtendPackageLog()
        
        if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) as? PackageTableViewCell {
            cell.model = self.packageModel[row]
            cell.extendMode = packageShowExtendLog.1
        }
        
        isExplaned = true
        tableView.beginUpdates()
        tableView.reloadRows(at: [IndexPath(row: row, section: 0)], with: .none)
        tableView.endUpdates()
        isExplaned = false
    }
    
    private func resetExtendPackageLog() {
        packageShowExtendLog = (IndexPath(row: -1, section: 0), PackageExtendMode.None, false, 0, 0, false)
    }
    
    private func inputShopName(packageID: String, name: String) {
        let alertController = UIAlertController(title: "Update name", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Update", style: .default) { (_) in
            if let txtField = alertController.textFields?.first, let text = txtField.text {
                self.updateName(packageID: packageID, name: text)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        alertController.addTextField { (textField) in
            textField.text = name
            textField.placeholder = "Name"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    private func updateName(packageID: String, name: String) {
        let type = "name"
        let value = "\(name)"
        let parameterDict =  ["user_id": user_details.user_id ?? "", "id": packageID, "type": type, "value": value]
        
        API_updatePackage(parameterDict: parameterDict)
    }
    
    private func updateDate(packageID: String, date: String) {
        let type = "purchase_date"
        let value = "\(date)"
        let parameterDict =  ["user_id": user_details.user_id ?? "", "id": packageID, "type": type, "value": value]
        
        API_updatePackage(parameterDict: parameterDict)
    }
}

//MARK: - API Method
extension DashboardMainVC {
    
    func API_updatePackageExtend(leftNumber: Int, rightNumber: Int, isNotification: Bool, atIndex: Int, mode: PackageExtendMode) {
        
        let package = self.packageModel[atIndex]
        var modeParam = ""
        var leftNumberValue = leftNumber
        
        switch mode {
        case .Warranty:
            modeParam = "waranty_all"
            leftNumberValue = leftNumber + 1
            break
        case .ReturnDate:
            modeParam = "return_all"
            break
        case .PriceMatch:
            modeParam = "pricematch_all"
            break
        default:
            break
        }
        
        let parameterDict =  ["user_id":  package.user_id ?? "", "id": package.id ?? "", "type": modeParam, "value": "\(leftNumberValue)", "notification": "\(rightNumber)", "status": "\(isNotification == true ? "on" : "off")"]
        
        ////print(parameterDict)
        
        RappleActivityIndicatorView.startAnimating()
        DashboardManager.API_updatePackage(information: parameterDict) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            
            if error == nil {
                ////print(json)
                
                switch mode {
                case .Warranty:
                    package.waranty_months = leftNumber + 1
                    package.w_notification_days = rightNumber
                    package.setNotificationWarrantyDay = (isNotification == true ? "on" : "off")
                    break
                case .ReturnDate:
                    package.return_days = leftNumber
                    package.notification_days = rightNumber
                    package.setNotificationReturnDay = (isNotification == true ? "on" : "off")
                    break
                case .PriceMatch:
                    package.priceMatchDay = leftNumber
                    package.priceMatchNotificationDay = rightNumber
                    package.setNotificationPriceMatchDay = (isNotification == true ? "on" : "off")
                    break
                default:
                    break
                }
                
                self.packageShowExtendLog.2 = false
                self.tableView.reloadRows(at: [IndexPath(row: atIndex, section: 0)], with: .none)
            } else {
                ////print("API_updatePackage failed")
            }
        }
    }
}

//MARK: - UISearchBarDelegate
extension DashboardMainVC: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        
        if searchText.isEmpty {
            packageModel = dataList
            
            collectionview
                .reloadData()
        } else {
            searhShopName(text: searchText)
        }
        
        view.endEditing(true)
    }
    
    func searhShopName(text: String) {
        packageModel = dataList.filter({ (model) -> Bool in
            return model.title.lowercased().contains(text.lowercased())
        })
        
        collectionview.reloadData()
    }
}

//MARK: - UITableViewDelegate
extension DashboardMainVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
    }
    
    
}

//MARK: - PackageTableViewCellDelegate
extension DashboardMainVC: ActionPackageDelegate {
    
    func didTapShareUseButton(atIndex: IndexPath) {
        hiddenPackageExtend(row: atIndex.row)
        let packageObj = packageModel[atIndex.row]
        
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        
        let vc = storyboard.instantiateViewController(withIdentifier: "PackageShareVC") as! PackageShareVC
        vc.shipmentId = packageObj.id
        
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    
    func didTapCloseInfoWarrantyButton(atIndex: IndexPath) {
        hiddenPackageExtend(row: atIndex.row)
    }
    
    func didTapShopNameLabel(text: String) {
        searchBar.text = text
        searchBar.alpha = 1
        searchButton.tag = 1
        
        searhShopName(text: text)
    }
    
    func didTapRefeshButton(atIndex: IndexPath) {
        
        let package = packageModel[atIndex.row]
        //RappleActivityIndicatorView.startAnimating()
        
        callShipAction(shipNumber: package.id ?? "", isActive: 1)
    }
    
    
    func callShipAction(shipNumber: String, isActive: Int) {
        RappleActivityIndicatorView.startAnimating()
        let user_details = UserModel.sharedInstance
        
        let parameterDict =  [
            "user_id":  user_details.user_id ?? "",
            "shipmentId": shipNumber ,
            "status": "\(isActive)"
        ]
        
        ////print(parameterDict)
        DashboardManager.API_shipment_action(information: parameterDict) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            ////print(json)
            if error == nil{
                if(json["status"]==true) {
                    self.API_getPackageByUserId()
                    // sender.imageView!.stopAnimating()
                }else{
                    self.showAlertController(title: "", message: json["message"].stringValue )
                    //                    self.API_getPackageByUserId()
                    //sender.imageView!.stopAnimating()
                    //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: json["message"].stringValue)
                }
            } else {
                //                self.API_getPackageByUserId()
            }
        }
    }
    
    func didTapTrackInfoButton(atIndex: IndexPath) {
        
        if packageShowExtendLog.0.row == atIndex.row && packageShowExtendLog.1 == .TraceAndTruck {
            hiddenPackageExtend(row: atIndex.row)
        } else {
            if packageShowExtendLog.1 != .None && packageShowExtendLog.0.row >= 0 {
                hiddenPackageExtend(row: packageShowExtendLog.0.row)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self.showPackageExtend(row: atIndex.row, mode: .TraceAndTruck)
                }
            } else {
                showPackageExtend(row: atIndex.row, mode: .TraceAndTruck)
            }
        }
    }
    
    func didTapMoreButton(atIndex: IndexPath) {
        let optionMenu = UIAlertController(title: nil, message: "Update information shop", preferredStyle: .actionSheet)
        
        let saveAction = UIAlertAction(title: "Edit name", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            self.dismiss(animated: true, completion: nil)
            
            let packageObj = self.packageModel[atIndex.row]
            self.selectedPackage = packageObj
            
            self.inputShopName(packageID: packageObj.id ?? "", name: packageObj.title ?? "")
        })
        
        let deleteAction = UIAlertAction(title: "Edit date", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            self.dismiss(animated: true, completion: nil)
            DatePickerDialog().show("Buy Day", doneButtonTitle: "OK", cancelButtonTitle: "Cancel", datePickerMode: .date) {
                (date) -> Void in
                if let dt = date {
                    
                    let packageObj = self.packageModel[atIndex.row]
                    self.selectedPackage = packageObj
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy:MM:dd"
                    self.updateDate(packageID: packageObj.id ?? "", date: formatter.string(from: dt))
                }
            }
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        
        present(optionMenu, animated: true, completion: nil)
    }
    
    func didTapLoadMoreButton() {
        RappleActivityIndicatorView.startAnimating()

        //var packageListMore: [PackageModel] = []
       // if ( dataList.count - packageModel.count ) >= MAX_PACKAGE_PER_LOAD {
        //    packageListMore = Array(dataList[packageModel.count...(packageModel.count + MAX_PACKAGE_PER_LOAD - 1)])
       // } else if ( dataList.count - packageModel.count ) == 0 {
       // } else {
        //    packageListMore = Array(dataList[packageModel.count...(dataList.count - 1)])
      //  }
        
        //packageModel.append(contentsOf: packageListMore)
        
        
        
        if self.dataList.count >= MAX_PACKAGE_PER_LOAD {
            loadmoreBtn.isHidden = false

            MAX_PACKAGE_PER_LOAD = MAX_PACKAGE_PER_LOAD + 21
       
            //a check to check the value not exceding
            if(MAX_PACKAGE_PER_LOAD >= self.dataList.count){MAX_PACKAGE_PER_LOAD = self.dataList.count
                
                loadmoreBtn.isHidden = true
            }
            
            self.packageModel = Array(self.dataList[0...(MAX_PACKAGE_PER_LOAD - 1)])
        } else {
       self.packageModel = self.dataList
            loadmoreBtn.isHidden = true
       }
        
        self.collectionview.reloadData()
        self.collectionviewmiddle.reloadData()
        self.collectionviewfirst.reloadData()
        isloadmorerunning = false
        //loadmoreBtn.setTitle("Load More", for: .normal)
        RappleActivityIndicatorView.stopAnimation()

    }
    
    func didTapCloseInfoBarButton(atIndex: IndexPath) {
        
        let alert = UIAlertController(title: "Are you sure ?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            
        }))
        alert.addAction(UIAlertAction.init(title: "No", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    func didTapSaveButton(atIndex: IndexPath) {
        API_updatePackageExtend(leftNumber: packageShowExtendLog.3, rightNumber: packageShowExtendLog.4, isNotification: packageShowExtendLog.5, atIndex: atIndex.row, mode: packageShowExtendLog.1)
    }
    
    func didTapCloseButton(atIndex: IndexPath) {
        hiddenPackageExtend(row: atIndex.row)
    }
    
    func didTapSwitchButton(atIndex: IndexPath) {
        
        packageShowExtendLog.2 = true
        packageShowExtendLog.5 = !packageShowExtendLog.5
        
        tableView.reloadRows(at: [atIndex], with: .none)
    }
    
    
    func didTapBoxNumber(atIndex: IndexPath, mode: PackageExtendMode) {
        
        let package = packageModel[atIndex.row]
        showPickerView()
        pickerViewController.extendMode = (atIndex, mode)
        
        if mode == .Warranty {
            pickerViewController.setRange(from: 1, to: 25, ofLeft: true)
            pickerViewController.setRange(from: 0, to: 100, ofLeft: false)
            pickerViewController.setInitValue(leftIndex: package.waranty_months - 1, rightIndex: package.w_notification_days)
        } else if mode == .ReturnDate {
            pickerViewController.setRange(from: 0, to: 100, ofLeft: true)
            pickerViewController.setRange(from: 0, to: 100, ofLeft: false)
            pickerViewController.setInitValue(leftIndex: package.return_days, rightIndex: package.notification_days)
        } else if mode == .PriceMatch {
            pickerViewController.setRange(from: 0, to: 100, ofLeft: true)
            pickerViewController.setRange(from: 0, to: 100, ofLeft: false)
            pickerViewController.setInitValue(leftIndex: package.priceMatchDay, rightIndex: package.priceMatchNotificationDay)
        } else {
            return
        }
    }
    
    func didTapPriceMatchButton(atIndex: IndexPath) {
        
        if packageShowExtendLog.0.row == atIndex.row && packageShowExtendLog.1 == .PriceMatch {
            hiddenPackageExtend(row: atIndex.row)
        } else {
            if packageShowExtendLog.1 != .None && packageShowExtendLog.0.row >= 0 {
                hiddenPackageExtend(row: packageShowExtendLog.0.row)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self.showPackageExtend(row: atIndex.row, mode: .PriceMatch)
                }
            } else {
                showPackageExtend(row: atIndex.row, mode: .PriceMatch)
            }
        }
    }
    
    func didTapReturnDateButton(atIndex: IndexPath) {
        
        if packageShowExtendLog.0.row == atIndex.row && packageShowExtendLog.1 == .ReturnDate {
            hiddenPackageExtend(row: atIndex.row)
        } else {
            if packageShowExtendLog.1 != .None && packageShowExtendLog.0.row >= 0 {
                hiddenPackageExtend(row: packageShowExtendLog.0.row)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self.showPackageExtend(row: atIndex.row, mode: .ReturnDate)
                }
            } else {
                showPackageExtend(row: atIndex.row, mode: .ReturnDate)
            }
        }
    }
    
    func didTapTakePhotoButton(atIndex: IndexPath) {
        
        hiddenPackageExtend(row: atIndex.row)
        
        let packageObj = packageModel[atIndex.row]
        selectedPackage = packageObj
        
        API_addimage(packageId: packageObj.id)
    }
    
    func didTapShareButton(atIndex: IndexPath) {
        
        hiddenPackageExtend(row: atIndex.row)
        
        
        //        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        //        let vc = storyboard.instantiateViewController(withIdentifier: "InviteViewController") as! InviteViewController
        //        self.navigationController?.pushViewController(vc, animated: true)
        let packageObj = packageModel[atIndex.row]
        "\(packageObj.title) - \(packageObj.text_description)".share()
    }
    
    func didTapMessageButton(atIndex: IndexPath) {
        let packageObj = packageModel[atIndex.row]
        selectedPackage = packageObj
        
        if packageShowExtendLog.0.row == atIndex.row && packageShowExtendLog.1 == .Comments {
            strTxtComments = "Please enter comment"
            self.commentModel = []
            hiddenPackageExtend(row: atIndex.row)
        } else {
            showComments(selectedRow: atIndex.row) { (success) in
                if self.packageShowExtendLog.1 != .None && self.packageShowExtendLog.0.row >= 0 {
                    self.hiddenPackageExtend(row: self.packageShowExtendLog.0.row)
                    
                    //                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self.showPackageExtend(row: atIndex.row, mode: .Comments)
                    //                    }
                } else {
                    self.showPackageExtend(row: atIndex.row, mode: .Comments)
                }
                self.tableView.reloadRows(at: [atIndex], with: .none)
            }
        }
    }
    
    func didTapTraceButton(atIndex: IndexPath) {
        
        hiddenPackageExtend(row: atIndex.row)
        
        let packageObj = packageModel[atIndex.row]
        selectedPackage = packageObj
        
        inputCourierNumber(packageID: packageObj.id ?? "", shipmentID: packageObj.shipmentId )
    }
    
    
    func didTapWarrantyButton(atIndex: IndexPath) {
        
        if packageShowExtendLog.0.row == atIndex.row && packageShowExtendLog.1 == .Warranty {
            hiddenPackageExtend(row: atIndex.row)
        } else {
            if packageShowExtendLog.1 != .None && packageShowExtendLog.0.row >= 0 {
                hiddenPackageExtend(row: packageShowExtendLog.0.row)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    self.showPackageExtend(row: atIndex.row, mode: .Warranty)
                }
            } else {
                showPackageExtend(row: atIndex.row, mode: .Warranty)
            }
        }
    }
    
   
    
}

//MARK: - PickerVCDelegate
extension DashboardMainVC: PickerVCDelegate {
    
    func didSelectedAtIndexes(leftIndex: Int, rightIndex: Int, extendMode: (IndexPath, PackageExtendMode)) {
        
        packageShowExtendLog.2 = true
        packageShowExtendLog.3 = leftIndex
        packageShowExtendLog.4 = rightIndex
        
        tableView.reloadRows(at: [extendMode.0], with: .none)
    }
}

extension DashboardMainVC {
    func swipeGestureActivateCamera() {
        //        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        //        edgePan.edges = .left
        //        self.view.addGestureRecognizer(edgePan)
    }
    
    @objc func respondToCameraSwipeGesture(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        //print("Screen edge swiped!")
        didTapTakePhotoButton(atIndex: IndexPath(item: 0, section: 0))
    }
}

// Add comments
extension DashboardMainVC {
    
    func shouldChangeCommentsAtIndex(indexPath: IndexPath, strComments: String) {
        //print("strComments\(strComments)")
        strTxtComments = strComments
    }
    
    @IBAction func didTappedSendButtons(_ sender: UIButton) {
        if strTxtComments != DashboardMainVC.txtPlaceholderText {
            addComments(selectedRow: sender.tag)
        }
    }
    
    func addComments(selectedRow: Int) {
        if packageModel.count > selectedRow {
            let packageObj = packageModel[selectedRow]
            selectedPackage = packageObj
            let user_details = UserModel.sharedInstance
            RappleActivityIndicatorView.startAnimating()
            let parameterDict =  [
                "user_id": user_details.user_id ?? "",
                "shipmentId": packageObj.id ?? "",
                "comment": strTxtComments
            ]
            DashboardManager.API_add_comment(information: parameterDict) { (json, wsResponse, error) in
                RappleActivityIndicatorView.stopAnimation()
                if error==nil{
                    if(json["status"]==true){
                        self.showComments(selectedRow: selectedRow) { (success) in
                            if success {
                                DispatchQueue.main.async {
                                    self.tableView.reloadRows(at: [IndexPath(row: selectedRow, section: 0)], with: .none)
                                }
                            }
                        }
                    } else {
                        self.showAlertController(title: "", message: json["message"].stringValue)
                    }
                }
            }
        }
    }
    func showComments(selectedRow: Int, onComplete: @escaping(_ success: Bool) -> Void ){
        if packageModel.count > selectedRow {
            let packageObj = packageModel[selectedRow]
            strTxtComments = DashboardMainVC.txtPlaceholderText
            self.commentModel.removeAll()
            self.datesModel.removeAll()
            let user_details = UserModel.sharedInstance
            RappleActivityIndicatorView.startAnimating()
            let parameterDict =  [
                "user_id":  user_details.user_id ?? "",
                "shipmentId": packageObj.id ?? ""
            ]
            DashboardManager.API_show_comments(information: parameterDict) { (json, wsResponse, error) in
                RappleActivityIndicatorView.stopAnimation()
                let successStatus = json["status"]
                if error==nil, successStatus.boolValue == true {
                    for (_, subJson) in json["data"] {
                        let modelList = CommentModel.init(json: subJson)
                        if let createddate = modelList.created_at, !(self.datesModel.contains(createddate)) {
                            self.datesModel.append(createddate)
                        }
                        self.commentModel.append(modelList)
                    }
                    onComplete(self.commentModel.count>0)
                    return
                } else {
                    onComplete(false)
                    self.showAlertController(title: "", message: json["message"].stringValue)
                    return
                }
            }
        }
    }
}


extension DashboardMainVC :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == collectionviewfirst
        {
            let packages = self.packageModel.filter { (model) -> Bool in
                
                if(model.setTrackTrace == "on")
                {
                    if (model.shipmentId != "")
                    {
                        if( model.status! != "DELIVERED")
                        {
                            return true
                        }else
                        {
                            return false
                        }
                    }else
                    {
                        return false
                    }
                }else
                {
                    return false
                }
            };
            
            if (packages.count == 0)
            {
                self.view_collectionviewfirst.isHidden = true
                self.line1.isHidden = true
            }else
            {
                self.view_collectionviewfirst.isHidden = false
                self.line1.isHidden = false
            }
            firstviewcount = packages.count
            return packages.count
        }
        else if (collectionView == collectionviewmiddle)
        {
            
            let packages = self.packageModel.filter { (model) -> Bool in
                
                if(model.setNotificationReturnDay == "on" && (model.getNotificationReturnDay() == 0 || model.getNotificationReturnDay() < 0))
                {
                    return true
                }else if(model.setNotificationWarrantyDay == "on" && (model.getNotificationWarrantyDay() == 0 || model.getNotificationWarrantyDay() < 0 ))
                {
                    //print(model.getNotificationWarrantyDay())
                    return true
                }else if(model.setNotificationPriceMatchDay == "on" && (model.getNotificationPriceMatchDay() == 0 || model.getNotificationPriceMatchDay() < 0 ))
                {
                    //print(model.getNotificationWarrantyDay())
                    return true
                }else
                {
                    return false
                }
                
            };
            
            if (packages.count == 0)
            {
                //self.view_collectionviewfirst.isHidden = true
                
                //raminde edited
                self.view_collectionviewsScond.isHidden = true
                self.line2.isHidden = true

            }else
            {
                //self.view_collectionviewfirst.isHidden = false
                
                //raminde edited
                self.view_collectionviewsScond.isHidden = false
                self.line2.isHidden = false

            }
            
            secondviewcount = packages.count
            return packages.count
        }
        else
        {
            
            if (packageModel.count == 0)
            {
                
                print("NOs of package:0")
                addboxesTitle.text = ""
            }else
            {
               
                print("NOs of package:more than zero")
                addboxesTitle.text = "Købt"

            }
            return self.packageModel.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == self.collectionview)
        {
            let cell : DashboardCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCollectionViewCell", for: indexPath as IndexPath) as! DashboardCollectionViewCell
            
            let details = self.packageModel[indexPath.row]
          
            print(details.notified)
            if(details.notified == "no"){
                
                print(details)

            showAlertMsg(showalert:"yes")
               singlePackageDetail = self.packageModel[indexPath.row]
            }
            if (details.imageUrls.count > 0)
            {
                cell.img_images.sd_setImage(with: URL(string: NetworkingConstants.baseURL + details.imageUrlsThumbs[0]), completed: nil)
                print("setting image \(details.imageUrlsThumbs[0])")
                for imageUrl in details.imageUrls{
                    if imageUrl == ""
                    {
                        continue
                    }
                    if imageUrl.contains(details.Default_image!) == true
                    {
                       cell.img_images.sd_setImage(with: URL(string: NetworkingConstants.baseURL + imageUrl), completed: nil)
                        break
                    }
                }
                
            }else
            {
                cell.img_images.image = UIImage(named: "placeholder")
            }
            cell.img_images.contentMode = .scaleAspectFill
            
            if (details.defaultUrl != "/webshop.png")
            {
                cell.img_logo.sd_setImage(with: URL(string: NetworkingConstants.baseURL + details.defaultUrl!)) { (image, error, type, url) in
                }
                cell.img_logo.backgroundColor = .white
                cell.view_backGroundShopName.backgroundColor = .white
                
            }else
            {
                cell.img_logo.image = cell.img_logo?.getPlaceHolderImage(text: details.title == "" ? "Shop" : details.title)
                cell.img_logo.backgroundColor = .clear
                cell.view_backGroundShopName.backgroundColor = UIColor(red: 0.30, green: 0.60, blue: 0.16, alpha: 1.00)
                
            }
            if(details.sharedbyuser == "Yes"){
            cell.shared_icon.isHidden = false
            cell.shared_icon_view.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
            }
            if(details.sharedbyuser == "Shared"){
             cell.shared_icon.isHidden = false
            cell.shared_icon_view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
               // cell.shared_icon.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            }
            
            if(details.sharedbyuser == "No"){
                cell.shared_icon.isHidden = true
                cell.shared_icon_view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)


            }
           // cell.shared_icon_view.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
            //cell.shared_icon_view.backgroundColor = UIColor.brown
            //cell.shared_icon_view.isHidden = true
            //added by raminde
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.dateFormat = "dd/MM-yy"
            
            let frmdate = formatter.string(from: Date(details.created_at)!)
            cell.lbl_date.text = "\(frmdate)"
            //added by raminde ends
            
            //cell.lbl_date.text = "\(details.created_at)"
            
            cell.lbl_title.text = details.title == "" ? "webshop" : details.title
            
            return cell
        }
            
        else if (collectionView == collectionviewfirst)
        {
            
            let cell : DashboardFirstCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardFirstCollectionViewCell", for: indexPath as IndexPath) as! DashboardFirstCollectionViewCell
            
            let packages = self.packageModel.filter { (model) -> Bool in
                
                if(model.setTrackTrace == "on")
                {
                    if (model.shipmentId != "")
                    {
                        if( model.status! != "DELIVERED")
                        {
                            return true
                        }else
                        {
                            return false
                        }
                    }else
                    {
                        return false
                    }
                }else
                {
                    return false
                }
            };
            
            let details = packages[indexPath.row]
            
            
            if (details.defaultUrl != "/webshop.png")
            {
                cell.img_first.sd_setImage(with: URL(string: NetworkingConstants.baseURL + details.defaultUrl!)) { (image, error, type, url) in
                }
                cell.img_first.backgroundColor = .white
                cell.view_backGroundShopName.backgroundColor = .white
                
            }else
            {
                cell.img_first.image = cell.img_first?.getPlaceHolderImage(text: details.title == "" ? "Shop" : details.title)
                cell.img_first.backgroundColor = .clear
                cell.view_backGroundShopName.backgroundColor = UIColor(red: 0.30, green: 0.60, blue: 0.16, alpha: 1.00)
                
            }
            
            
            
            
            
            
            cell.lbl_title.text = details.title == "" ? "webshop" : details.title
            
            return cell
            
        }
        else
        {
            let cell : DashboardFirstCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardFirstCollectionViewCell", for: indexPath as IndexPath) as! DashboardFirstCollectionViewCell
            
            let packages = self.packageModel.filter { (model) -> Bool in
                
                if(model.setNotificationReturnDay == "on" && (model.getNotificationReturnDay() == 0 || model.getNotificationReturnDay() < 0))
                {
                    return true
                }else if(model.setNotificationWarrantyDay == "on" && (model.getNotificationWarrantyDay() == 0 || model.getNotificationWarrantyDay() < 0 ))
                {
                    //print(model.getNotificationWarrantyDay())
                    return true
                }else if(model.setNotificationPriceMatchDay == "on" && (model.getNotificationPriceMatchDay() == 0 || model.getNotificationPriceMatchDay() < 0 ))
                {
                    //print(model.getNotificationWarrantyDay())
                    return true
                }else
                {
                    return false
                }
                
            };
            
            
            let details = packages[indexPath.row]
            
            
            if (details.defaultUrl != "/webshop.png")
            {
                cell.img_first.sd_setImage(with: URL(string: NetworkingConstants.baseURL + details.defaultUrl!)) { (image, error, type, url) in
                }
                cell.img_first.backgroundColor = .white
                cell.view_backGroundShopName.backgroundColor = .white
                
                
            }else
            {
                cell.img_first.image = cell.img_first?.getPlaceHolderImage(text: details.title == "" ? "Shop" : details.title)
                cell.img_first.backgroundColor = .clear
                cell.view_backGroundShopName.backgroundColor = UIColor(red: 0.30, green: 0.60, blue: 0.16, alpha: 1.00)
                
            }
            
            
            cell.lbl_title.text = details.title == "" ? "webshop" : details.title
            return cell
            
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
        if (collectionView == self.collectionview)
        {
            return 0;
        }
        else if (collectionView == collectionviewfirst)
        {
            return 0;
        }
        else
        {
            return 0;
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
    {
        
        if (collectionView == self.collectionview)
        {
            return 0;
        }
        else if (collectionView == collectionviewfirst)
        {
            return 10;
        }
            
        else {
            return 10;
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        
        if (collectionView == self.collectionview)
        {
            return CGSize(width: (((collectionView.frame.width ) / 3 )  - 2) , height: 250)
        }
        else if (collectionView == collectionviewfirst)
        {
            return CGSize(width: 84 , height: 100)
        }
        else
        {
            return CGSize(width: 84 , height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

       // self.navigationController?.isNavigationBarHidden = true
        
        let storyboard = UIStoryboard.init(name: "NewBoard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailScreenViewController") as! DetailScreenViewController
        
        
        if collectionView == collectionviewfirst
        {
            let packages = self.packageModel.filter { (model) -> Bool in
                
                if(model.setTrackTrace == "on")
                {
                    if (model.shipmentId != "")
                    {
                        if( model.status! != "DELIVERED")
                        {
                            return true
                        }else
                        {
                            return false
                        }
                    }else
                    {
                        return false
                    }
                }else
                {
                    return false
                }
            };
            
            vc.singlePackageDetail = packages[indexPath.row]
            
            
        }
        else if (collectionView == collectionviewmiddle)
        {
            
            
            let packages = self.packageModel.filter { (model) -> Bool in
                
                if(model.setNotificationReturnDay == "on" && (model.getNotificationReturnDay() == 0 || model.getNotificationReturnDay() < 0))
                {
                    return true
                }else if(model.setNotificationWarrantyDay == "on" && (model.getNotificationWarrantyDay() == 0 || model.getNotificationWarrantyDay() < 0 ))
                {
                    //print(model.getNotificationWarrantyDay())
                    return true
                }else if(model.setNotificationPriceMatchDay == "on" && (model.getNotificationPriceMatchDay() == 0 || model.getNotificationPriceMatchDay() < 0 ))
                {
                    //print(model.getNotificationWarrantyDay())
                    return true
                }else
                {
                    return false
                }
                
            };
            
            
            vc.singlePackageDetail = packages[indexPath.row]
            print(packages[indexPath.row] , "didsetdata")
        }
        else
        {
            vc.singlePackageDetail = self.packageModel[indexPath.row]
            vc.singlePackageDetail2 = self.packageModel[indexPath.row]

            print("check1 -original")
            print(vc.singlePackageDetail.id)
            vc.testid = vc.singlePackageDetail.id!
            let filterData = self.dataList.filter { (model) -> Bool in
            
                  if(model.title == vc.singlePackageDetail.title)
                  {
                      return true
                  }else
                  {
                    return false
                }
                  
              };
            
            //raminde removed this -- why we neeed this
       //     for packageDetail in filterData{
         //       if packageDetail.imageUrls == nil || packageDetail.imageUrls.count == 0
         //       {
          //          continue;
          //      }
            //    if packageDetail.imageUrls[0].contains(vc.singlePackageDetail.Default_image!) == true
           //     {
           //        vc.singlePackageDetail = packageDetail
            //        print("check1-nnooo")
            //        print(packageDetail)
             //       break;
             //   }
          //  }
            print(packageModel[indexPath.row].id,"packageModel[indexPath.row]")
        
        }
        vc.packageModel = self.dataList
        vc.homeSearchDelegate = self
        self.navigationController?.isNavigationBarHidden = true
       
        vc.context = self
        self.navigationController?.delegate = self
       
        if let cell = collectionView.cellForItem(at: indexPath) as? DashboardCollectionViewCell {
            GLOBAL_IMG = cell.img_images
            GLOBAL_IMG2 = cell.img_images
            let rowofcell = Float(indexPath.row/3)
            //let topareaoffset = 352
//            let topareaoffset = 100
 //           let topareaoffset = 221
           var topareaoffset = 127
            if(view_collectionviewfirst.isHidden == false){topareaoffset = topareaoffset + 136}
            if(view_collectionviewsScond.isHidden == false){topareaoffset = topareaoffset + 136}
            Y = Int(floor(rowofcell)) * 250 + topareaoffset
           // Y = 100
            Y = Int(floor(cell.frame.origin.y))  + topareaoffset

            print("y-axis:\(Y) - \(rowofcell)- \(cell.frame.height)- \(cell.frame.origin.y)")
           // let frame = contentScrollView.convert(cell.frame, from:cell)
            //print(frame)
           // Y = Int(frame.minY)
            print(Y)

        }
        if let cell = collectionView.cellForItem(at: indexPath) as? DashboardFirstCollectionViewCell {
            GLOBAL_IMG = cell.img_first
            GLOBAL_IMG2 = cell.img_first
            Y = indexPath.row
            

print("y-axis:\(Y)")
        }

        pr1 = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
       // imageUploadedSuccssfully()
    }
}






extension DashboardMainVC : detailHomeScreenSerch
{
    func detailHomeScreenSearch(keyword: String) {
        self.contentScrollView.setContentOffset(.zero, animated:true)
        fromDetailScreen = true
        self.searchBar.isHidden = false
        self.searchBar.text = keyword
        searhShopName(text: keyword)
    }
    
    
}


//MARK: Custom transition
extension DashboardMainVC : UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("zoom: Dashboard")
        var trans = HDZoomAnimatedTransitioning()
        if(GLOBAL_IMG == nil){
            return nil;}
        trans.transitOriginalView = GLOBAL_IMG!
        trans.isPresentation = pr1;
        // trans = nil

        return trans;
    }
}

