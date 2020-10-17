//
//  BWPhotoManager.swift
//  GreetApp
//
//  Created by Padam on 28/06/19.
//  Copyright © 2019 Bluereeftech. All rights reserved.
//

import UIKit
import AVFoundation

typealias PhotoTakingHelperCallback = ((Any?) -> Void)
typealias CallbackwithURL = ((UIImage?) -> Void)

enum ImagePickerOptions: Int {
  case camera
  case gallery
}

enum MediaType: Int {
    case video
    case image
}

private struct constant {  
  static let actionTitle = "Choose From"
  static let actionMessage = "Please select an option to choose image"
  static let actionMessageVideo = "Please select an option to choose video"
  static let cameraBtnTitle = "Take Picture"
  static let videoBtnTitle = "Record Video"
  static let removecameraBtnTitle = "Remove Picture"
  static let removevideoBtnTitle = "Remove Video"
  static let galeryBtnTitle = "Select From Gallery"
  static let cancelBtnTitle = "Cancel"
  static let settingsBtnTitle = "Go to Settings"
  static let permissionDenied = "Camera access is absolutely necessary to use this app"
}

@objc class BWPhotoManager:NSObject {
  
  let imagePicker = UIImagePickerController()
  internal var navController: UINavigationController!
  internal var callback: PhotoTakingHelperCallback!
  var allowEditing: Bool
  var isFromEdit: Bool
  var mediaType :MediaType  = .image;
  
  /*
   Intialize the navController from give reference of navigationcontroller while creating Photomanager class object.
   Callback: Callback will be call after the picking image.
   */
    init(navigationController:UINavigationController,mediaType:MediaType, allowEditing:Bool,isFromEdit:Bool , callback:@escaping PhotoTakingHelperCallback) {
    
    self.navController = navigationController
    self.callback = callback
    self.allowEditing = allowEditing
    self.mediaType = mediaType;
    self.isFromEdit = isFromEdit
    super.init()
    presentActionSheet()
//    if checkPhotoLibraryPermission() == true {
      
//    }else{
//        let alertController = UIAlertController(title: AlertHeader.kAppName , message: constant.permissionDenied, preferredStyle: .alert)
//
//        let settingsButton = UIAlertAction(title: constant.settingsBtnTitle, style: .default, handler: { (action) -> Void in
//            UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
//        })
//        alertController.addAction(settingsButton)
//
//        let cancelButton = UIAlertAction(title: constant.cancelBtnTitle, style: .destructive, handler: { (action) -> Void in
//
//        })
//        alertController.addAction(cancelButton)
//
//        navController.present(alertController, animated: true, completion: nil)
    //}
  }
 
  
  //MARK: ImagePicker Custom Functions
  /// Presenting sheet with option to select image source
  private func presentActionSheet() {
    let actionMessage = self.mediaType == .image ? constant.actionMessage : constant.actionMessageVideo
    let cameraBtnTitle = self.mediaType == .image ? constant.cameraBtnTitle : constant.videoBtnTitle
    let removeBtnTitle = self.mediaType == .image ? constant.removecameraBtnTitle : constant.removevideoBtnTitle
    

    
    let alertController = UIAlertController(title:  constant.actionTitle, message: actionMessage, preferredStyle: .actionSheet)
    
    let cameraButton = UIAlertAction(title: cameraBtnTitle, style: .default, handler: { (action) -> Void in
        self.presentUIimagePicker(type: .camera )
      })
      alertController.addAction(cameraButton)
    
    let  galleryButton = UIAlertAction(title: constant.galeryBtnTitle, style: .default, handler: { (action) -> Void in
      self.presentUIimagePicker(type: .photoLibrary)
    })
    alertController.addAction(galleryButton)
    if(self.isFromEdit == true){
        let removeButton = UIAlertAction(title: removeBtnTitle, style: .destructive, handler: { (action) -> Void in
            self.callback(nil);
        })
        alertController.addAction(removeButton)
    }
    
    let cancelButton = UIAlertAction(title: constant.cancelBtnTitle, style: .cancel, handler: { (action) -> Void in
      
    })
    alertController.addAction(cancelButton)
    navController.navigationBar.barTintColor = UIColor.white;
    
    navController.present(alertController, animated: true, completion: nil)
  }
  
  
  
  private func checkPhotoLibraryPermission()-> Bool {
    
    var isEnabled = false
    
    let authorizationStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
    
    switch authorizationStatus {
    case .notDetermined:
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
        if granted {
          isEnabled = true
          //print("access granted")
        }
        else {
          isEnabled = false
          //print("access denied")
        }
      }
    case .authorized:
      isEnabled = true
      
      //print("Access authorized")
    case .denied, .restricted:
      isEnabled = false
      //print("restricted")
    }
    return isEnabled
  }
  
  
  
  
  /*
   presentUIimagePicker will present the UIImagePicker with give type
   type: Camera or Gallery
   controller: UINavigationcontroller, navigationcontroller on with uiimagepicker will present.
   */
    private func presentUIimagePicker(type: UIImagePickerController.SourceType){
        if(self.mediaType == .video){
            imagePicker.mediaTypes = ["public.movie"]
        }
        imagePicker.allowsEditing = self.allowEditing
        
        imagePicker.sourceType = type
        imagePicker.delegate = self
        imagePicker.navigationBar.isTranslucent = false;
//        imagePicker.navigationBar.barTintColor = UIColor.white
//        imagePicker.navigationBar.tintColor = COLOR.navTintColor
//        navController.navigationBar.tintColor = COLOR.navTintColor
//        navController.navigationBar.barTintColor = COLOR.navBarColor
        navController.present(imagePicker, animated: true, completion: nil)
  }
  
}
//MARK: ------------------------Class End------------------------------------



//MARK: ------------------------Class Extension------------------------------------

/*Extension for UIImagePickerControllerDelegate & UINavigationControllerDelegate
 
 
 */
extension BWPhotoManager: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    
        if allowEditing {
            if #available(iOS 9.1, *) {
//               guard let pickedImage = info[.editedImage]  else {
//
//                }
//                callback(pickedImage)
                
            } else {
                // Fallback on earlier versions
            }
        }
        else{
//            guard let pickedImage = info[.originalImage]  else {
//
//            }
//            callback(pickedImage)
            
    }
    self.navController.dismiss(animated: true, completion: nil)
  }
  
  
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    self.navController.dismiss(animated: true, completion: nil)
  }
}






