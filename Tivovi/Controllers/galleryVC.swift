//
//  GalleryVC.swift
//  
//
//  Created by Gags on 14/12/19.
//  Copyright © 2019 akhil. All rights reserved.
//

import UIKit
import Photos
import RappleProgressHUD
import SwiftyJSON
import JKNotificationPanel
import SDWebImage

// Screen height.
public var screenHeight: CGFloat {
    return UIScreen.main.bounds.height
}

protocol GalleryVCDelegate: AnyObject {
    func returnBackFromGalleryVC()
}

class GalleryVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, CustomCameraVCDelegate {

    var myCollectionView: UICollectionView!
    var imageArray=[UIImage]()
    var filesArray=[String]()
    let user_details = UserModel.sharedInstance
    let pannel = JKNotificationPanel()
    var packageId = ""
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    
    var delegate: GalleryVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var frame = CGRect()
        if screenHeight > 800 {
         frame = CGRect(x:0,y:96,width:self.view.frame.width,height:self.view.frame.height-96)
        } else {
         frame = CGRect(x:0,y:72,width:self.view.frame.width,height:self.view.frame.height-72)
        }
        
        let layout = UICollectionViewFlowLayout()
        myCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(PhotoItemCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.backgroundColor=UIColor.white
        self.view.addSubview(myCollectionView)
        
         myCollectionView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) | UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
        if filesArray.count == 0 {
            self.API_addimage(packageId: packageId)
        }
        
       // grabPhotos()
        addTintColor()
    }
    
    func addTintColor() {
        let back = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        backButton.setImage(back, for: .normal)
        backButton.tintColor = UIColor.white
        let camera = UIImage(named: "camera_icon")?.withRenderingMode(.alwaysTemplate)
        cameraButton.setImage(camera, for: .normal)
        cameraButton.tintColor = UIColor.white
    }
    
    func imageUploadedSuccssfully() {
        self.API_addimage(packageId: packageId)
    }
    func API_addimage(packageId:String?) {
         //   RappleActivityIndicatorView.startAnimating()
         let parameterDict =  ["user_id":  self.user_details.user_id ?? "","p_id": packageId ?? "","local":local_Id]
         
         DashboardManager.API_getPackageGallery(information: parameterDict) { (json, wsResponse, error) in
             RappleActivityIndicatorView.stopAnimation()
            print(json);
            
             if error==nil {
                 //print(json)
                if json["error"] == 1 {
                     //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Network Error")
                } else {
                 //print(json["files"])
                    self.filesArray.removeAll()
                 for (_, subJson) in json["files"] {
                    //print(subJson)
                    self.filesArray.append(subJson.stringValue)
                  }
                    self.myCollectionView.reloadData()
                }
             }else {
                 // self.tblMain.reloadData()
             }
         }
     }
    
    //MARK: CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! PhotoItemCell
        let imageObj = NetworkingConstants.defaultImageUrl + filesArray[indexPath.row]
        cell.img.sd_setImage(with: URL(string: imageObj)!, placeholderImage: UIImage())
        cell.img.sd_setImage(with: URL(string: imageObj)!, placeholderImage:  UIImage(), options: .refreshCached, completed: nil)
//        cell.img.setImageWithURL(urlString: imageObj, placeholderImageName: "")
        cell.btnDelete.tag = indexPath.item
        cell.btnDelete.addTarget(self, action: #selector(deleteImage(sender:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print(indexPath)
        let vc=ImagePreviewVC()
        vc.imgArray = self.filesArray
        vc.passedContentOffset = indexPath
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        if DeviceInfo.Orientation.isPortrait {
            return CGSize(width: width/4 - 1, height: width/4 - 1)
        } else {
            return CGSize(width: width/6 - 1, height: width/6 - 1)
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    @objc func deleteImage(sender: UIButton) {
        let otherAlert = UIAlertController(title: "", message: "Are you sure you want to delete this image?", preferredStyle: UIAlertController.Style.alert)

        let printSomething = UIAlertAction(title: "Delete", style: .default) { _ in
               RappleActivityIndicatorView.startAnimating()
            let parameterDict =  ["user_id":  self.user_details.user_id ?? "","p_id": self.packageId ,"del_image":(self.filesArray[sender.tag]).replacingOccurrences(of: "/imguploads/", with: "")]
            
            DashboardManager.API_getPackageGallery(information: parameterDict) { (json, wsResponse, error) in
                RappleActivityIndicatorView.stopAnimation()
                
                if error==nil {
                    //print(json)
                   if json["error"] == 1 {
                        //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Network Error")
                   } else {
                    //print(json["files"])
                    self.filesArray.remove(at: sender.tag)
                    
                    self.myCollectionView.reloadData()
                   }
                }else {
                    // self.tblMain.reloadData()
                }
            }
        }

        let dismiss = UIAlertAction(title: "Cancel", style: .default, handler: nil)

        // relate actions to controllers
        otherAlert.addAction(printSomething)
        otherAlert.addAction(dismiss)

        present(otherAlert, animated: true, completion: nil)
    }
    
    @IBAction func cameraBtnAction(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "CustomCameraViewController") as! CustomCameraViewController
        vc.packageId = packageId
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
        self.delegate?.returnBackFromGalleryVC()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

class PhotoItemCell: UICollectionViewCell {
    
    var img = UIImageView()
    var btnDelete = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        img.contentMode = .scaleAspectFill
        img.clipsToBounds=true
        self.addSubview(img)
        btnDelete.setImage(UIImage(named: "delete"), for: .normal)
        self.addSubview(btnDelete)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        img.frame = self.bounds
        btnDelete.frame = CGRect.init(x: self.frame.size.width-30, y: 0, width: 30, height: 30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct DeviceInfo {
    struct Orientation {
        // indicate current device is in the LandScape orientation
        static var isLandscape: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isLandscape
                    : UIApplication.shared.statusBarOrientation.isLandscape
            }
        }
        // indicate current device is in the Portrait orientation
        static var isPortrait: Bool {
            get {
                return UIDevice.current.orientation.isValidInterfaceOrientation
                    ? UIDevice.current.orientation.isPortrait
                    : UIApplication.shared.statusBarOrientation.isPortrait
            }
        }
    }
}
