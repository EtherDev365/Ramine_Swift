//
//  DashboardNewVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import RappleProgressHUD
import SwiftyJSON
import JKNotificationPanel
import Nuke
import BubbleTransition
import Lightbox


class DashboardNewVC: UIViewController,UITableViewDelegate,UITableViewDataSource,CustomCellDelegate,UIViewControllerTransitioningDelegate,refreshData,UIGestureRecognizerDelegate,refreshDataMessageDelegets,YourCellDelegate,PopupCellDelegate,updateRequirement,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,LightboxControllerPageDelegate,LightboxControllerDismissalDelegate, CustomCameraVCDelegate {
    
    var navVC: UINavigationController?
    var photomanager:BWPhotoManager!
    var im_staus = 0
    
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
    let pannel = JKNotificationPanel()
    var packageModel = [PackageModel]()
    let user_details = UserModel.sharedInstance
    var selectedPackage:PackageModel!
    
    @IBOutlet var notificationButton: SSBadgeButton!
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var btnSearch: UIButton!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var presentControllerButton: UIButton!
    @IBOutlet weak var btnLogoView: UIButton!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var imgUserView: UIImageView!
    @IBOutlet var tblMain: UITableView!

    var selectedIndex = -1
    let transition = BubbleTransition()
    let interactiveTransition = BubbleInteractiveTransition()
    
    func refresNewData() {
        self.API_getPackageByUserId()
    }

    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        
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

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tblMain.rowHeight = UITableView.automaticDimension
        self.tblMain.estimatedRowHeight = 230
        self.notificationButton.badgeBackgroundColor = UIColor.red
        notificationButton.addTarget(self, action: #selector(self.notificationButtonAction), for: .touchUpInside)
        notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 4)
        self.tblMain.separatorStyle = .none
        self.navigationController?.navigationBar.isHidden = true
        selectedElement.insert(-1, at: 0)
        self.btnSearch.layer.cornerRadius = 7
        self.btnAdd.layer.cornerRadius = 7
        navVC = self.navigationController
        
        self.API_getPendingNotificationByUserId()
        self.tblMain.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.notificationReceived),
            name: NSNotification.Name(rawValue: NOTIFICATIONS.USER_NOTIFICATION_BADGE),
            object: nil)
        
        self.notificationButton.badge = String(pendingNotifications.count)

        self.lblUsername.text = user_details.first_name
        if(user_details.image != nil && user_details.image != "") {
            self.imgUserView.layer.borderWidth = 1
            self.imgUserView.layer.masksToBounds = false
            self.imgUserView.layer.borderColor = UIColor.clear.cgColor
            self.imgUserView.layer.cornerRadius = self.imgUserView.frame.height/2
            self.imgUserView.clipsToBounds = true
            let myLogoImage = user_details.image
            self.imgUserView.setImageWithURL(urlString: myLogoImage!, placeholderImageName: "")
        }

        self.API_getPackageByUserId()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: NOTIFICATIONS.USER_NOTIFICATION_BADGE), object: nil)
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

    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int) {
        
        //print("\(buttonIndex)")
        switch (buttonIndex){
        case 0:
            print("Cancel")
        case 1:
            print("Delete")
            self.API_deletePackage(id: self.delete_id)
        default:
            print("Default")
            //Some code here..
        }
    }
    
    func API_deletePackage(id:String?) {
       
        RappleActivityIndicatorView.startAnimating()
        let parameterDict =  ["id":  id ?? ""]
        DashboardManager.API_deletePackage(information: parameterDict ) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            
            if error == nil {
                self.API_getPackageByUserId()
                self.API_getPendingNotificationByUserId()
                self.tblMain.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let actionSheet = UIActionSheet(title: "Choose Option", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Delete")
            let model_data = self.packageModel[indexPath.row]
            self.delete_id = model_data.id!
            actionSheet.show(in: self.view)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.packageModel.count
    }

    func randomString(length: Int) -> String {
        let letters =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DashboardNewCell") as! DashboardNewCell
        let model_data = self.packageModel[indexPath.row]
        cell.takephotoBtn.tag = indexPath.row
        cell.garantidateBtn.tag = indexPath.row
        cell.commentsBtn.tag = indexPath.row
        cell.returnBtn.tag = indexPath.row
        cell.shareBtn.tag = indexPath.row
        cell.takephotoBtn.addTarget(self, action: #selector(takePhoto(_:)), for: .touchUpInside)
        cell.garantidateBtn.addTarget(self, action: #selector(makeComment(_:)), for: .touchUpInside)
        cell.commentsBtn.addTarget(self, action: #selector(selectGarantiDate(_:)), for: .touchUpInside)
        cell.returnBtn.addTarget(self, action: #selector(selectReturnDate(_:)), for: .touchUpInside)
        cell.shareBtn.addTarget(self, action: #selector(share(_ :)), for: .touchUpInside)
        //cell.lblTitle.text = model_data.title ?? ""
        cell.lblDescription.text = model_data.courier ?? ""
//        if(selectedElement.count > 0) {
//            if selectedElement[0] == indexPath.row {
//                cell.firstViewBtn.isSelected = true
//            } else {
//                cell.firstViewBtn.isSelected = false
//            }
//        }
        
        if model_data.logoUrl!.isEmpty {
            if(model_data.defaultUrl! != "") {
                let myLogoImage = (NetworkingConstants.baseURL + model_data.defaultUrl!)
                cell.logoImageView.setImageWithURL(urlString: myLogoImage, placeholderImage: cell.logoImageView.getPlaceHolderImage(text: model_data.title))
            }else {
                cell.logoImageView.setImageWithURL(urlString: "", placeholderImage: cell.logoImageView.getPlaceHolderImage(text: model_data.title))
            }
        } else {
            let myLogoImage = NetworkingConstants.baseURL + model_data.logoUrl!
            cell.logoImageView.setImageWithURL(urlString: myLogoImage, placeholderImage: cell.logoImageView.getPlaceHolderImage(text: model_data.title))
        }

        // to cahnge the image on tap
        cell.logoImageViewButton.tag = indexPath.row
        cell.logoImageViewButton.addTarget(self, action: #selector(packageImageViewTapped(_:)), for: .touchUpInside)

        let last4 = self.packageModel[indexPath.row].shipmentId.suffix(6)
        
        cell.lblSecondNumber.text = String(last4)
        cell.lblNumberD.text = self.packageModel[indexPath.row].shipmentId
        cell.lblDate.text = self.packageModel[indexPath.row].time ?? ""
        //cell.lblStatus.text = model_data.status
//        cell.lblCat.text = model_data.title!
//        cell.lblTitle.text = model_data.description!
//        cell.lblNumberD.text = model_data.shipmentId!
//        //cell.lblStatusD.text = model_data.status!
//
//        cell.lblComments.text = "Comment: "+model_data.commentCount!
//
//        let m_id = model_data.id
//        cell.btnUpdate.isEnabled = true
//        cell.btnUpdate.addTarget(self, action: #selector(self.openPopup), for: .touchUpInside)
//
//        cell.btnUpdate.tag = Int(m_id!)!
//        cell.lblUpdateText.tag = Int("100"+m_id!)!
//        cell.btnComment.addTarget(self, action: #selector(self.commentPopup), for: .touchUpInside)
//        cell.btnComment.tag = Int(m_id!)!
//
//        cell.btnShare.addTarget(self, action: #selector(self.sharePopup), for: .touchUpInside)
//        cell.btnShare.tag = Int(m_id!)!
//        cell.btnPlus.tag = Int(m_id!)!
//        cell.logoImageView.tag = Int(m_id!)!
//       // cell.btnPlus.addTarget(self, action: #selector(self.openPopupSection), for: .touchUpInside)
//        cell.imgNExt.isHidden = false
//        //cell.firstViewBtn.tag = indexPath.row
//        cell.delegate = self
//        cell.setNeedsUpdateConstraints()
//        cell.setNeedsLayout()
//        cell.layoutIfNeeded()
//        cell.cellDelegate = self
//        cell.firstViewBtn.tag = indexPath.row
//        cell.imgNExt.tag = indexPath.row
//       // cell.imgNExt.isHidden = true
//
        if( model_data.status! == "DELIVERED" || model_data.status! == "Being Delivered" ) {
            //cell.imgStatus.setImage(UIImage(named: "ssss135.png"), for: .normal)
            cell.lblStatus.text = "Leveret"
            //cell.lblStatusD.text = "Leveret"
        } else if(model_data.status! == "AVAILABLE_FOR_DELIVERY" || model_data.status! == "INDELIVERY"){
                //cell.imgStatus.setImage(UIImage(named: "sss130.png"), for: .normal)
            if(model_data.status! == "AVAILABLE_FOR_DELIVERY"){
                //cell.lblStatusD.text = "Klar til afhentning"
                cell.lblStatus.text = "Klar til afhentning"
            } else {
                //cell.lblStatusD.text = "Snart klar"
                cell.lblStatus.text = "Snart klar"
            }
        } else if(model_data.status! == "EN_ROUTE" || model_data.status! == "INTRANSIT" || model_data.status! == "INWAREHOUSE") {
            //cell.lblStatusD.text = "På vej"
            cell.lblStatus.text = "På vej"
            //cell.imgStatus.setImage(UIImage(named: "sss134.png"), for: .normal)
        } else {
            if( model_data.status! == "INFORMED" ) {
                //cell.lblStatusD.text = "Kurer informeret"
                cell.lblStatus.text = "Kurer informeret"
                //cell.imgStatus.setImage(UIImage(named: "s123.png"), for: .normal)
            }

            if(model_data.status! == "PREADVICE"){
               // cell.lblStatusD.text = "Kurer informeret"
                cell.lblStatus.text = "Kurer informeret"
                //cell.imgStatus.setImage(UIImage(named: "s123.png"), for: .normal)
            }
        }
        //cell.lblCat.isHidden = true
        //cell.lblTitle.isHidden = true
        //cell.lblNumberD.isHidden = true
        //let tag_new = "1001"+model_data.id!
        //cell.imgStatus.tag = Int(tag_new)!
        return cell
    }

    @IBAction func addBlock(_ sender: UIButton) {
        self.tblMain.reloadData()
    }
    
    @objc func takePhoto(_ sender: UIButton) {
        let packageObj = self.packageModel[sender.tag]
        selectedPackage = packageObj
        self.API_addimage(packageId: packageObj.id)
    }
    
    func imageUploadedSuccssfully() {
        self.API_addimage(packageId: selectedPackage.id)
    }

    @objc func selectGarantiDate(_ sender: UIButton) {
        
        let myDatePicker: UIDatePicker = UIDatePicker()
        myDatePicker.timeZone = NSTimeZone.local
        myDatePicker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)
        
        let alertController = UIAlertController(title: "Select GarantiDate", message: "", preferredStyle: UIAlertController.Style.alert)
        let oneWeek = UIAlertAction(title: "A Week", style: UIAlertAction.Style.default){(action) in}
        let oneMonth = UIAlertAction(title: "A Month", style: UIAlertAction.Style.default){(action) in }
        let oneYear = UIAlertAction(title: "A Year", style: UIAlertAction.Style.default){(action) in }
        let custom = UIAlertAction(title: "Custom",  style: UIAlertAction.Style.destructive){(action) in
            oneWeek.accessibilityElementsHidden = true
            oneMonth.accessibilityElementsHidden = true
            oneYear.accessibilityElementsHidden = true
        }
        alertController.addTextField{
            (UITextField) in UITextField.placeholder = "Garanti Date"
        }
        alertController.addAction(oneWeek)
        alertController.addAction(oneMonth)
        alertController.addAction(oneYear)
        alertController.addAction(custom)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in
            
        }))
        alertController.addAction(UIAlertAction(title: "OK",
                                      style: UIAlertAction.Style.default,
                                      handler: {(_: UIAlertAction!) in
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func share(_ sender: UIButton) {
        "Date to Share".share()
    }

    @objc func selectReturnDate(_ sender: UIButton) {
        let myDatePicker: UIDatePicker = UIDatePicker()

        myDatePicker.timeZone = NSTimeZone.local
        myDatePicker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)
        
        let alertController = UIAlertController(title: "Select Return Date", message: "", preferredStyle: UIAlertController.Style.alert)
        let oneWeek = UIAlertAction(title: "A Week", style: UIAlertAction.Style.default){(action) in }
        let oneMonth = UIAlertAction(title: "A Month", style: UIAlertAction.Style.default){(action) in }
        let oneYear = UIAlertAction(title: "A Year", style: UIAlertAction.Style.default){(action) in }
        let custom = UIAlertAction(title: "Custom",  style: UIAlertAction.Style.destructive){(action) in
            oneWeek.accessibilityElementsHidden = true
            oneMonth.accessibilityElementsHidden = true
            oneYear.accessibilityElementsHidden = true
        }
        
        alertController.addTextField{(UITextField) in UITextField.placeholder = "Return Date"}
        alertController.addAction(oneWeek)
        alertController.addAction(oneMonth)
        alertController.addAction(oneYear)
        alertController.addAction(custom)
        alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: { _ in  }))
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in }))

        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc func makeComment(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Add new Comments", message: nil, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Add", style: .default) { (_) in
           if let txtField = alertController.textFields?.first, let text = txtField.text {
               //print("Text==>" + text)
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
        //print("I have pressed a button with a tag: \(tag)")
        
        let myIndexPath = NSIndexPath(row: tag, section: 0)
        let cell = tblMain.cellForRow(at: myIndexPath as IndexPath) as! DashboardCell
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
        //let cell = tblMain.cellForRow(at: myIndexPath as IndexPath) as! DashboardCell
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let myIndexPath = NSIndexPath(row: indexPath.row, section: 0)
//        let cell = tblMain.cellForRow(at: myIndexPath as IndexPath) as? DashboardCell
//        //cell?.initCellItem(indexPath,idn: indexPath.row)
//        //cell?.delegateCheck = self
//
//        cell?.imgNExt.image = UIImage(named: "next")
//
//        if(selectedIndex == indexPath.row) {
//            return UITableViewAutomaticDimension;
//        } else {
//           return 120;
//        }
//    }
   
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 120
//    }
    
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func updateTableView(row: Int) {
        if(selectedIndex == row) {
            selectedIndex = -1
        } else {
            selectedIndex = row
        }
        let path: NSIndexPath = NSIndexPath(row: row, section: 0)
        self.tblMain.beginUpdates()
        self.tblMain.reloadRows(at: [path as IndexPath], with: UITableView.RowAnimation.automatic )
        self.tblMain.endUpdates()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AddNewPackageVC {
            controller.transitioningDelegate = self
            controller.delegate = self
            controller.modalPresentationStyle = .custom
            //controller.interactiveTransition = interactiveTransition
            interactiveTransition.attach(to: controller)
        }
    }

    // MARK: UIViewControllerTransitioningDelegate
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = presentControllerButton.center
        transition.bubbleColor = presentControllerButton.backgroundColor!
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = presentControllerButton.center
        transition.bubbleColor = presentControllerButton.backgroundColor!
        return transition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
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

    func API_getPackageByUserId() {
        
        self.im_staus = 1
        //RappleActivityIndicatorView.startAnimating()
        let parameterDict =  ["user_id":  self.user_details.user_id ?? ""]
        
        DashboardManager.API_getPackageByUserId(information: parameterDict) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            
            if error == nil {
                //print(json)
                self.packageModel.removeAll()

                for (_, subJson) in json["message"] {
                    let modelList = PackageModel.init(json: subJson)
                    self.packageModel.append(modelList)
                }

                self.tblMain.reloadData()
                self.temArray = [Int](repeating: 0, count: self.packageModel.count)
                
            } else {
                 self.tblMain.reloadData()
            }
        }
    }
    
    func API_addimage(packageId:String?) {
        //RappleActivityIndicatorView.startAnimating()
        let parameterDict =  ["user_id":  self.user_details.user_id ?? "","p_id": packageId ?? "","local":local_Id]

        DashboardManager.API_getPackageGallery(information: parameterDict) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
             
            if error == nil {
                //print(json)
                if json["error"] == 1 {
                    let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "CustomCameraViewController") as! CustomCameraViewController
                    vc.packageId = packageId!
                    vc.delegate = self
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                } else {
                    //print(json["files"])
                    var filesArray = [String]()
                    for (_, subJson) in json["files"] {
                        //print(subJson)
                        filesArray.append(subJson.stringValue)
                    }

                    let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "GalleryVC") as! GalleryVC
                    vc.filesArray = filesArray
                    vc.packageId = packageId!
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            } else {
                //self.tblMain.reloadData()
            }
        }
    }
    
    @objc func API_getPendingNotificationByUserId() {
        pendingNotifications.removeAll()
        //   RappleActivityIndicatorView.startAnimating()
        let parameterDict =  ["user_id":  self.user_details.user_id ?? ""]
        DashboardManager.API_getPendingNotificationByUserId(information: parameterDict ) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            if error==nil{
                pendingNotifications.removeAll()
                for (_, subJson) in json["message"] {
                    let modelList = PackageModel.init(json: subJson)
                    pendingNotifications.append(modelList)
                    self.notificationButton.badge = String(pendingNotifications.count)
                }

                //self.tblMain.reloadData()
                //self.temArray = [Int](repeating: 0, count: self.packageModel.count)
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
        //sender.rotate360Degrees()
        let buttonPosition:CGPoint = sender.convert(.zero, to: self.tblMain)
        let indexPath:IndexPath = self.tblMain.indexPathForRow(at: buttonPosition)!
        
        //let model_data = self.result_data[indexPath.row]
        //let tag:NSInteger = sender.tag
        //let indexPath = IndexPath(row: 4, section: 0)

        self.API_shipment_action(lblNumber: String(sender.tag), sender: sender,indexPath: indexPath)
        //sleep(UInt32(2.9))
        //cell.lblUpdateText.text = "Opdater"
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
        
        let cell = tblMain.cellForRow(at: indexPath) as! DashboardCell
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
        self.tblMain.reloadData()
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
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return !isExtend ? 200 : 270
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? UITableView.automaticDimension
    }
}

extension UIView {
    
    func rotate360Degrees(_ duration: CFTimeInterval = 1.0, completionDelegate: CAAnimationDelegate? = nil) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(M_PI * 2.0)
        rotateAnimation.duration = duration
        
        if let delegate: CAAnimationDelegate = completionDelegate {
            rotateAnimation.delegate = delegate
        }
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

extension Hashable {
    func share() {
        let activity = UIActivityViewController(activityItems: [self], applicationActivities: nil)
        UIApplication.topViewController?.present(activity, animated: true, completion: nil)
    }
}

extension UIApplication {
    class var topViewController: UIViewController? { return getTopViewController() }
    private class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController { return getTopViewController(base: nav.visibleViewController) }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController { return getTopViewController(base: selected) }
        }
        if let presented = base?.presentedViewController { return getTopViewController(base: presented) }
        return base
    }
}
