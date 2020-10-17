//
//  DetailScreenViewController.swift
//  Tivovi
//
//  Created by Pranav on 10/05/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit
import DatePickerDialog
import SwiftyJSON
import RappleProgressHUD

var GLOBAL_IMG : UIImageView? = nil
var GLOBAL_IMG2 : UIImageView? = nil
var pr2 = true
var r = 0
class LogoSearchTableViewCell : UITableViewCell
{
    @IBOutlet weak var lbl_shopName: UILabel!
    @IBOutlet weak var img_shopName: UIImageView!
    
}



protocol detailHomeScreenSerch {
    func detailHomeScreenSearch(keyword : String);
}

class ImagesViewController : UICollectionViewCell
{
    @IBOutlet weak var img_package: UIImageView!
    
}
class DetailScreenViewController: UIViewController, ImagePreviewVCDelegate {
    var testid = "0"
    var alertfunction = 0
    //var isPush = false
    @IBOutlet weak var alertHeader: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var alertDescription: UILabel!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var alertTransparentBack: UIView!
    @IBOutlet weak var alertView: UIView!
    
    @IBAction func AlertBackScreen(_ sender: Any) {
        alertTransparentBack.isHidden = true
    }
    
    @IBAction func cancel(_ sender: Any) {
        showAlertMsg(showalert : "no", Header : "Et øjeblik!", Description: "Vil du gemme dine ændringer inden du forlader siden?", cancelBtnStr: "Forlad", saveBtnStr: "Gem")
        if(alertfunction == 0){ //from back button
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
    }
    @IBAction func save(_ sender: Any) {
        if(alertfunction == 1){ //from delete
            alertfunction = 0
               showAlertMsg(showalert : "no", Header : "Et øjeblik!", Description: "Vil du gemme dine ændringer inden du forlader siden?", cancelBtnStr: "Forlad", saveBtnStr: "Gem")
            NotificationMsgShowText = "Package deleted sucessfully"

                self.API_deletePackage(id: self.singlePackageDetail.id)
           
        }
    if(alertfunction == 0){ //from back button

           showAlertMsg(showalert : "no", Header : "Et øjeblik!", Description: "Vil du gemme dine ændringer inden du forlader siden?", cancelBtnStr: "Forlad", saveBtnStr: "Gem")
        
        self.edited = 0
                           let parameterDict =  ["user_id":  self.singlePackageDetail.user_id ?? "", "id": self.singlePackageDetail.id ?? "", "type": "name", "value": "\(self.txt_shopName.text ?? "")"]
                           
                           self.API_updatePackage(parameterDict: parameterDict) { (json) in
                               self.singlePackageDetail.title = self.txt_shopName.text!
                               //                   self.txt_packageNumber.text = self.singlePackageDetail.title
                               
                               self.singlePackageDetail.defaultUrl = json[0]["defaultUrl"].string ?? ""
                               
                              // self.showAlertController(title: "Package", message: "Saved Successfully")
                               self.getUniqueShopNameData()
                               if (self.singlePackageDetail.title != "")
                               {
                                   self.view_selectedShop.isHidden = false
                                   self.view_ShopList.isHidden = true
                                   self.view_shopName.isHidden = true
                                   
                                   self.lbl_selectedShopName.text = self.singlePackageDetail.title
                                   
                                   
                                   
                                   if (self.singlePackageDetail.defaultUrl != "/webshop.png")
                                   {
                                       self.img_selectedShopImage.sd_setImage(with: URL(string: NetworkingConstants.baseURL + self.singlePackageDetail.defaultUrl!)) { (image, error, type, url) in
                                       }
                                       self.view_backGroundShopName.backgroundColor = .white
                                       
                                   }else
                                   {
                                       self.img_selectedShopImage.image = self.img_selectedShopImage?.getPlaceHolderImage(text: self.singlePackageDetail.title == "" ? "Shop" : self.singlePackageDetail.title)
                                       self.view_backGroundShopName.backgroundColor = UIColor(red: 0.30, green: 0.60, blue: 0.16, alpha: 1.00)
                                       self.img_selectedShopImage.backgroundColor = .clear
                                       
                                   }
                                   
                                   
                                   
                               }else
                               {
                                   self.view_ShopList.cornerRadius = 30
                                   self.view_selectedShop.cornerRadius = 0
                                   self.view_selectedShop.isHidden = true
                                   self.view_ShopList.isHidden = false
                                   self.view_shopName.isHidden = false
                               }
                           }

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
    
}
    
    @IBOutlet weak var DeleteBtnLabel: UIButton!
    @IBOutlet weak var txt_packageNumber: UITextField!
    var context : DashboardMainVC!
    var homeSearchDelegate : detailHomeScreenSerch!
    @IBOutlet weak var noImageAvailable: UILabel!
    var logogArray : NSMutableArray = []
    var edited = 0
    @IBOutlet weak var view_step1: UIView!
    
    @IBOutlet weak var imgPlus: UIImageView!
    @IBOutlet weak var viewOfPlus: UIView!
    
    @IBOutlet weak var sharepackageImage: UIImageView!
    @IBOutlet weak var pagerCount: UIPageControl!
    
    @IBOutlet weak var lblTideline: UILabel!
    
    @IBOutlet weak var viewOfTideline: UIView!
    
    @IBOutlet weak var lbldatoer: UILabel!
    @IBOutlet weak var BtnBackground: UIImageView!
    
    @IBOutlet weak var viewOfDatoer: UIView!
    @IBOutlet weak var viewOfTimeline: UIView!
    @IBOutlet weak var viewOfStack: UIStackView!
    @IBOutlet weak var viewOfGem: UIView!

    @IBOutlet weak var viewOfBack: UIView!
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var view_lineStep2: UIView!
    @IBOutlet weak var view_Step2: UIView!
    
    @IBOutlet weak var view_lineStep3: UIView!
    @IBOutlet weak var view_Step3: UIView!
    
    @IBOutlet weak var view_lineStep4: UIView!
    @IBOutlet weak var view_Step4: UIView!
    
    @IBOutlet weak var switch_tracktrace: UISwitch!
    @IBOutlet weak var switch_garanti: UISwitch!
    @IBOutlet weak var switch_priceMatch: UISwitch!
    @IBOutlet weak var switch_return: UISwitch!
    
    @IBOutlet weak var lbl_garnti: UILabel!
    @IBOutlet weak var lbl_prismatch: UILabel!
    @IBOutlet weak var lbl_retur: UILabel!
    
    
    @IBOutlet weak var lbl_purchaseDate: UILabel!
    @IBOutlet weak var collectionview_shops: UICollectionView!
    @IBOutlet weak var txt_shopName: UITextField!
    @IBOutlet weak var collectionview_allImages: UICollectionView!
    @IBOutlet weak var default_icon: UIImageView!
    @IBOutlet weak var Nodefault_icon: UIImageView!
    
    var packageModel = [PackageModel]()
    var unique_shopName = [PackageModel]()
    
    var singlePackageDetail : PackageModel!
    var singlePackageDetail2 : PackageModel!
    var NotifiedPackageDetail : PackageModel!

    var pickerViewController: PickerVC = (UIStoryboard(name: "NewBoard", bundle: nil).instantiateViewController(withIdentifier: "PickerVC") as! PickerVC)
    
    
    @IBOutlet weak var lbl_description: UILabel!
    
    
    
    @IBOutlet weak var logoResultTableView: UITableView!
    
    
    @IBOutlet weak var lbl_selectedShopName: UILabel!
    @IBOutlet weak var img_selectedShopImage: UIImageView!
    
    @IBOutlet weak var view_selectedShop: UIView!
    
    @IBOutlet weak var view_ShopList: UIView!
    
    @IBOutlet weak var view_shopName: UIView!
    
    
    @IBOutlet var notificationButton: SSBadgeButton!
    
    @IBOutlet weak var view_trackTrace: UIView!
    
    @IBOutlet weak var viewOfStackForTopRound: UIView!
    
    
    @IBOutlet weak var img_warningGaranti: UIImageView!
    
    @IBOutlet weak var img_warningPrimatch: UIImageView!
    
    @IBOutlet weak var img_warningReturn: UIImageView!
    
    @IBOutlet weak var view_backGroundShopName: UIView!
    
    @IBOutlet weak var lblkobsdato: UILabel!
    @IBOutlet weak var stackViewOfCommomnDate: UIStackView!
    @IBOutlet weak var lblreturnDays: UILabel!
    
    @IBOutlet weak var lblReturdatehide: UILabel!
    @IBOutlet weak var lblreturndate: UILabel!
    @IBOutlet weak var lblPricematchDate: UILabel!
    @IBOutlet weak var lblPriceMatchDays: UILabel!
    @IBOutlet weak var viewOfPriceMatch: UIView!
    @IBOutlet weak var heightOfPricematch: NSLayoutConstraint!
    
    @IBOutlet weak var topOfThePrisMatch: NSLayoutConstraint!
    @IBOutlet weak var lblGarantiDate: UILabel!
    @IBOutlet weak var lblGarantiDays: UILabel!
    @IBOutlet weak var viewofT: UIView!
    @IBOutlet weak var viewOfDotLineReturnAbove: UIView!
    @IBOutlet weak var viewOfDotLineDotLineReturnBelow: UIView!
    @IBOutlet weak var viewOfDotLinepricematchAbove: UIView!
    
    @IBOutlet weak var viewOfDotLinepricematchBelow: UIView!
    
    @IBOutlet weak var viewOfDotLinegarantiAbove: UIView!
    
    @IBOutlet weak var viewGarantiright: UIView!
    @IBOutlet weak var viewgarantiLbl: UILabel!
    
    @IBOutlet weak var viewPricematchRight: UIView!
    @IBOutlet weak var viewPricematchlbl: UIView!
    
    @IBOutlet weak var viewReturnRight: UIView!
    @IBOutlet weak var viewreturnlbl: UIView!
    
    @IBOutlet weak var lblStackreturn: UILabel!
    @IBOutlet weak var lblStackPriceMatch: UILabel!
    
    @IBOutlet weak var lblColourChangePriceMatch: UILabel!
    @IBOutlet weak var lblColourChangeGaranti: UILabel!
    
    @IBOutlet weak var viewHorizantal: UIView!
    @IBOutlet weak var viewVertical: UIView!
    
    @IBOutlet var allview: UIView!

    @IBOutlet weak var stackview: UIStackView!
    var stringData = ""

    @IBOutlet weak var cfriends_1: UIImageView!
    @IBOutlet weak var cfriends_2: UIImageView!
    @IBOutlet weak var sharedcountLBL: UILabel!
    override func viewDidAppear(_ animated: Bool) {
        set()
        MenuViewG?.isHidden = true

        RappleActivityIndicatorView.stopAnimating()
            // navigationController?.loadView()
          
        let x = (self.viewOfStackForTopRound.frame.width-220)/2+(self.viewOfDatoer.frame.maxX+self.viewOfDatoer.frame.minX)/2
               let y = (self.viewOfStackForTopRound.frame.height-40)/2+(self.viewOfDatoer.frame.minY + self.viewOfDatoer.frame.height)/2
                BtnBackground.center =  CGPoint(x: x, y: y)
                self.lbldatoer.textColor = .white
               // navigationController?.loadView()
        
        print(singlePackageDetail,"singlePackageDetailsinglePackageDetailsinglePackageDetail")
             stringData = "Datoer"
             viewOfTideline.cornerradius = 15
             viewOfDatoer.cornerradius = 15

             imgBack.tintColor = UIColor.black.withAlphaComponent(0.5)
            // viewOfGem.backgroundColor = UIColor(named: "07Black")
        viewOfGem.backgroundColor = UIColor(named: "07Black")

             //viewOfGem.cornerradius = 15
             if edited == 1{
                 //viewOfGem.backgroundColor = UIColor(named: "07Red")
                viewOfGem.backgroundColor = UIColor(named: "07Red")

             }
            
             viewOfPlus.backgroundColor = UIColor.black.withAlphaComponent(0.5)
             viewOfPlus.cornerradius = 20
             self.logoResultTableView.isHidden = true
             let packages = self.packageModel.filter { (model) -> Bool in
                 
                 if(model.title == singlePackageDetail.title)
                 {
                     return true
                 }else
                 {
                     return false
                 }
                 
             };
             notificationButton.badge = "\(packages.count)"
             
             
             notificationButton.badgeBackgroundColor = .red
             
             
             self.lbl_description.text = singlePackageDetail.description
             
             self.txt_shopName.text = singlePackageDetail.title
             
             self.img_selectedShopImage.layer.masksToBounds = true
             
             if (singlePackageDetail.title != "")
             {
                 self.view_selectedShop.isHidden = false
                 self.view_ShopList.isHidden = true
                 self.view_shopName.isHidden = true
                 
                 self.lbl_selectedShopName.text = singlePackageDetail.title
                 
                 
                 if (self.singlePackageDetail.defaultUrl != "/webshop.png")
                 {
                     self.img_selectedShopImage.sd_setImage(with: URL(string: NetworkingConstants.baseURL + self.singlePackageDetail.defaultUrl!)) { (image, error, type, url) in
                     }
                     self.view_backGroundShopName.backgroundColor = .white
                     
                 }else
                 {
                     self.img_selectedShopImage.image = self.img_selectedShopImage?.getPlaceHolderImage(text: self.singlePackageDetail.title == "" ? "Shop" : self.singlePackageDetail.title)
                     self.view_backGroundShopName.backgroundColor = UIColor(red: 0.30, green: 0.60, blue: 0.16, alpha: 1.00)
                     self.img_selectedShopImage.backgroundColor = .clear
                     
                 }
                 
                 
                 
                 
             }else
             {
                 view_ShopList.cornerRadius = 30
                 view_selectedShop.cornerRadius = 0
                 self.view_selectedShop.isHidden = true
                 self.view_ShopList.isHidden = false
                 self.view_shopName.isHidden = false
             }
             
             self.txt_packageNumber.text = singlePackageDetail.shipmentId
             
             if (singlePackageDetail.setNotificationWarrantyDay == "on")
             {
                 self.switch_garanti.isOn = true
             }else
             {
                 self.switch_garanti.isOn = false
             }
             
             
             //added by raminde
             if (singlePackageDetail.setTrackTrace == "on")
             {
                 self.switch_tracktrace.isOn = true
                 self.view_trackTrace.isHidden = false
             }else
             {
                 self.switch_tracktrace.isOn = false
                 self.view_trackTrace.isHidden = true
             }
             
             
             if (singlePackageDetail.setNotificationPriceMatchDay == "on")
             {
                 self.switch_priceMatch.isOn = true
             }else
             {
                 self.switch_priceMatch.isOn = false
             }
             
             if (singlePackageDetail.setNotificationReturnDay == "on")
             {
                 self.switch_return.isOn = true
             }else
             {
                 self.switch_return.isOn = false
             }
             
             self.lbl_purchaseDate.text = singlePackageDetail.getPurchaseDateDisplay()
             //        self.lblkobsdato.text =  singlePackageDetail.getPurchaseDateDisplay()
             //        self.lblreturndate.text =  singlePackageDetail.getReturnDateDisplay()
             //        self.lblPricematchDate.text = singlePackageDetail.getPriceMatchDateDisplay()
             //        self.lblGarantiDate.text = singlePackageDetail.getWarrantyDateDisplay()
             //        self.lblreturnDays.text = String(singlePackageDetail.getReturnDay())
             //        self.lblPriceMatchDays.text = String(singlePackageDetail.getPriceMatchDay())
             //        self.lblGarantiDays.text = String(singlePackageDetail.waranty_months) + "Y"
             //        print(singlePackageDetail.getReturnDateDisplay(), "-------->")
             //        print(singlePackageDetail.getWarrantyDay(), "-------->")
             
             
             
             
             //        if singlePackageDetail.getReturnDateDisplay() == singlePackageDetail.getPriceMatchDateDisplay(){
             //            lblReturdatehide.isHidden = true
             //            viewOfPriceMatch.isHidden = true
             //            heightOfPricematch.constant = 0
             //            topOfThePrisMatch.constant = 0
             //        }else{
             //            viewofT.isHidden = true
             //            stackViewOfCommomnDate.isHidden = true
             //        }
             //        viewPricematchRight.isHidden = true
             //        viewGarantiright.isHidden = true
             //        viewReturnRight.isHidden = true
             //
             //        if singlePackageDetail.getReturnDay() <= 0{
             //            viewOfDotLineReturnAbove.backgroundColor = .systemGreen
             //            viewOfDotLineDotLineReturnBelow.backgroundColor = .systemGreen
             //            lblReturdatehide.textColor = .black
             //            lblreturndate.textColor = .black
             //            viewReturnRight.isHidden = false
             //            viewreturnlbl.isHidden = true
             //            if singlePackageDetail.getPriceMatchDay() <= 0{
             //                viewOfDotLinepricematchAbove.backgroundColor = .systemGreen
             //                viewOfDotLinepricematchBelow.backgroundColor = .systemGreen
             //                lblColourChangePriceMatch.textColor = .black
             //                lblPricematchDate.textColor = .black
             //                lblStackreturn.textColor = .black
             //                lblStackPriceMatch.textColor = .black
             //                viewHorizantal.backgroundColor = .black
             //                viewVertical.backgroundColor = .black
             //                viewPricematchRight.isHidden = false
             //                viewPricematchlbl.isHidden = true
             //
             //                if singlePackageDetail.getWarrantyDay() <= 0{
             //                    viewOfDotLinegarantiAbove.backgroundColor = .systemGreen
             //                    lblColourChangeGaranti.textColor = .black
             //                    lblGarantiDate.textColor = .black
             //                    viewGarantiright.isHidden = false
             //                    viewgarantiLbl.isHidden = true
             //
             //                }else{
             //                    viewOfDotLinegarantiAbove.backgroundColor = .systemRed
             //                    viewGarantiright.isHidden = true
             //                    viewgarantiLbl.isHidden = false
             //                }
             //            }else{
             //                viewOfDotLinepricematchAbove.backgroundColor = .systemRed
             //                viewOfDotLinepricematchBelow.backgroundColor = .systemRed
             //                viewOfDotLinegarantiAbove.backgroundColor = .systemRed
             //                viewPricematchRight.isHidden = true
             //                viewPricematchlbl.isHidden = false
             //            }
             //        }else{
             //            viewOfDotLineReturnAbove.backgroundColor = .systemRed
             //            viewOfDotLinepricematchBelow.backgroundColor = .systemRed
             //            viewOfDotLinepricematchAbove.backgroundColor = .systemRed
             //            viewOfDotLineDotLineReturnBelow.backgroundColor = .systemRed
             //            viewOfDotLinegarantiAbove.backgroundColor = .systemRed
             //            viewReturnRight.isHidden = true
             //            viewreturnlbl.isHidden = false
             //        }
             
             //        if singlePackageDetail.getPriceMatchDay() <= 0{
             //            viewOfDotLinepricematchAbove.backgroundColor = .systemGreen
             //            viewOfDotLinepricematchBelow.backgroundColor = .systemGreen
             //            viewPricematchRight.isHidden = false
             //            viewPricematchlbl.isHidden = true
             //        }else{
             //
             //        }
        
            
            
             //self.navigationController?.navigationBar.isHidden = false
        
             //self.navigationController?.hidesBarsOnTap = true
             self.lbl_garnti.text = "\(singlePackageDetail.waranty_months) år"
             self.lbl_prismatch.text = "\(singlePackageDetail.priceMatchDay) dg."
             self.lbl_retur.text = "\(singlePackageDetail.return_days) dg."
             
             
             
             self.setSteps(step: "0")
             
             var txtStatus = ""
             if( singlePackageDetail.status! == "DELIVERED" || singlePackageDetail.status! == "Being Delivered" ) {
                 txtStatus = "Leveret"
                 self.setSteps(step: "4")
             } else if(singlePackageDetail.status! == "AVAILABLE_FOR_DELIVERY" || singlePackageDetail.status! == "INDELIVERY"){
                 //            if(model_data.status! == "AVAILABLE_FOR_DELIVERY"){
                 //                txtStatus = "Klar til afhentning"
                 //            } else {
                 //                txtStatus = "Snart klar"
                 //            }
                 self.setSteps(step: "3")
             } else if(singlePackageDetail.status! == "EN_ROUTE" || singlePackageDetail.status! == "INTRANSIT" || singlePackageDetail.status! == "INWAREHOUSE") {
                 txtStatus = "På vej"
                 self.setSteps(step: "2")
             } else {
                 if( singlePackageDetail.status! == "INFORMED" ) {
                     txtStatus = "Kurer informeret"
                 }
                 if( singlePackageDetail.status! == "PREADVICE" ) {
                     txtStatus = "Kurer informeret"
                 }
                 self.setSteps(step: "1")
             }
             
             //        self.rightSettingButton()
                     self.leftBackButton()
             self.lbl_description.isHidden = true
             
             
             unique_shopName = [];
             
        if singlePackageDetail.Default_image != "" && singlePackageDetail.imageUrls != nil && singlePackageDetail.imageUrls.count > 0 && singlePackageDetail.imageUrls[0].contains(singlePackageDetail.Default_image!){
            default_icon.isHidden = false
            Nodefault_icon.isHidden = true
        } else {
            default_icon.isHidden = true
            Nodefault_icon.isHidden = false
        }
             
             self.setNotificationIcon()
             self.getUniqueShopNameData()
//    self.removeSpinner()
        //self.logoResultTableView.isHidden = false

        BtnBackground.isHidden = false
        if(singlePackageDetail.sharedbyuser == "Yes"){
            DeleteBtnLabel.setTitle("Remove addbox from my wall", for: .normal)
        }
        if(singlePackageDetail.sharedbyuser == "Shared"){
            DeleteBtnLabel.setTitle("Delete (Will delete for all)", for: .normal)
        }
    }
    

    func API_getshared(shop_id: String, completion: (_ success: Bool) -> Void) {
        let user_details = UserModel.sharedInstance

    //print(receiver)
        //let rec = "\(receiver)"
        let parameterDict =  ["user_id": user_details.user_id!, "shop_id": shop_id] as [String : Any]
             print("API_getshared Called \(user_details.user_id!) - \(shop_id) ")
        print("Parameters")
        print(parameterDict)
             APIManager.shared().requestWith(NetworkingConstants.baseURL + NetworkingConstants.company.API_getshared, method: .post, andParameters: parameterDict) { response in
                print(response)
                 if response.status {

                     let responseDic = response.object! as [String: Any]
                    print(responseDic)
                    
                    SharedArrayS = NSMutableArray(array: responseDic["message"] as! NSArray)
                                //  if(reloadTable == nil){}else{reloadTable!.reloadData()}
                    //let msg = response.object(forKey: "message")

                    //let out = responseDic["message"]
                   // print(out)
                
                    //getfriends()
                   
                   // SearchUsersNew(keyword: lastsearch, reloadTable: StableS)
                    
                  //  if(FtableS == nil){}else{getfriends(FtableS!)}

                   // FtableS?.reloadData()
        print("is that loaded2")
          print(SharedArrayS)
          print(SharedArrayS.count)
          var imagestring = "c_image"
                    if(SharedArrayS.count==0){
                        self.cfriends_1.isHidden = true
                        self.cfriends_2.isHidden = true
                        self.sharedcountLBL.text = ""

                    }
          if(SharedArrayS.count>0){
              print("image loading..")
            print(self.singlePackageDetail.sharedbyuser)
            if (self.singlePackageDetail.sharedbyuser == "Shared"){
                                               imagestring = "c_image"
                                                       }
            if (self.singlePackageDetail.sharedbyuser == "Yes"){
                                              imagestring = "b_image"
                                                                   }
              print("imagestring = \(imagestring)")
            self.sharedcountLBL.text = "\(SharedArrayS.count) fælles venner"
         let sharedshopdetail : NSDictionary = SharedArrayS[0] as! NSDictionary;
        let b_image = sharedshopdetail.object(forKey: imagestring)
              print(b_image)
            if(b_image != nil){self.cfriends_1.sd_setImage(with: URL(string: b_image! as! String), completed: nil)}
            self.cfriends_1.isHidden = false
          }
          
         
            if(SharedArrayS.count>1){
                if (self.singlePackageDetail.sharedbyuser == "Shared"){
                                                          imagestring = "c_image"
                                                                  }
                if (self.singlePackageDetail.sharedbyuser == "Yes"){
                                                         imagestring = "b_image"
                                                                              }
              
              let sharedshopdetail2 : NSDictionary = SharedArrayS[1] as! NSDictionary;

           let b_image2 = sharedshopdetail2.object(forKey: imagestring)
                print("b_image2")
                print(b_image2)
                print(imagestring)
                print(self.singlePackageDetail.sharedbyuser)
                print(sharedshopdetail2)
                self.cfriends_2.sd_setImage(with: URL(string: b_image2 as! String), completed: nil)
                self.cfriends_2.isHidden = false
            }
          
                  }else {
                     //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: response.errorMessage)
                 }
                 
             }
        completion(true)

     }


    
    override func viewWillAppear(_ animated: Bool) {
       // API_getshared(shop_id: self.singlePackageDetail.id!)
    print("check1 -viewWillAppear")
    print(singlePackageDetail.id)
        
        API_getshared(shop_id: self.singlePackageDetail.id!){ (success) -> Void in
                if success {
                   // do second task if success
            print("is that loaded")
            print(SharedArrayS)
            }
            }
            let x = (self.viewOfStackForTopRound.frame.width-220)/2+(self.viewOfDatoer.frame.maxX+self.viewOfDatoer.frame.minX)/2
                   let y = (self.viewOfStackForTopRound.frame.height-40)/2+(self.viewOfDatoer.frame.minY + self.viewOfDatoer.frame.height)/2
                    BtnBackground.center =  CGPoint(x: x, y: y)
                    self.lbldatoer.textColor = .white
                   // navigationController?.loadView()
        
        //      self.showSpinner(onView: self.view)
                    if (singlePackageDetail.title != "")
                               {
                                   self.view_selectedShop.isHidden = false
                                   self.view_ShopList.isHidden = true
                                self.view_shopName.isHidden = true

                    }else{
        self.view_shopName.isHidden = false
                        self.view_selectedShop.isHidden = true
        }
                    self.logoResultTableView.isHidden = true
                      viewOfTideline.cornerradius = 15
                      viewOfDatoer.cornerradius = 15
                      view_ShopList.cornerRadius = 30

        
    }
    override func viewDidLoad()
    {
      
RappleActivityIndicatorView.startAnimating()
        super.viewDidLoad()
        print("check1 -viewdidload")
        print(singlePackageDetail.id)
//        print(singlePackageDetail2.id)

        print(testid)

        // Do any additional setup after loading the view.
    }
   
    
    override func viewWillLayoutSubviews() {

         //self.context.dataList = singlePackageDetail.imageUrls
         
         if singlePackageDetail.imageUrls.count == 0{
             noImageAvailable.isHidden = false
             print("hideee not",singlePackageDetail.imageUrls.count)
         }else{
             noImageAvailable.isHidden = true
             print("hideee",singlePackageDetail.imageUrls.count)
         }
         
         //self.context.collectionview.reloadData()
         
         //self.navigationController?.isNavigationBarHidden = true
        // let packages = self.packageModel.filter { (model) -> Bool in
  
         //   if(model.title == singlePackageDetail.title)
          //  {
           //      return true
            // }else
         //    {
           //      return false
          //   }
             
       //  };
        // notificationButton.badge = "\(packages.count)"
         
         collectionview_allImages.reloadData()
         viewOfDatoer.layer.cornerRadius = 20
         viewOfTideline.layer.cornerRadius = 20
         viewOfDatoer.layer.masksToBounds = true
         viewOfTideline.layer.masksToBounds = true
         if stringData == "Datoer"{
             viewOfTimeline.isHidden = true
             viewOfStack.isHidden = false
            // viewOfDatoer.backgroundColor = .black
             //viewOfTideline.backgroundColor = .white
            // lbldatoer.textColor = .white
            // lblTideline.textColor = .black
             
         }else if stringData == "tidsline"{
             viewOfTimeline.isHidden = false
             viewOfStack.isHidden = true
             //viewOfTideline.backgroundColor = .black
             //viewOfDatoer.backgroundColor = .white
             //lbldatoer.textColor = .black
             //lblTideline.textColor = .white
         }
         

         if edited == 1{
                     viewOfGem.backgroundColor = UIColor(named: "07Red")

         }else{
                     viewOfGem.backgroundColor = UIColor(named: "07Black")

         }

        
    }
    
    @objc func pageChanged(_ sender: UIPageControl){
        print("didset")
        pagerCount?.currentPage = sender.currentPage
    }
    
    
    func getUniqueShopNameData()
    {
        unique_shopName.removeAll()
        
        self.packageModel.filter { (model) -> Bool in
            
            let hadError = unique_shopName.contains { element in
                if element.title ==  model.title
                {
                    return true
                } else {
                    return false
                }
            }
            
            if (!hadError )
            {
                unique_shopName.append(model)
                //  self.collectionview_shops.reloadData()
            }
            
            
            return true
        };
        self.collectionview_shops.reloadData()
        print("collectionview_shops")
    }
    
    func setNotificationIcon()
    {
        self.img_warningGaranti.isHidden = true
        self.img_warningPrimatch.isHidden = true
        self.img_warningReturn.isHidden = true
        
        
        //print(singlePackageDetail.getNotificationReturnDay())
        
        if(singlePackageDetail.setNotificationReturnDay == "on" && (singlePackageDetail.getNotificationReturnDay() == 0 || singlePackageDetail.getNotificationReturnDay() < 0))
        {
            self.img_warningReturn.isHidden = false
            
        }
        if(singlePackageDetail.setNotificationWarrantyDay == "on" && (singlePackageDetail.getNotificationWarrantyDay() == 0 || singlePackageDetail.getNotificationWarrantyDay() < 0 ))
        {
            self.img_warningGaranti.isHidden = false
            
        }
        if(singlePackageDetail.setNotificationPriceMatchDay == "on" && (singlePackageDetail.getNotificationPriceMatchDay() == 0 || singlePackageDetail.getNotificationPriceMatchDay() < 0 ))
        {
            self.img_warningPrimatch.isHidden = false
            
        }
    }
    @IBAction func SharedPackagesView(_ sender: Any) {
       if(singlePackageDetail.sharedbyuser != "No"){
            GLOBAL_IMG = cfriends_1
               pr1 = true
            pr2 = true
        let storyboard = UIStoryboard.init(name: "NewBoard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ShopSharedView") as! ShopSharedView
        //vc.singlePackageDetail = singlePackageDetail
        vc.singlePackageDetail = singlePackageDetail
        self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func onClickDefaultIcon(_ sender: Any) {
        let parameterDict =  ["user_id":  singlePackageDetail.user_id ?? "", "id": singlePackageDetail.id ?? "", "type": "Default_image", "value": self.singlePackageDetail.imageUrls[self.pagerCount.currentPage]]
        
        print(parameterDict , "parameterDict")
           
        DashboardManager.API_updatePackage(information: parameterDict) { (json, wsResponse, error) in
               
               if error==nil {
                   //print(json)
                  if json["error"] == 1 {
                       //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Network Error")
                  } else {
                    //print(json["files"])
                    self.default_icon.isHidden = false
                    self.Nodefault_icon.isHidden = true
                    self.singlePackageDetail.Default_image = (self.singlePackageDetail.imageUrls[self.pagerCount.currentPage]).replacingOccurrences(of: "/imguploads", with: "")
                }
                  
               }else {
                   // self.tblMain.reloadData()
               }
        }
    }
    @IBAction func onClickDatoer(_ sender: Any) {
        print(" centrrrrr \(self.viewOfTimeline.center)")

           if (stringData == "Datoer"){
               return
           }
           stringData = "Datoer"
           print("Datoer")
           
           
               UIView.animate(withDuration: 0.2,
                          delay: 0.1,
                          options: [.curveEaseInOut],
                          animations: {
                           self.viewOfStack.center = CGPoint(x: (self.viewOfStack.frame.width+40)/2 , y: (self.viewOfStack.frame.minY + self.viewOfStack.frame.height+20)/2)
                           self.viewOfTimeline.center = CGPoint(x: (self.viewOfStack.frame.width+40)+(self.viewOfStack.frame.width+40)/2, y: (self.viewOfStack.frame.minY + self.viewOfStack.frame.height+20)/2)
                           //self.BtnBackground.center = self.viewOfDatoer.center
                           let x = (self.viewOfStackForTopRound.frame.width-220)/2+(self.viewOfDatoer.frame.maxX+self.viewOfDatoer.frame.minX)/2
                           let y = (self.viewOfStackForTopRound.frame.height-40)/2+(self.viewOfDatoer.frame.minY + self.viewOfDatoer.frame.height)/2
                               self.BtnBackground.center = CGPoint(x: x, y: y)
                           self.lbldatoer.textColor = UIColor(named: "DarkBackColor")
                           self.lblTideline.textColor = UIColor(named: "DarkTextColor")
                           
           },
                          completion: { finished in
                           print("Bug moved right!")
           })
           
        

           
          // UIView.transition(from: viewOfStack, to: viewOfTimeline, duration: 1, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
           self.viewOfTimeline.isHidden = false
           self.viewOfStack.isHidden = false
               self.BtnBackground.isHidden = false
               
          // self.viewOfDatoer.backgroundColor = .red
          // self.viewOfTideline.backgroundColor = .white
           //self.lbldatoer.textColor = .white
          // self.lblTideline.textColor = .black
           
    }
    
    @IBAction func onClickTidsline(_ sender: Any) {
               if (stringData == "tidsline"){
                       return
                   }
             print(" MinX \(self.viewOfDatoer.frame.minX),  MaxX \(self.viewOfDatoer.frame.maxX)  MinY \(self.viewOfDatoer.frame.minY),  MaxY \(self.viewOfDatoer.frame.maxY) ,  centerXAnchor \(self.viewOfDatoer.centerXAnchor)")
             print("------------------------------------------")

                   print(" MinX \(self.lbldatoer.frame.minX),  MaxX \(self.lbldatoer.frame.maxX)  MinY \(self.lbldatoer.frame.minY),  MaxY \(self.lbldatoer.frame.maxY)")

            
                   print("")
             print(" centrrrrr \(self.viewOfTideline.center)")
             print(" width \(self.viewOfTideline.frame.width)")
             let globalPoint = viewOfDatoer.superview?.convert(viewOfDatoer.frame.origin, to: nil)
             print(" globalPoint \(globalPoint)")

                   stringData = "tidsline"
                   set()
                   setData()
                   print("tidsline")
                   //setting default position raminde
                       self.viewOfStack.center = CGPoint(x: (self.viewOfStack.frame.width+40)/2 , y: (self.viewOfStack.frame.minY + self.viewOfStack.frame.height+20)/2)
                   self.viewOfTimeline.center = CGPoint(x: (self.viewOfStack.frame.width+40)+(self.viewOfStack.frame.width+40)/2, y: (self.viewOfStack.frame.minY + self.viewOfStack.frame.height+20)/2)
             
             //self.BtnBackground.center = CGPoint(x: (self.viewOfDatoer.frame.minX), y: (self.viewOfDatoer.frame.minY + self.viewOfDatoer.frame.height+32)/2)
             //self.BtnBackground.center = self.viewOfTideline.center
             //self.BtnBackground.center = CGPoint(x: 200, y: (self.viewOfDatoer.frame.minY + self.viewOfDatoer.frame.height+32)/2)

             print(" CenterSet \(self.BtnBackground.center)")

                   // UIView.transition(from: viewOfStack, to: viewOfTimeline, duration: 1, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
                   /*UIView.transition(with: viewOfTimeline, duration: 0.4, options: .transitionCurlUp, animations: {() in
                       
                       
                   }, completion: nil)*/
                   
            
             UIView.animate(withDuration: 0.2,
                                    delay: 0.1,
                                    options: [.curveEaseInOut],
                                    animations: {
                                       self.viewOfStack.center = CGPoint(x: 0 - (self.viewOfStack.frame.width+40)/2 , y: (self.viewOfStack.frame.minY + self.viewOfStack.frame.height+32)/2)
                                     self.viewOfTimeline.center = CGPoint(x: (self.viewOfStack.frame.width+40)/2 , y: (self.viewOfStack.frame.minY + self.viewOfStack.frame.height+32)/2)

                                     //self.BtnBackground.center = self.viewOfTideline.center
                                     self.BtnBackground.center = CGPoint(x: (self.viewOfStackForTopRound.frame.width-220)/2+(self.viewOfTideline.frame.maxX+self.viewOfTideline.frame.minX)/2, y: (self.viewOfTideline.frame.minY + self.viewOfTideline.frame.height)/2)
                                     let x = (self.viewOfStackForTopRound.frame.width-220)/2+(self.viewOfTideline.frame.maxX+self.viewOfTideline.frame.minX)/2
                                     let y = (self.viewOfStackForTopRound.frame.height-40)/2+(self.viewOfTideline.frame.minY + self.viewOfTideline.frame.height)/2
                                      self.BtnBackground.center = CGPoint(x: x, y: y)
                                     
                                     self.lbldatoer.textColor = UIColor(named: "DarkTextColor")
                                     self.lblTideline.textColor = UIColor(named: "DarkBackColor")

                     },
                                    completion: { finished in
                                     print("Bug moved right!")
                     })
                   
                   
                   
              
                   
                   self.viewOfTimeline.isHidden = false
                   self.viewOfStack.isHidden = false
                    self.BtnBackground.isHidden = false
                   //self.viewOfTideline.backgroundColor = .black
                  // self.viewOfDatoer.backgroundColor = .white
                  // self.lbldatoer.textColor = .black
                  // self.lblTideline.textColor = .white
                   
                
        
    }
    
    @IBAction func onClickGem(_ sender: Any) {
        self.doneButton()
        //self.rightSettingButton()
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
    @IBAction func onClickBack(_ sender: Any) {
        txt_shopName.resignFirstResponder()
        X = 0
       // Y = 600
        alertfunction = 0
        if(edited == 1){
           showAlertMsg(showalert : "yes", Header : "Et øjeblik!", Description: "Vil du gemme dine ændringer inden du forlader siden?", cancelBtnStr: "Forlad", saveBtnStr: "Gem")
        }else{
        self.backButton()
        }
        // self.leftBackButton()
    }
    
    
    
        
    func leftBackButton()
    {
        print("leftBackButton")
        let frameimg = CGRect(x: 0, y: 0, width: 20, height: 20)
        
        //added by raminde
        let someButton = UIButton(frame: frameimg)
        someButton.contentMode = .scaleAspectFit
        someButton.setImage(UIImage(named: "previous"), for: .normal)
        someButton.setTitleColor(.systemRed, for: .normal)
        //someButton.addTarget(self, action: #selector(self.backButton), for: .touchUpInside)
        let mailbutton2 = UIBarButtonItem(customView: someButton)
        navigationItem.leftBarButtonItem = mailbutton2
        //added by raminde ends
        
        let heightConstraint = NSLayoutConstraint(item: someButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameimg.height)
        let widthConstraint = NSLayoutConstraint(item: someButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameimg.width)
        heightConstraint.isActive = true;
        widthConstraint.isActive = true;
        
    }
    func rightSettingButton()
    {
        print("rightSettingButton")
        let frameimg = CGRect(x: 0, y: 0, width: 50, height: 30)
        let someButton = UIButton(frame: frameimg)
        someButton.setTitle("Gem", for: .normal)
        someButton.setTitleColor(.systemBlue, for: .normal)
        //   someButton.addTarget(self, action: #selector(self.doneButton), for: .touchUpInside)
        
        let mailbutton = UIBarButtonItem(customView: someButton)
        navigationItem.rightBarButtonItem = mailbutton
        
        
        let heightConstraint = NSLayoutConstraint(item: someButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameimg.height)
        let widthConstraint = NSLayoutConstraint(item: someButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: frameimg.width)
        heightConstraint.isActive = true;
        widthConstraint.isActive = true;
        
        
    }
    
    //     @objc func doneButton(_ sender: Any)
    func doneButton()
    {
        
        edited = 0
        let parameterDict =  ["user_id":  singlePackageDetail.user_id ?? "", "id": singlePackageDetail.id ?? "", "type": "name", "value": "\(self.txt_shopName.text ?? "")"]
        // self.showAlertController(title: "Package", message: "\(edited)")
        
        API_updatePackage(parameterDict: parameterDict) { (json) in
            self.singlePackageDetail.title = self.txt_shopName.text!
            //           self.txt_packageNumber.text = self.singlePackageDetail.title
            
            self.singlePackageDetail.defaultUrl = json[0]["defaultUrl"].string ?? ""
            
            //self.showAlertController(title: "Package", message: "Saved Successfully")
            
            self.getUniqueShopNameData()
            if (self.singlePackageDetail.title != "")
            {
                self.view_selectedShop.isHidden = false
                self.view_selectedShop.cornerRadius = 30
                self.view_ShopList.isHidden = true
                self.view_shopName.isHidden = true
                
                self.lbl_selectedShopName.text = self.singlePackageDetail.title
                
                //            self.img_selectedShopImage.sd_setImage(with: URL(string: NetworkingConstants.baseURL + (self.singlePackageDetail.defaultUrl ?? "")!), completed: nil)
                
                
                if (self.singlePackageDetail.defaultUrl != "/webshop.png")
                {
                    self.img_selectedShopImage.sd_setImage(with: URL(string: NetworkingConstants.baseURL + self.singlePackageDetail.defaultUrl!)) { (image, error, type, url) in
                    }
                    self.view_backGroundShopName.backgroundColor = .white
                    
                }else
                {
                    self.img_selectedShopImage.image = self.img_selectedShopImage?.getPlaceHolderImage(text: self.singlePackageDetail.title == "" ? "Shop" : self.singlePackageDetail.title)
                    self.view_backGroundShopName.backgroundColor = UIColor(red: 0.30, green: 0.60, blue: 0.16, alpha: 1.00)
                    self.img_selectedShopImage.backgroundColor = .clear
                    
                }
                
                
            }else
            {
                self.view_ShopList.cornerRadius = 30
                self.view_selectedShop.cornerRadius = 0
                self.view_selectedShop.isHidden = true
                self.view_ShopList.isHidden = false
                self.view_shopName.isHidden = false
            }
            
        }
        
    }
    
    func set(){
        print("set")
        self.lblkobsdato.text =  singlePackageDetail.getPurchaseDateDisplay()
        self.lblreturndate.text =  singlePackageDetail.getReturnDateDisplay()
        self.lblPricematchDate.text = singlePackageDetail.getPriceMatchDateDisplay()
        self.lblGarantiDate.text = singlePackageDetail.getWarrantyDateDisplay()
        self.lblreturnDays.text = String(singlePackageDetail.getReturnDay())
        self.lblPriceMatchDays.text = String(singlePackageDetail.getPriceMatchDay())
        self.lblGarantiDays.text = String(singlePackageDetail.waranty_months) + "Y"
        
        viewPricematchRight.isHidden = true
        viewGarantiright.isHidden = true
        viewReturnRight.isHidden = true
        
        if singlePackageDetail.getReturnDateDisplay() == singlePackageDetail.getPriceMatchDateDisplay(){
            print("equal")
            lblReturdatehide.isHidden = true
            viewOfPriceMatch.isHidden = true
            viewofT.isHidden = false
            stackViewOfCommomnDate.isHidden = false
            heightOfPricematch.constant = 0
            topOfThePrisMatch.constant = 0
          
             
            if singlePackageDetail.getReturnDay() <= 0{
                print(" return <= 0")
                viewOfDotLineReturnAbove.backgroundColor = .systemGreen
                viewOfDotLinepricematchBelow.backgroundColor = .systemGreen
                lblreturnDays.textColor = UIColor(named: "DarkTextColor")
                lblStackreturn.textColor = UIColor(named: "DarkTextColor")
                lblStackPriceMatch.textColor = UIColor(named: "DarkTextColor")
                viewHorizantal.backgroundColor = UIColor(named: "DarkTextColor")
                viewVertical.backgroundColor = UIColor(named: "DarkTextColor")
                
                viewReturnRight.isHidden = false
                viewreturnlbl.isHidden = true
            }else{
                viewOfDotLineReturnAbove.backgroundColor = .systemRed
                
                viewPricematchRight.isHidden = true
                viewPricematchlbl.isHidden = false
            }
        }else{
            lblReturdatehide.isHidden = false
            viewOfPriceMatch.isHidden = false
            viewofT.isHidden = true
            heightOfPricematch.constant = 55
            topOfThePrisMatch.constant = 40
            stackViewOfCommomnDate.isHidden = true
        }
        
        
        /*if singlePackageDetail.getPriceMatchDay() < singlePackageDetail.getReturnDay(){
            
                        lblReturdatehide.text = "PrisMatch"
                        self.lblreturnDays.text = String(singlePackageDetail.getPriceMatchDay())
                        self.lblreturndate.text =  singlePackageDetail.getPriceMatchDateDisplay()
            
                        lblColourChangePriceMatch.text = "Returdato"
                        self.lblPriceMatchDays.text =  String(singlePackageDetail.getReturnDay())
                        self.lblPricematchDate.text = singlePackageDetail.getReturnDateDisplay()
            
                        if singlePackageDetail.getPriceMatchDay() <= 0{
                            viewOfDotLineReturnAbove.backgroundColor = .systemGreen
                            viewOfDotLineDotLineReturnBelow.backgroundColor = .systemGreen
                            lblReturdatehide.textColor = .black
                            lblreturndate.textColor = .black
                            viewReturnRight.isHidden = false
                            viewreturnlbl.isHidden = true
                            if singlePackageDetail.getReturnDay() <= 0{
                                viewOfDotLinepricematchAbove.backgroundColor = .systemGreen
                                viewOfDotLinepricematchBelow.backgroundColor = .systemGreen
                                lblColourChangePriceMatch.textColor = .black
                                lblPricematchDate.textColor = .black
                                lblStackreturn.textColor = .black
                                lblStackPriceMatch.textColor = .black
                                viewHorizantal.backgroundColor = .black
                                viewVertical.backgroundColor = .black
                                viewPricematchRight.isHidden = false
                                viewPricematchlbl.isHidden = true
            
                                if singlePackageDetail.getWarrantyDay() <= 0{
                                    viewOfDotLinegarantiAbove.backgroundColor = .systemGreen
                                    lblColourChangeGaranti.textColor = .black
                                    lblGarantiDate.textColor = .black
                                    viewGarantiright.isHidden = false
                                    viewgarantiLbl.isHidden = true
            
                                }else{
                                    viewOfDotLinegarantiAbove.backgroundColor = .systemRed
                                    viewGarantiright.isHidden = true
                                    viewgarantiLbl.isHidden = false
                                }
            
            
                            }else{
                                viewOfDotLinepricematchAbove.backgroundColor = .systemRed
                                viewOfDotLinepricematchBelow.backgroundColor = .systemRed
                                viewOfDotLinegarantiAbove.backgroundColor = .systemRed
                                viewPricematchRight.isHidden = true
                                viewPricematchlbl.isHidden = false
                            }
            
                        }else{
                            viewOfDotLineReturnAbove.backgroundColor = .systemRed
                            viewOfDotLinepricematchBelow.backgroundColor = .systemRed
                            viewOfDotLinepricematchAbove.backgroundColor = .systemRed
                            viewOfDotLineDotLineReturnBelow.backgroundColor = .systemRed
                            viewOfDotLinegarantiAbove.backgroundColor = .systemRed
                            viewReturnRight.isHidden = true
                            viewreturnlbl.isHidden = false
                        }
            
            
        
        }else if singlePackageDetail.getPriceMatchDay() > singlePackageDetail.getReturnDay()*/
        //{
            lblReturdatehide.text = "Returdato"
            lblColourChangePriceMatch.text = "PrisMatch"
            if singlePackageDetail.getReturnDay() <= 0{
                viewOfDotLineReturnAbove.backgroundColor = .systemGreen
                viewOfDotLineDotLineReturnBelow.backgroundColor = .systemGreen
                viewReturnRight.isHidden = false
                viewreturnlbl.isHidden = true
                //lblReturdatehide.textColor = UIColor(named: "DarkTextColor")
                lblreturndate.textColor = UIColor(named: "DarkTextColor")
                
                
                if singlePackageDetail.getPriceMatchDay() <= 0{
                    viewOfDotLinepricematchAbove.backgroundColor = .systemGreen
                    viewOfDotLinepricematchBelow.backgroundColor = .systemGreen
                    viewPricematchRight.isHidden = false
                    viewPricematchlbl.isHidden = true
                    lblColourChangePriceMatch.textColor = UIColor(named: "DarkTextColor")
                    lblPricematchDate.textColor = UIColor(named: "DarkTextColor")
                    
                    if singlePackageDetail.getWarrantyDay() <= 0{
                        viewOfDotLinegarantiAbove.backgroundColor = .systemGreen
                        lblColourChangeGaranti.textColor = UIColor(named: "DarkTextColor")
                        lblColourChangeGaranti.textColor = UIColor(named: "DarkTextColor")
                        lblGarantiDate.textColor = UIColor(named: "DarkTextColor")
                        viewGarantiright.isHidden = false
                        viewgarantiLbl.isHidden = true
                        
                    }else{
                        viewOfDotLinegarantiAbove.backgroundColor = .systemRed
                    }
                }else{
                    viewOfDotLinepricematchAbove.backgroundColor = .systemRed
                    viewOfDotLinepricematchBelow.backgroundColor = .systemRed
                }
                
            }else{
                viewOfDotLineReturnAbove.backgroundColor = .systemRed
                viewOfDotLineDotLineReturnBelow.backgroundColor = .systemRed
                viewOfDotLinepricematchAbove.backgroundColor = .systemRed
                
            }
        //}
    }
    
    func setData(){
        
//        self.lblkobsdato.text =  singlePackageDetail.getPurchaseDateDisplay()
//        self.lblreturndate.text =  singlePackageDetail.getReturnDateDisplay()
//        self.lblPricematchDate.text = singlePackageDetail.getPriceMatchDateDisplay()
//        self.lblGarantiDate.text = singlePackageDetail.getWarrantyDateDisplay()
//        self.lblreturnDays.text = String(singlePackageDetail.getReturnDay())
//        self.lblPriceMatchDays.text = String(singlePackageDetail.getPriceMatchDay())
//        self.lblGarantiDays.text = String(singlePackageDetail.waranty_months) + "Y"
//        print(singlePackageDetail.getReturnDateDisplay(), "-------->")
//        print(singlePackageDetail.getWarrantyDay(), "-------->")
//
//        if singlePackageDetail.getReturnDateDisplay() == singlePackageDetail.getPriceMatchDateDisplay(){
//            lblReturdatehide.isHidden = true
//            viewOfPriceMatch.isHidden = true
//            viewofT.isHidden = false
//            stackViewOfCommomnDate.isHidden = false
//            heightOfPricematch.constant = 0
//            topOfThePrisMatch.constant = 0
//
//
//        }else{
//            lblReturdatehide.isHidden = false
//            viewOfPriceMatch.isHidden = false
//            viewofT.isHidden = true
//            heightOfPricematch.constant = 55
//            topOfThePrisMatch.constant = 40
//            stackViewOfCommomnDate.isHidden = true
//        }
//        viewPricematchRight.isHidden = true
//        viewGarantiright.isHidden = true
//        viewReturnRight.isHidden = true
//
////        if singlePackageDetail.getReturnDay() <= 0{
////            viewOfDotLineReturnAbove.backgroundColor = .systemGreen
////            viewOfDotLineDotLineReturnBelow.backgroundColor = .systemGreen
////            lblReturdatehide.textColor = .black
////            lblreturndate.textColor = .black
////            viewReturnRight.isHidden = false
////            viewreturnlbl.isHidden = true
////            if singlePackageDetail.getPriceMatchDay() <= 0{
////                viewOfDotLinepricematchAbove.backgroundColor = .systemGreen
////                viewOfDotLinepricematchBelow.backgroundColor = .systemGreen
////                lblColourChangePriceMatch.textColor = .black
////                lblPricematchDate.textColor = .black
////                lblStackreturn.textColor = .black
////                lblStackPriceMatch.textColor = .black
////                viewHorizantal.backgroundColor = .black
////                viewVertical.backgroundColor = .black
////                viewPricematchRight.isHidden = false
////                viewPricematchlbl.isHidden = true
////
////                if singlePackageDetail.getWarrantyDay() <= 0{
////                    viewOfDotLinegarantiAbove.backgroundColor = .systemGreen
////                    lblColourChangeGaranti.textColor = .black
////                    lblGarantiDate.textColor = .black
////                    viewGarantiright.isHidden = false
////                    viewgarantiLbl.isHidden = true
////
////                }else{
////                    viewOfDotLinegarantiAbove.backgroundColor = .systemRed
////                    viewGarantiright.isHidden = true Ω∫
//                               viewGarantiright.isHidden = true
//                               viewgarantiLbl.isHidden = false
//                           }
//                       }else{
//                           viewOfDotLinepricematchAbove.backgroundColor = .systemRed
//                           viewOfDotLinepricematchBelow.backgroundColor = .systemRed
//                           viewOfDotLinegarantiAbove.backgroundColor = .systemRed
//                           viewPricematchRight.isHidden = true
//                           viewPricematchlbl.isHidden = false
//                       }
//                   }else{
//                       viewOfDotLineReturnAbove.backgroundColor = .systemRed
//                       viewOfDotLinepricematchBelow.backgroundColor = .systemRed
//                       viewOfDotLinepricematchAbove.backgroundColor = .systemRed
//                       viewOfDotLineDotLineReturnBelow.backgroundColor = .systemRed
//                       viewOfDotLinegarantiAbove.backgroundColor = .systemRed
//                       viewReturnRight.isHidden = true
//                       viewreturnlbl.isHidden = false
//                   }
//
//        }
    }

        
        // @objc func backButton(_ sender: Any){
        func backButton(){
//            context.returnvaluse.imageUrls = singlePackageDetail.imageUrls
            print("navidation back")
            isFromDetail = true
            //self.navigationController?.delegate = self
            
            if(edited == 1){
                self.setData()
                if edited == 1{
                    print("navidation back")
                    viewOfGem.backgroundColor = UIColor(named: "07Red")
                    viewOfGem.backgroundColor = UIColor(named: "07Black")

                }else{
                    print("navidation back")
                    viewOfGem.backgroundColor = UIColor(named: "07Black")
                }
                
                let alert = UIAlertController(title: "Unsaved Data", message: "Your Data is not saved do you want to save it now?", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
                    //print("Saving Data!")
                    self.edited = 0
                    let parameterDict =  ["user_id":  self.singlePackageDetail.user_id ?? "", "id": self.singlePackageDetail.id ?? "", "type": "name", "value": "\(self.txt_shopName.text ?? "")"]
                    
                    self.API_updatePackage(parameterDict: parameterDict) { (json) in
                        self.singlePackageDetail.title = self.txt_shopName.text!
                        //                   self.txt_packageNumber.text = self.singlePackageDetail.title
                        
                        self.singlePackageDetail.defaultUrl = json[0]["defaultUrl"].string ?? ""
                        
                       // self.showAlertController(title: "Package", message: "Saved Successfully")
                        self.getUniqueShopNameData()
                        if (self.singlePackageDetail.title != "")
                        {
                            self.view_selectedShop.isHidden = false
                            self.view_ShopList.isHidden = true
                            self.view_shopName.isHidden = true
                            
                            self.lbl_selectedShopName.text = self.singlePackageDetail.title
                            
                            
                            
                            if (self.singlePackageDetail.defaultUrl != "/webshop.png")
                            {
                                self.img_selectedShopImage.sd_setImage(with: URL(string: NetworkingConstants.baseURL + self.singlePackageDetail.defaultUrl!)) { (image, error, type, url) in
                                }
                                self.view_backGroundShopName.backgroundColor = .white
                                
                            }else
                            {
                                self.img_selectedShopImage.image = self.img_selectedShopImage?.getPlaceHolderImage(text: self.singlePackageDetail.title == "" ? "Shop" : self.singlePackageDetail.title)
                                self.view_backGroundShopName.backgroundColor = UIColor(red: 0.30, green: 0.60, blue: 0.16, alpha: 1.00)
                                self.img_selectedShopImage.backgroundColor = .clear
                                
                            }
                            
                            
                            
                        }else
                        {
                            self.view_ShopList.cornerRadius = 30
                            self.view_selectedShop.cornerRadius = 0
                            self.view_selectedShop.isHidden = true
                            self.view_ShopList.isHidden = false
                            self.view_shopName.isHidden = false
                        }
                    }
                }))
                alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
                    //print("Yay! You brought your towel!")
                    //self.navigationController?.popViewController(animated: true)
                   // self.isPush = false
                    //self.navigationController?.delegate = self
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
                }))
                
                self.present(alert, animated: true)
            }else{
                //self.navigationController?.popViewController(animated: true)
                //isPush = false
                //self.navigationController?.delegate = self
                pr1 = false
                pr2 = false
                //self.navigationController?.popViewController(animated: true)
                //self.navigationController?.popToRootViewController(animated: true)
                if r == 1{
                //r = 0
                self.navigationController?.popViewController(animated: true)
                }else{
                GLOBAL_IMG  = GLOBAL_IMG2

                self.navigationController?.popToRootViewController(animated: true)
                }
            }
        }
        
        
        @IBAction func action_showMoreDescription(_ sender: Any)
        {
            if (self.lbl_description.isHidden == false)
            {
                self.lbl_description.isHidden = true
            }else
            {
                self.lbl_description.isHidden = false
            }
        }
        
        
        @IBAction func action_addImages(_ sender: Any)
        {
            let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CustomCameraViewController") as! CustomCameraViewController
            vc.packageId = singlePackageDetail.id!
            vc.delegate = self
            vc.from = "detailscreen"
            //vc.modalPresentationStyle = .overFullScreen
            //self.present(vc, animated: true, completion: nil)
            let transition = CATransition()
                          transition.duration = 0.25
                          transition.type = CATransitionType.moveIn
                          transition.subtype = CATransitionSubtype.fromLeft
                          transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
                          tabBarController?.view.layer.add(transition, forKey: kCATransition)
            
            self.navigationController?.pushViewController(vc, animated: true)

                API_addimage(packageId: singlePackageDetail.id)
            
        }
        
        @IBAction func action_updateShipmentID(_ sender: Any)
        {
            edited = 1
            setData()
            if edited == 1{
                viewOfGem.backgroundColor = UIColor(named: "07Red")
            }else{
                viewOfGem.backgroundColor = UIColor(named: "07Black")
            }
            
            let parameterDict =  ["user_id":  singlePackageDetail.user_id ?? "", "id": singlePackageDetail.id ?? "", "type": "courier", "value": "\(self.txt_packageNumber.text ?? "")"]
            
            API_updatePackage(parameterDict: parameterDict) { (true) in
                self.singlePackageDetail.shipmentId = self.txt_packageNumber.text!
                self.txt_packageNumber.text = self.singlePackageDetail.shipmentId
            }
            
        }
    
    
        
        @IBAction func onClickGatil(_ sender: Any) {
            
            print("link")
            let url = singlePackageDetail.shopurl!
            print(url)
                   guard let urlopen = URL(string: "\(url)") else { return }
                    UIApplication.shared.open(urlopen)
            
        }
        @IBAction func action_comments(_ sender: Any)
        {
            let storyboard = UIStoryboard.init(name: "NewBoard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
            vc.singlePackageDetail = singlePackageDetail
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    
    
    
    
    
        //////////////////////////////// SCROLLING FUNCTIONS////////////////////////////
    func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        print("scrolled to top")
    }

    
    
    
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            print("Scrolling has started")
            //if targetContentOffset.pointee.y < scrollView.contentOffset.y {
            

                //            searchButton.backgroundColor = .black
                //            btnSetting.backgroundColor = .black
                
                UIView.animate(withDuration: 0.2, animations: {
                    self.viewOfGem.alpha = 0.0
                    self.viewOfBack.alpha = 0.0
                   // self.headerView.alpha = 0.0
                    
                }) { (isCompeleted) in
                    self.viewOfGem.isHidden = true
                    self.viewOfBack.isHidden = true
                    print("Scrolling has completed")

                    // self.navigationController?.setNavigationBarHidden(true, animated: true)
                    //self.headerView.isHidden = true
                    
                    //delay reappear
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                           // do stuff 42 seconds later
                       
                        print("This was delayed")
                        self.viewOfGem.isHidden = false
                       self.viewOfBack.isHidden = false
                               UIView.animate(withDuration: 0.5, animations: {
                                   self.viewOfGem.alpha = 1.0
                                   self.viewOfBack.alpha = 10
                                // self.navigationController?.setNavigationBarHidden(false, animated: true)
                                   //self.he-aderView.alpha = 1.0
                               }) { (isCompeleted) in
                                   self.viewOfGem.isHidden = false
                                   self.viewOfBack.isHidden = false
                               }
                       }
                    
                }
                
        }
        
        @IBAction func action_sameShopPackage(_ sender: Any)
        {   r = 1
            pr2 = true
            GLOBAL_IMG = notificationButton.imageView
            GLOBAL_IMG3 = notificationButton.imageView
            let storyboard = UIStoryboard.init(name: "NewBoard", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "SingleShopPackageViewController") as! SingleShopPackageViewController
            vc.singlePackageDetail = singlePackageDetail
            vc.dataList = packageModel
            vc.setData = "SingleShopPackageViewController"
            vc.context = self
            
            //isPush = true
           
            navigationController?.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
        @IBAction func action_switch_garanti(_ sender: UISwitch)
        { edited = 1
            setData()
            if edited == 1{
                viewOfGem.backgroundColor = UIColor(named: "07Red")
            }else{
                viewOfGem.backgroundColor = UIColor(named: "07Black")
            }
            let parameterDict =  ["user_id":  singlePackageDetail.user_id ?? "", "id": singlePackageDetail.id ?? "", "type": "waranty_all", "value": "\(singlePackageDetail.waranty_months)", "notification": "\(singlePackageDetail.w_notification_days)", "status": "\(sender.isOn == true ? "on" : "off")"]
            
            
            API_updatePackage(parameterDict: parameterDict) { (true) in
                self.singlePackageDetail.setNotificationWarrantyDay = sender.isOn == true ? "on" : "off";
                self.setNotificationIcon()
                
            }
        }
        
        @IBAction func action_switch_pricemismatch(_ sender: UISwitch)
        { edited = 1
            setData()
            if edited == 1{
                viewOfGem.backgroundColor = UIColor(named: "07Red")
            }else{
                viewOfGem.backgroundColor = UIColor(named: "07Black")
            }
            let parameterDict =  ["user_id":  singlePackageDetail.user_id ?? "", "id": singlePackageDetail.id ?? "", "type": "pricematch_all", "value": "\(singlePackageDetail.priceMatchDay)", "notification": "\(singlePackageDetail.priceMatchNotificationDay)", "status": "\(sender.isOn == true ? "on" : "off")"]
            
            
            API_updatePackage(parameterDict: parameterDict) { (true) in
                self.singlePackageDetail.setNotificationPriceMatchDay = sender.isOn == true ? "on" : "off";
                self.setNotificationIcon()
                
            }
        }
        
        
        @IBAction func action_switch_return(_ sender: UISwitch)
        { edited = 1
            setData()
            if edited == 1{
                viewOfGem.backgroundColor = UIColor(named: "07Red")
            }else{
                viewOfGem.backgroundColor = UIColor(named: "07Black")
            }
            let parameterDict =  ["user_id":  singlePackageDetail.user_id ?? "", "id": singlePackageDetail.id ?? "", "type": "return_all", "value": "\(singlePackageDetail.return_days)", "notification": "\(singlePackageDetail.notification_days)", "status": "\(sender.isOn == true ? "on" : "off")"]
            
            API_updatePackage(parameterDict: parameterDict) { (true) in
                self.singlePackageDetail.setNotificationReturnDay = sender.isOn == true ? "on" : "off";
                self.setNotificationIcon()
                
            }
        }
        
        
        @IBAction func action_switch_track_trace(_ sender: UISwitch)
        { edited = 1
            setData()
            if edited == 1{
                viewOfGem.backgroundColor = UIColor(named: "07Red")
            }else{
                viewOfGem.backgroundColor = UIColor(named: "07Black")
            }
            
            //added by raminde
            if (sender.isOn == true)
            {
                self.view_trackTrace.isHidden = false
            }else
            {
                self.view_trackTrace.isHidden = true
            }
            
            //add by raminde
            let parameterDict =  ["user_id":  singlePackageDetail.user_id ?? "", "id": singlePackageDetail.id ?? "", "type": "tracktrace", "value": "\(singlePackageDetail.waranty_months)", "notification": "\(singlePackageDetail.w_notification_days)", "status": "\(sender.isOn == true ? "on" : "off")"]
            
            API_updatePackage(parameterDict: parameterDict) { (true) in
                self.singlePackageDetail.setTrackTrace = sender.isOn == true ? "on" : "off";
                //print(self.singlePackageDetail.setTrackTrace)
                self.setNotificationIcon()
                
            }
        }
        
        @IBAction func Action_garanti(_ sender: Any)
        {
            
            pickerViewController.extendMode = (IndexPath.init(row: 0, section: 0),PackageExtendMode.Warranty)
            pickerViewController.setRange(from: 1, to: 12, ofLeft: true)
            
            self.showPickerView()
            setData()
        }
        
        @IBAction func Action_pricemismatch(_ sender: Any)
        {
            setData()
            pickerViewController.extendMode = (IndexPath.init(row: 0, section: 0),PackageExtendMode.PriceMatch)
            pickerViewController.setRange(from: 1, to: 100, ofLeft: true)
            
            self.showPickerView()
            setData()
        }
        
        @IBAction func Action_delete(_ sender: Any)
        {
            alertfunction = 1
               showAlertMsg(showalert : "yes", Header : "Et øjeblik!", Description: "Vil du slette dette?", cancelBtnStr: "ingen", saveBtnStr: "Ja")
           // let alert = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .alert)
            //alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { _ in
           //     self.API_deletePackage(id: self.singlePackageDetail.id)
            //}))
            //alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
            //self.present(alert, animated: true, completion: nil)
        }
        
        func API_deletePackage(id:String?) {
            // RappleActivityIndicatorView.startAnimating()
            let user_details = UserModel.sharedInstance
            let parameterDict =  ["user_id": user_details.user_id ?? "","id":  id ?? ""]
            
            DashboardManager.API_deletePackage(information: parameterDict ) { (json, wsResponse, error) in
                //            RappleActivityIndicatorView.stopAnimation()
                
                if error == nil {
                    //self.isPush = false
                    pr1 = false
                    pr2 = false
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
        
        @IBAction func Action_return(_ sender: Any)
        {
            pickerViewController.extendMode = (IndexPath.init(row: 0, section: 0),PackageExtendMode.ReturnDate)
            pickerViewController.setRange(from: 1, to: 100, ofLeft: true)
            
            self.showPickerView()
            setData()
        }
        
        @IBAction func Action_shopNameChange(_ sender: Any)
        {
            view_ShopList.cornerRadius = 30
            view_selectedShop.cornerRadius = 0
            self.view_selectedShop.isHidden = true
            self.view_ShopList.isHidden = false
            self.view_shopName.isHidden = false
        }
        
        
        @IBAction func action_purchaseDate(_ sender: Any)
        {
            DatePickerDialog().show("Buy Day", doneButtonTitle: "OK", cancelButtonTitle: "Cancel", defaultDate: singlePackageDetail!.getPurchaseDate()! ,datePickerMode: .date) {
                (date) -> Void in
                if let dt = date {
                    
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy:MM:dd"
                    self.updateDate(packageID: self.singlePackageDetail.id ?? "", date: formatter.string(from: dt))
                    
                    
                    formatter.dateFormat = "yyyy-MM-dd 00:00:00"
                    
                    
                    self.singlePackageDetail.purchaseDate = formatter.string(from: dt);
                    self.lbl_purchaseDate.text = self.singlePackageDetail.getPurchaseDateDisplay()
                    
                    self.setNotificationIcon()
                    self.setData()
                    
                }
            }
        }
   
        
        private func showPickerView() {
            addChild(pickerViewController)
            
            pickerViewController.delegate = self
            pickerViewController.component = 1
            
            view.addSubview(pickerViewController.view)
            pickerViewController.view.frame = view.bounds
            pickerViewController.picker.reloadAllComponents()
        }
        
        
        
        
        private func updateDate(packageID: String, date: String) {
            edited = 1
            setData()
            if edited == 1{
                viewOfGem.backgroundColor = UIColor(named: "07Red")
            }else{
                viewOfGem.backgroundColor = UIColor(named: "07Black")
            }
            let user_details = UserModel.sharedInstance
            
            let type = "purchase_date"
            let value = "\(date)"
            let parameterDict =  ["user_id": user_details.user_id ?? "", "id": packageID, "type": type, "value": value]
            
            API_updatePackage(parameterDict: parameterDict) { (true) in
                
            }
        }
        
        
        func API_updatePackage(parameterDict: [String: String], completion: ((JSON) -> Void)? = nil) {
            //RappleActivityIndicatorView.startAnimating()
            ////print(parameterDict)
            
            DashboardManager.API_updatePackage(information: parameterDict) { (json, wsResponse, error) in
                //RappleActivityIndicatorView.stopAnimation()
                if error == nil {
                    //print(json)
                    completion!(json)
                    //self.showAlertController(title: "Package", message: "Saved Successfully")
                    
                    if parameterDict["type"] == "courier" {
                        self.callShipAction(shipNumber: parameterDict["value"] ?? "", isActive: 0)
                    } else {
                        //                    self.refresNewData()
                    
                    }
                    
                } else {
                    
                    ////print("API_updatePackage failed")
                }
            }
        }
        
        
        func callShipAction(shipNumber: String, isActive: Int) {
            let user_details = UserModel.sharedInstance
            
            let parameterDict =  [
                "user_id":  user_details.user_id ?? "",
                "shipmentId": shipNumber ,
                "status": "\(isActive)"
            ]
            
            ////print(parameterDict)
            DashboardManager.API_shipment_action(information: parameterDict) { (json, wsResponse, error) in
                //print(json)
                if error == nil{
                    if(json["status"]==true) {
                        //                        self.API_getPackageByUserId()
                        // sender.imageView!.stopAnimating()
                    }else{
                        //                        self.showAlertController(title: "", message: json["message"].stringValue )
                        //                    self.API_getPackageByUserId()
                        //sender.imageView!.stopAnimating()
                        //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: json["message"].stringValue)
                        let otherAlert = UIAlertController(title: "Error", message: "To update ship number was failed", preferredStyle: UIAlertController.Style.alert)
                        let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
                        otherAlert.addAction(dismiss)

                        self.present(otherAlert, animated: true, completion: nil)
                        self.txt_packageNumber.text = ""
                    }
                } else {
                    //                self.API_getPackageByUserId()
                    let otherAlert = UIAlertController(title: "Error", message: "Network Issue.", preferredStyle: UIAlertController.Style.alert)
                    let dismiss = UIAlertAction(title: "OK", style: .default, handler: nil)
                    otherAlert.addAction(dismiss)

                    self.present(otherAlert, animated: true, completion: nil)
                    self.txt_packageNumber.text = ""
                }
            }
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
            let user_details = UserModel.sharedInstance
            
            let type = "courier"
            let value = "\(shipmentID)"
            let parameterDict =  ["user_id":  user_details.user_id ?? "", "id": packageID, "type": type, "value": value]
            
            API_updatePackage(parameterDict: parameterDict)
        }
        
        
        @IBAction func action_didTapShareUseButton(_ sender: Any)
        {
            let storyboard = UIStoryboard.init(name: "NewBoard", bundle: nil)
            pr1 = true
            pr2 = true
            GLOBAL_IMG = sharepackageImage
            GLOBAL_IMG = nil
          //  let vc = storyboard.instantiateViewController(withIdentifier: "PackageShareVC") as! PackageShareVC
           // vc.shipmentId = singlePackageDetail.id
            let vc = storyboard.instantiateViewController(withIdentifier: "ShareScreen") as! ShareScreen
            SelectedShipmentId = singlePackageDetail.id!
            self.navigationController?.pushViewController(vc, animated: true)

            //self.navigationController?.present(vc, animated: true, completion: nil)
        }
        
        
        @IBAction func action_didTapShareButton(_ sender: Any)
        {
            "\(singlePackageDetail.shareContent ?? "")".share()
        }
        
        func API_addimage(packageId:String?) {
            let user_details = UserModel.sharedInstance
            
            let parameterDict =  ["user_id":  user_details.user_id ?? "", "p_id": packageId ?? "", "local": local_Id]
            DashboardManager.API_getPackageGallery(information: parameterDict) { (json, wsResponse, error) in
                
                if error == nil {
                    
                    self.singlePackageDetail.setImages(json: json)
                    self.collectionview_allImages.reloadData()
                    
                    ////print(json)
                    //                if json["error"] == 1 {
                    //                    let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
                    //                    let vc = storyboard.instantiateViewController(withIdentifier: "CustomCameraViewController") as! CustomCameraViewController
                    //                    vc.packageId = packageId!
                    //                    vc.delegate = self
                    //                    vc.modalPresentationStyle = .overFullScreen
                    //                    self.present(vc, animated: true, completion: nil)
                    //                } else {
                    //                    ////print(json["files"])
                    //                    var filesArray = [String]()
                    //                    for (_, subJson) in json["files"] {
                    //                        ////print(subJson)
                    //                        filesArray.append(subJson.stringValue)
                    //                    }
                    //
                    //                    let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
                    //                    let vc = storyboard.instantiateViewController(withIdentifier: "GalleryVC") as! GalleryVC
                    //                    vc.filesArray = filesArray
                    //                    vc.packageId = packageId!
                    //                    vc.modalPresentationStyle = .overFullScreen
                    //                    vc.delegate = self
                    //                    self.present(vc, animated: true, completion: nil)
                    //                }
                } else {
                }
            }
        }
    
    
    
        
        
        
        /*
         // MARK: - Navigation
         
         // In a storyboard-based application, you will often want to do a little preparation before navigation
         override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using segue.destination.
         // Pass the selected object to the new view controller.
         }
         */
        
    }
    
    
    extension DetailScreenViewController :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
    {
        //    func numberOfSections(in collectionView: UICollectionView) -> Int {
        ////        if collectionView == collectionview_allImages
        ////        {
        ////            print("numberOfSections")
        ////            return singlePackageDetail.imageUrls.count
        ////
        ////        }else{
        ////            return 0
        ////        }
        //
        //    }
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
            if collectionView == collectionview_allImages
            {
         //       print("willDisplay")
                
                pagerCount.hidesForSinglePage = true
                pagerCount.numberOfPages = singlePackageDetail.imageUrls.count
                self.pagerCount.currentPage = indexPath.section
            }
        }
        func scrollViewDidScroll(_ scrollView: UIScrollView) {
            
            print("scoller")
            let visibleRect = CGRect(origin: self.collectionview_allImages.contentOffset, size: self.collectionview_allImages.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            if let visibleIndexPath = self.collectionview_allImages.indexPathForItem(at: visiblePoint) {
                self.pagerCount.currentPage = visibleIndexPath.row
                if singlePackageDetail.imageUrls[visibleIndexPath.row].contains(singlePackageDetail.Default_image!){
                    default_icon.isHidden = false
                    Nodefault_icon.isHidden = true
                } else {
                    default_icon.isHidden = true
                    Nodefault_icon.isHidden = false
                }
            }
            
        }
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            if collectionView == collectionview_allImages
            {
                return singlePackageDetail.imageUrls.count
            }
            else
            {
                return unique_shopName.count
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            if collectionView == collectionview_allImages
            {
                let cell : ImagesViewController = collectionView.dequeueReusableCell(withReuseIdentifier: "ImagesViewController", for: indexPath as IndexPath) as! ImagesViewController
                
                let image = self.singlePackageDetail.imageUrls[indexPath.row]
                print("check1")
                print(self.singlePackageDetail.id)
                if singlePackageDetail.imageUrls.count == 0{
                    noImageAvailable.isHidden = false
                    
                }else{
                    noImageAvailable.isHidden = true
                }
                
                
                cell.img_package.sd_setImage(with: URL(string: NetworkingConstants.baseURL + image), completed: nil)
                //cell.img_package.contentMode = .scaleAspectFill
                
                //cell.img_package.backgroundColor = .red
                
                return cell
            }
            else
            {
                let cell : DashboardFirstCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardFirstCollectionViewCell", for: indexPath as IndexPath) as! DashboardFirstCollectionViewCell
                
                
                
                let details = unique_shopName[indexPath.row]
                
                
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
            return 0;
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
        {
            return 0;
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            
            if (collectionView == self.collectionview_allImages)
            {
             //   print(collectionview_allImages.frame.height , "height of collection view")
                return CGSize(width: collectionview_allImages.frame.width , height: collectionview_allImages.frame.height)
              
            }
            else
            {
                return CGSize(width: 84 , height: 100)
            }
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
        {
            if (collectionView == self.collectionview_shops)
            {
                edited = 1
                if edited == 1{
                    viewOfGem.backgroundColor = UIColor(named: "07Red")
                }else{
                    viewOfGem.backgroundColor = UIColor(named: "07Black")
                }
                let details = unique_shopName[indexPath.row]
                self.txt_shopName.text = details.title
                singlePackageDetail.shopurl = details.shopurl
                
                //        self.homeSearchDelegate.detailHomeScreenSearch(keyword: details.title)
                //        self.navigationController?.popViewController(animated: true
                
            }else
            {
                //let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
                let vc = storyboard!.instantiateViewController(withIdentifier: "ImageViewVC") as! ImageViewVC
                
                // let vc = storyboard.instantiateViewController(withIdentifier: "ImagePreviewVC") as! ImagePreviewVC
                //            vc.filesArray = self.singlePackageDetail.imageUrls
                //            vc.packageId = singlePackageDetail.id!
                //let vc = ImagePreviewVC()
                vc.context = self
                vc.imgArray = self.singlePackageDetail.imageUrls
                vc.packageId = singlePackageDetail.id!
                print(self.singlePackageDetail.id! , "self.singlePackageDetail.id!")
                vc.passedContentOffset = indexPath
                vc.modalPresentationStyle = .overFullScreen
                //vc.delegate = self
                self.present(vc, animated: true, completion: nil)
                
                
                //            let vc=ImagePreviewVC()
                //            vc.imgArray = self.singlePackageDetail.imageUrls
                //            vc.passedContentOffset = indexPath
                //            vc.modalPresentationStyle = .overFullScreen
                //            self.present(vc, animated: true, completion: nil)
                
            }
            
            //        homeSearchDelegate
            
        }
        
        
    }
    
    
    extension DetailScreenViewController : UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate
    {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return logogArray.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "LogoSearchTableViewCell") as! LogoSearchTableViewCell
            cell.selectionStyle = .none
            
            let detail : NSDictionary = self.logogArray[indexPath.row] as! NSDictionary;
            
            
            cell.img_shopName?.setImageWithURL(urlString: NetworkingConstants.baseURL + "\(detail.object(forKey: "logo") ?? "")", placeholderImage: cell.img_shopName?.getPlaceHolderImage(text: "Loading..."))
            cell.lbl_shopName.text = "\(detail.object(forKey: "name") ?? "")"
            
            return cell
        }
        
        func searchLogo(searchString : String) {
            
            let parameterDict =  [
                "imgS": self.txt_shopName.text!.lowercased(),
                ] as [String : Any]
            
            APIManager.shared().requestWith(NetworkingConstants.baseURL + NetworkingConstants.company.API_searchLogo, method: .post, andParameters: parameterDict) { response in
                
                if response.status {
                    
                    let responseDic = response.object! as [String: Any]
                    
                    self.logogArray.removeAllObjects()
                    self.logogArray = NSMutableArray(array: responseDic["filesnew"] as! NSArray)
                    self.logoResultTableView.reloadData()
                    
                    
                    
                }else {
                    //                self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: response.errorMessage)
                }
            }
            
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let detail : NSDictionary = self.logogArray[indexPath.row] as! NSDictionary;
            self.txt_shopName.text = "\(detail.object(forKey: "name") ?? "")"
            self.logoResultTableView.isHidden = true
        }
        
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
        {
            edited = 1
            if edited == 1{
                viewOfGem.backgroundColor = UIColor(named: "07Red")
            }else{
                viewOfGem.backgroundColor = UIColor(named: "07Black")
            }
            var search = ""
            
            
            if string.isEmpty
            {
                search = String(search.dropLast())
            }
            else
            {
                
                search=textField.text!+string
            }
            
            if let text = textField.text as NSString? {
                let txtAfterUpdate = text.replacingCharacters(in: range, with: string)
                if (txtAfterUpdate == "")
                {
                    self.logoResultTableView.isHidden = true
                }
                self.logoResultTableView.isHidden = true
                if (txtAfterUpdate.count >= 3)
                {
                    self.logoResultTableView.isHidden = false
                    self.searchLogo(searchString: search)
                }
            }
            return true
        }
   
        
        
        func showAlertMsg(showalert : String, Header : String, Description: String, cancelBtnStr: String, saveBtnStr: String)
       
        
          //  @IBOutlet weak var alertHeader: UILabel!
          //  @IBOutlet weak var cancelBtn: UIButton!
          //  @IBOutlet weak var alertDescription: UILabel!
           // @IBOutlet weak var saveBtn: UIButton!
           // @IBOutlet weak var alertTransparentBack: UIView!
           // @IBOutlet weak var alertView: UIView!
            
        {
            //saveBtn.setTitle(saveBtn, for: .normal)
        saveBtn.setTitle(saveBtnStr, for: .normal)
        cancelBtn.setTitle(cancelBtnStr, for: .normal)

            alertHeader.text = Header
                   alertDescription.text = Description
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

        
        
    }
    
    extension Sequence where Iterator.Element: Hashable {
        func unique() -> [Iterator.Element] {
            var seen: Set<Iterator.Element> = []
            return filter { seen.insert($0).inserted }
        }
    }
    
    
    //MARK: - PickerVCDelegate
    extension DetailScreenViewController: PickerVCDelegate {
        
        func didSelectedAtIndexes(leftIndex: Int, rightIndex: Int, extendMode: (IndexPath, PackageExtendMode)) {
            
            if (extendMode.1.rawValue == 1)
            {
                let parameterDict =  ["user_id":  singlePackageDetail.user_id ?? "", "id": singlePackageDetail.id ?? "", "type": "waranty_all", "value": "\(leftIndex + 1)", "notification": "\(6)", "status": "\(switch_garanti.isOn == true ? "on" : "off")"]
                
                API_updatePackage(parameterDict: parameterDict) { (true) in
                    self.singlePackageDetail.waranty_months = leftIndex + 1;
                    self.lbl_garnti.text = "\(self.singlePackageDetail.waranty_months) år"
                    
                    self.singlePackageDetail.w_notification_days = 7;
                    self.singlePackageDetail.setNotificationWarrantyDay = self.switch_garanti.isOn == true ? "on" : "off";
                    self.setNotificationIcon()
                    
                }
            }else if (extendMode.1.rawValue == 2)
            {
                let parameterDict =  ["user_id":  singlePackageDetail.user_id ?? "", "id": singlePackageDetail.id ?? "", "type": "return_all", "value": "\(leftIndex + 1)", "notification": "\(6)", "status": "\(switch_return.isOn == true ? "on" : "off")"]
                
                API_updatePackage(parameterDict: parameterDict) { (true) in
                    self.singlePackageDetail.return_days = leftIndex + 1;
                    self.lbl_retur.text = "\(self.singlePackageDetail.return_days) dg."
                    
                    self.singlePackageDetail.notification_days = 7;
                    self.singlePackageDetail.setNotificationReturnDay = self.switch_return.isOn == true ? "on" : "off";
                    self.setNotificationIcon()
                    
                }
                
            }else if (extendMode.1.rawValue == 3)
            {
                let parameterDict =  ["user_id":  singlePackageDetail.user_id ?? "", "id": singlePackageDetail.id ?? "", "type": "pricematch_all", "value": "\(leftIndex + 1)", "notification": "\(6)", "status": "\(switch_priceMatch.isOn == true ? "on" : "off")"]
                
                API_updatePackage(parameterDict: parameterDict) { (true) in
                    self.singlePackageDetail.priceMatchDay = leftIndex + 1;
                    self.lbl_prismatch.text = "\(self.singlePackageDetail.priceMatchDay) dg."
                    
                    self.singlePackageDetail.priceMatchNotificationDay = 7;
                    self.singlePackageDetail.setNotificationPriceMatchDay = self.switch_priceMatch.isOn == true ? "on" : "off";
                    self.setNotificationIcon()
                    
                }
                
            }
            
            
        }
    }
    
    
    extension DetailScreenViewController : CustomCameraVCDelegate,GalleryVCDelegate
    {
        
        
        func returnBackFromGalleryVC()
        {
            self.API_addimage(packageId: self.singlePackageDetail.id)
        }
        
        func imageUploadedSuccssfully()
        {
            self.API_addimage(packageId: self.singlePackageDetail.id)
            
        }
        
        
        	
    }
    
    
    //@IBOutlet weak var view_step1: UIView!
    //
    //@IBOutlet weak var view_lineStep2: UIView!
    //@IBOutlet weak var view_Step2: UIView!
    //
    //@IBOutlet weak var view_lineStep3: UIView!
    //@IBOutlet weak var view_Step3: UIView!
    //
    //@IBOutlet weak var view_lineStep4: UIView!
    //@IBOutlet weak var view_Step4: UIView!
    
    extension UIView
    {
        func selectedStep()
        {
            self.backgroundColor = .systemBlue
        }
        
        func UnSelectedStep()
        {
            self.backgroundColor = .systemGray
        }
    }
    
    extension DetailScreenViewController
    {
        func setSteps(step : String)
        {
            if (step == "0")
            {
                self.view_step1.UnSelectedStep()
                self.view_lineStep2.UnSelectedStep()
                self.view_Step2.UnSelectedStep()
                self.view_lineStep3.UnSelectedStep()
                self.view_Step3.UnSelectedStep()
                self.view_lineStep4.UnSelectedStep()
                self.view_Step4.UnSelectedStep()
                
                
            }
            else if (step == "1")
            {
                self.view_step1.selectedStep()
                self.view_lineStep2.UnSelectedStep()
                self.view_Step2.UnSelectedStep()
                self.view_lineStep3.UnSelectedStep()
                self.view_Step3.UnSelectedStep()
                self.view_lineStep4.UnSelectedStep()
                self.view_Step4.UnSelectedStep()
                
                
            }else if (step == "2")
            {
                self.view_step1.selectedStep()
                self.view_lineStep2.selectedStep()
                self.view_Step2.selectedStep()
                self.view_lineStep3.UnSelectedStep()
                self.view_Step3.UnSelectedStep()
                self.view_lineStep4.UnSelectedStep()
                self.view_Step4.UnSelectedStep()
                
            }else if (step == "3")
            {
                self.view_step1.selectedStep()
                self.view_lineStep2.selectedStep()
                self.view_Step2.selectedStep()
                self.view_lineStep3.selectedStep()
                self.view_Step3.selectedStep()
                self.view_lineStep4.UnSelectedStep()
                self.view_Step4.UnSelectedStep()
                
            }else if (step == "4")
            {
                self.view_step1.selectedStep()
                self.view_lineStep2.selectedStep()
                self.view_Step2.selectedStep()
                self.view_lineStep3.selectedStep()
                self.view_Step3.selectedStep()
                self.view_lineStep4.selectedStep()
                self.view_Step4.selectedStep()
            }
        }
    }
    
    
    //{
    //  "error" : 0,
    //  "status" : "1 Files found",
    //  "files" : [
    //    "\/imguploads\/608_1319_0_1589613983.jpg"
    //  ]
    //}
    
    
    
    //MARK: Custom transition
extension DetailScreenViewController : UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("return")
       let trans = HDZoomAnimatedTransitioning()
        print("zoom: Detailed")
        if(GLOBAL_IMG == nil){
        return nil;}
        trans.transitOriginalView = GLOBAL_IMG
        trans.isPresentation = pr2;
        return trans;
        
    }
//    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let transition = HDZoomAnimatedTransitioning()
//        transition.isPresentation = false
//        transition.transitOriginalView = GLOBAL_IMG
//        return transition
//    }
}
    extension UIView {
        func roundCorners(corners: UIRectCorner, radius: Int = 20) {
            let maskPath1 = UIBezierPath(roundedRect: bounds,
                                         byRoundingCorners: corners,
                                         cornerRadii: CGSize(width: radius, height: radius))
            let maskLayer1 = CAShapeLayer()
            maskLayer1.frame = bounds
            maskLayer1.path = maskPath1.cgPath
            layer.mask = maskLayer1
        }
}
