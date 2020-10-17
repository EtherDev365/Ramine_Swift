//
//  ViewController.swift
//  camera
//
//  Created by Natalia Terlecka on 10/10/14.
//  Copyright (c) 2014 Imaginary Cloud. All rights reserved.
//

import UIKit
import CameraManager
import CoreLocation
import RappleProgressHUD
import SwiftyJSON
import JKNotificationPanel

class CamViewController: UIViewController {
    
    // MARK: - Constants

    let cameraManager = CameraManager()
    let darkBlue = UIColor(red: 4/255, green: 14/255, blue: 26/255, alpha: 1)
    let lightBlue = UIColor(red: 24/255, green: 125/255, blue: 251/255, alpha: 1)
    let redColor = UIColor(red: 229/255, green: 77/255, blue: 67/255, alpha: 1)
    var ImageArray = [UIImage]()
    var packageId = ""
    let user_details = UserModel.sharedInstance
    let pannel = JKNotificationPanel()
    // MARK: - @IBOutlets
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var flashModeImageView: UIImageView!
    @IBOutlet weak var outputImageView: UIImageView!
    @IBOutlet weak var cameraTypeImageView: UIImageView!
    @IBOutlet weak var qualityLabel: UILabel!
    
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var askForPermissionsLabel: UILabel!
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var capturedButton: UIButton!
    
    
    // MARK: - UIViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        //outputImageView.layer.cornerRadius = 5.0
       // outputImageView.backgroundColor = .red
       // outputImageView.clipsToBounds = true
        
        capturedButton.layer.cornerRadius = 8.0
        capturedButton.clipsToBounds = true
        
        cameraManager.shouldEnableExposure = true
        
        cameraManager.shouldFlipFrontCameraImage = false
        cameraManager.showAccessPermissionPopupAutomatically = false
        navigationController?.navigationBar.isHidden = true
        
        cameraButton.isSelected = false
        //cameraButton.backgroundColor = lightBlue
       // outputImageView.image = UIImage(named: "output_image")
        cameraManager.cameraOutputMode = .stillImage
        
        //For Camera Permission
        self.askForCameraPermissions()
        
       // footerView.backgroundColor = darkBlue
       // headerView.backgroundColor = darkBlue
        
        flashModeImageView.image = UIImage(named: "flash_off")
        if cameraManager.hasFlash {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeFlashMode))
            flashModeImageView.addGestureRecognizer(tapGesture)
        }
        
       // outputImageView.image = UIImage(named: "profile")
        let outputGesture = UITapGestureRecognizer(target: self, action: #selector(outputModeButtonTapped))
        outputImageView.isHidden = true
        outputImageView.addGestureRecognizer(outputGesture)
        
        cameraTypeImageView.image = UIImage(named: "switch_camera")
        let cameraTypeGesture = UITapGestureRecognizer(target: self, action: #selector(changeCameraDevice))
        cameraTypeImageView.addGestureRecognizer(cameraTypeGesture)
    
//        qualityLabel.isUserInteractionEnabled = true
//        let qualityGesture = UITapGestureRecognizer(target: self, action: #selector(changeCameraQuality))
//        qualityLabel.addGestureRecognizer(qualityGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isHidden = true
        cameraManager.resumeCaptureSession()
    }
  override var prefersStatusBarHidden: Bool {
      return true
  }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        cameraManager.stopCaptureSession()
    }
    

    // MARK: - ViewController
    fileprivate func addCameraToView()
    {
        cameraManager.addPreviewLayerToView(cameraView, newCameraOutputMode: CameraOutputMode.videoWithMic)
        cameraManager.showErrorBlock = { [weak self] (erTitle: String, erMessage: String) -> Void in
        
            let alertController = UIAlertController(title: erTitle, message: erMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (alertAction) -> Void in  }))
            
            self?.present(alertController, animated: true, completion: nil)
        }
    }
    
    func API_addimage(image:UIImage?) {
        let currentTimeStamp = Date().toMillis()
        let imagePath = "\(self.user_details.user_id ?? "")_\(packageId)_\(local_Id)_\(currentTimeStamp!).jpg"
        let parameterDict =  ["user_id":  self.user_details.user_id ?? "","p_id": packageId ,"local":local_Id]
            var imgData:Data?
                imgData = image!.jpegData(compressionQuality: 0.2)!
       // RappleActivityIndicatorView.startAnimating()
        DashboardManager.API_addImage(information: parameterDict,packageImg: imgData!, imageName: imagePath) { (json, wsResponse, error) in
                RappleActivityIndicatorView.stopAnimation()
                
               if error==nil{
                //print(json)
//                    if json["status"] == true{
//                        //self.pannel.showNotify(withStatus: .success, belowNavigation: self.navigationController!,title: "Image uploaded successfully")
//                     }else {
//                        //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Network Error")
//                    }
                }else{
                    
                    //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Network Error")
                }
            }
        }

    // MARK: - @IBActions

    @IBAction func changeFlashMode(_ sender: UIButton) {
        
        switch cameraManager.changeFlashMode() {
        case .off:
            flashModeImageView.image = UIImage(named: "flash_off")
        case .on:
            flashModeImageView.image = UIImage(named: "flash_on")
        case .auto:
            flashModeImageView.image = UIImage(named: "flash_auto")
        }
    }
    
    @IBAction func recordButtonTapped(_ sender: UIButton) {
        cameraManager.cameraOutputMode = .stillImage
        switch cameraManager.cameraOutputMode {
        case .stillImage:
            cameraManager.capturePictureWithCompletion({ result in
                switch result {
                case .failure:
                    self.cameraManager.showErrorBlock("Error occurred", "Cannot save picture.")
                case .success(let content):
                
                if let capturedImage = content.asImage {
                    self.capturedButton.setBackgroundImage(capturedImage, for: .normal)
                    self.capturedButton.setBackgroundImage(capturedImage, for: .selected)
                    self.capturedButton.setBackgroundImage(capturedImage, for: .highlighted)
                    self.capturedButton.isHidden = false
                    self.ImageArray.append(capturedImage)
                    self.API_addimage(image: capturedImage)
                   // self.outputImageView.isHidden = false
                }
                }
            })
        case .videoWithMic, .videoOnly:
            cameraButton.isSelected = !cameraButton.isSelected
            cameraButton.setTitle("", for: UIControl.State.selected)
    
            cameraButton.backgroundColor = cameraButton.isSelected ? redColor : lightBlue
            if sender.isSelected {
                cameraManager.startRecordingVideo()
            } else {
                cameraManager.stopVideoRecording({ (videoURL, error) -> Void in
                    if error != nil {
                        self.cameraManager.showErrorBlock("Error occurred", "Cannot save video.")
                    }
                })
            }
        }
    }
    

    
    @IBAction func locateMeButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func outputModeButtonTapped(_ sender: UIButton) {
        
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "GalleryVC") as! GalleryVC
        vc.imageArray = self.ImageArray
        vc.packageId = self.packageId
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func changeCameraDevice() {
        cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.front ? CameraDevice.back : CameraDevice.front
    }
    
    @IBAction func askForCameraPermissions() {
        
        self.cameraManager.askUserForCameraPermission({ permissionGranted in
           
            if permissionGranted {
                self.addCameraToView()
            } else {
                if #available(iOS 10.0, *) { 
                  //  UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                } else {
                    // Fallback on earlier versions
                }
            }
        })
    }
    
    @IBAction func changeCameraQuality() {
        
        switch cameraManager.changeQualityMode() {
        case .high:
            qualityLabel.text = "High"
        case .low:
            qualityLabel.text = "Low"
        case .medium:
            qualityLabel.text = "Medium"
        }
    }
}


