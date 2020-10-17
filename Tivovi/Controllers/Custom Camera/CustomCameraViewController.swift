

import UIKit
import AVFoundation
import RappleProgressHUD

protocol CustomCameraVCDelegate {
    func imageUploadedSuccssfully()
}
protocol CaputreButtonDelegate: class {
    func captureImage()
}
protocol CameraControllerDelegate: class {
    func flashButtonAction()
    func switchCameraButtonAction(_ button: UIButton)
    func nextButtonTap(_ button:UIButton)
    func backButtonAction(_ button: UIButton)
}

class CustomCameraViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonNext: UIButton!
     @IBOutlet weak var cameraBackButton: UIButton!
    
    var captureSession = AVCaptureSession()
    var backCamera: AVCaptureDevice?
    var frontCamera: AVCaptureDevice?
    var currentDevice: AVCaptureDevice?
    var photoOutput: AVCapturePhotoOutput?
    var cameraPreviewLayer:AVCaptureVideoPreviewLayer?
    var images1 = [UIImage]()
    var images2 = [UIImage]()
    var selectedIndex = -1
    var packageId = ""
    @IBOutlet weak var flashButton: UIButton!
    let user_details = UserModel.sharedInstance
    var delegate: CustomCameraVCDelegate!
    var buttonDelegate: ButtonsDelegate?
    var dashboardVCDelegate: DashboardMainVCDelegate?
    var webshopVCDelegate: WebShopVCDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        //removed temporarily
        setupCaptureSession()
        setupDevice()
        setupInputOutput()
        setupPreviewLayer()
        captureSession.startRunning()
        buttonNext.layer.cornerRadius = 20
        MenuViewG?.isHidden = true
    }
    
    
    func setupCaptureSession() {
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    
    func setupDevice() {
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        if backCamera != nil {
            currentDevice = backCamera
        } else {
            currentDevice = frontCamera
        }
    }
    
    func setupInputOutput() {
        do {
            if(currentDevice != nil){
                let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice!)
                captureSession.addInput(captureDeviceInput)
                photoOutput = AVCapturePhotoOutput()
                photoOutput!.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
                captureSession.addOutput(photoOutput!)
            }
        } catch {
            //print(error)
        }
    }
    
    func setupPreviewLayer() {
        self.cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.cameraPreviewLayer?.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        self.cameraPreviewLayer?.frame = view.frame
        self.view.layer.insertSublayer(self.cameraPreviewLayer!, at: 0)
    }
    func cameraButton_TouchUpInside() {
        let settings = AVCapturePhotoSettings()
        self.photoOutput?.capturePhoto(with: settings, delegate: self)
        buttonNext.isHidden = false
        cameraBackButton.isHidden = false
    }
    
    func resetAll() {
       // captureSession = AVCaptureSession()
        images1 = [UIImage]()
        images2 = [UIImage]()
        selectedIndex = -1
        packageId = ""
        buttonNext.isHidden = true
        cameraBackButton.isHidden = true
        collectionView.reloadData()
    }
    
    
    //    @IBAction func webshop(_ sender: Any) {
    //        btntype = "webshop"
    //        UIView.animate(withDuration: 0.2,
    //                                            delay: 0.0,
    //                                            animations: {
    //
    //                                              self.BtnPlus.frame = CGRect(x: self.BtnPlus.frame.origin.x, y: self.BtnPlus.frame.origin.y+50, width: self.BtnPlus.frame.width * 0.60, height: self.BtnPlus.frame.height * 0.60)
    //self.BtnPlus.alpha = 0
    //                                               },
    //                                                          completion: { finished in
    //                                                           print("Bug moved right!")
    //
    //
    //                                               })
    //        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
    //      //  self.dismiss(animated: true, completion: nil)
    //        let storyboard = UIStoryboard(name: "NewBoard", bundle: nil)
    //
    //               let vc = storyboard.instantiateViewController(withIdentifier: "webshopsVC") as! webshopsVC
    //                      // vc.shipmentId = singlePackageDetail.id
    //                      GLOBAL_IMG = nil
    //                           //self.navigationController?.present(vc, animated: true, completion: nil)
    //                     // self.navigationController?.pushViewController(vc, animated: true)
    //
    //               let transition = CATransition()
    //               transition.duration = 0.25
    //               transition.type = kCATransitionReveal
    //               transition.subtype = kCATransitionFromRight
    //               transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    //            self.tabBarController?.view.layer.add(transition, forKey: kCATransition)
    //               //self.navigationController?.popToRootViewController(animated: true)
    //               self.navigationController?.pushViewController(vc, animated: false)
    //        }
    //    }
    //    @IBAction func dashboard(_ sender: Any) {
    //        btntype = "dashboard"
    //        UIView.animate(withDuration: 0.2,
    //                                            delay: 0.0,
    //                                            animations: {
    //
    //                                                self.BtnPlus.frame = CGRect(x: self.BtnPlus.frame.origin.x, y: self.BtnPlus.frame.origin.y+50, width: self.BtnPlus.frame.width * 0.60, height: self.BtnPlus.frame.height * 0.60)
    //self.BtnPlus.alpha = 0
    //                                               },
    //                                                          completion: { finished in
    //                                                           print("Bug moved right!")
    //
    //
    //                                               })
    //DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
    //      //  self.dismiss(animated: true, completion: nil)
    //
    //                             // vc.shipmentId = singlePackageDetail.id
    //                             GLOBAL_IMG = nil
    //                                  //self.navigationController?.present(vc, animated: true, completion: nil)
    //                            // self.navigationController?.pushViewController(vc, animated: true)
    //
    //
    //                      let transition = CATransition()
    //                          transition.duration = 0.25
    //                          transition.type = kCATransitionReveal
    //                          transition.subtype = kCATransitionFromLeft
    //                          transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
    //    self.tabBarController?.view.layer.add(transition, forKey: kCATransition)
    //                                        //self.navigationController?.popToRootViewController(animated: true)
    //                                       // self.navigationController?.popViewController(animated: false)
    //
    //                      self.navigationController?.popToRootViewController(animated: false)
    //                      //self.navigationController?.pushViewController(vc, animated: false)
    //        }
    //    }
    
    @IBAction func switchButton(_ sender: UIButton) {
        guard let input = captureSession.inputs[0] as? AVCaptureDeviceInput else { return }
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        var newDevice: AVCaptureDevice?
        if input.device.position == .back {
            newDevice = captureDevice(with: .front)
        } else {
            newDevice = captureDevice(with: .back)
        }
        var deviceInput: AVCaptureDeviceInput!
        do {
            deviceInput = try AVCaptureDeviceInput(device: newDevice!)
        } catch let error {
            //print(error.localizedDescription)
            return
        }
        captureSession.removeInput(input)
        captureSession.addInput(deviceInput)
    }
    func flashAction(_ sender: UIButton) {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video)
            else {return}
        
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                if device.torchMode == AVCaptureDevice.TorchMode.on {
                    device.torchMode = AVCaptureDevice.TorchMode.off
                    //sender.setImage(UIImage(named: "flashOff"), for: .normal)
                    //AVCaptureDevice.TorchModeAVCaptureDevice.TorchMode.off
                } else {
                    do {
                        try device.setTorchModeOn(level: 1.0)
                     //   sender.setImage(UIImage(named: "flashOn"), for: .normal)
                    } catch {
                        //print(error)
                    }
                }
                device.unlockForConfiguration()
            } catch {
                //print(error)
            }
        }
    }
    
    func captureDevice(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [ .builtInWideAngleCamera, .builtInMicrophone, .builtInDualCamera, .builtInTelephotoCamera ], mediaType: AVMediaType.video, position: .unspecified).devices
        for device in devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    var from=""
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if self.images2.count == 0 {
            return
        }
        RappleActivityIndicatorView.startAnimating()
        var imageCount = 0
        var count = 0
        if(packageId == ""){
            let parameterDict =  ["user_id":  self.user_details.user_id ?? ""]
            
            DashboardManager.API_shipment_action2(information: parameterDict) { (json, wsResponse, error) in
                RappleActivityIndicatorView.stopAnimation()
                if error == nil {
                    print(json)
                    
                    self.packageId = json["id"].stringValue
                    //self.API_addimage(packageId: packageId)
                    for image in self.images2 {
                        
                        
                        sleep(1)
                        let currentTimeStamp = Date().toMillis()
                        let imagePath = "\(self.user_details.user_id ?? "")_\(self.packageId)_\(count)_\(currentTimeStamp!)\(count).jpg"
                        let parameterDict =  ["user_id":  self.user_details.user_id ?? "","p_id": self.packageId ,"local":"\(count)"]
                        //print(imagePath)
                        print(parameterDict)
                        var imgData:Data?
                        imgData = image.jpegData(compressionQuality: 0.1)!
                        DashboardManager.API_addImage(information: parameterDict ,packageImg: imgData!, imageName: imagePath) { (json, wsResponse, error) in
                            //print(json)
                            imageCount += 1
                            if imageCount == self.images2.count {
                                RappleActivityIndicatorView.stopAnimation()
                                if(self.from == "detailscreen")
                                {
                                  //  self.delegate.imageUploadedSuccssfully()
                                    
                                    // self.dismiss(animated: true, completion: nil)
                                    self.navigationController?.popViewController(animated: false)
                                }else{
                                     shouldRefreshDashboardData = true
                                    self.buttonDelegate?.scroll(to: .right)
                                    self.dashboardVCDelegate?.callViewLifeCycle()
                                    //self.navigationController?.popToRootViewController(animated: false)
                                    
                                }
                            }
                        }
                        count += 1
                    }
                    
                } else {
                    
                }
            }
        }else{
            for image in self.images2 {
                
                
                sleep(1)
                let currentTimeStamp = Date().toMillis()
                let imagePath = "\(self.user_details.user_id ?? "")_\(packageId)_\(count)_\(currentTimeStamp!)\(count).jpg"
                let parameterDict =  ["user_id":  self.user_details.user_id ?? "","p_id": packageId ,"local":"\(count)"]
                //print(imagePath)
                print(parameterDict)
                var imgData:Data?
                imgData = image.jpegData(compressionQuality: 0.1)!
                DashboardManager.API_addImage(information: parameterDict ,packageImg: imgData!, imageName: imagePath) { (json, wsResponse, error) in
                    //print(json)
                    imageCount += 1
                    if imageCount == self.images2.count {
                        RappleActivityIndicatorView.stopAnimation()
                        if(self.from == "detailscreen")
                        {
                            //self.delegate.imageUploadedSuccssfully()
                            self.navigationController?.popViewController(animated: false)
                            
                        }else{
                            self.navigationController?.popToRootViewController(animated: false)
                            
                        }
                        //self.dismiss(animated: true, completion: nil)
                        
                    }
                }
                count += 1
            }
        }
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.reveal
        transition.subtype = CATransitionSubtype.fromBottom
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        tabBarController?.view.layer.add(transition, forKey: kCATransition)
        //self.navigationController?.popToRootViewController(animated: true)
        resetAll()
        //self.navigationController?.popViewController(animated: false)
        
    }
}

extension CustomCameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            
            let chosenImage = UIImage(data: imageData, scale: 8)!
            self.images1.append(chosenImage)
            self.images2.append(chosenImage)
            self.collectionView.reloadData()
        }
    }
}

extension CustomCameraViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, GICropImageVCDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images2.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        cell.imageView.image = self.images2[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //selectedIndex = indexPath.item
        //let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GIImageCropVC") as! GIImageCropVC
        //let options = GICropImageOptions()
        //options.shapeLayerType = .square
        // vc.options = options
        //vc.image = self.images1[indexPath.item]
        // vc.delegate = self
        // self.present(vc, animated: true, completion: nil)
    }
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?) {
        if let image = croppedImage {
            self.images2[selectedIndex] = image
            self.collectionView.reloadData()
        }
    }
    func getImage(_ croppedImage: UIImage) {
        self.images2[selectedIndex] = croppedImage
        self.collectionView.reloadData()
    }
    
    //optional
    func didCancel() {
        //print("did cancel")
    }
}

extension CustomCameraViewController {
    func loadChildViews(fromParent: MainViewController, scrollView: inout UIScrollView, scrollContainer: inout UIView, cameraDelegate: CameraControllerDelegate) {
        print("i am runing now")
        
        let newBoarStoryboard = UIStoryboard(name: "NewBoard", bundle: nil)
        
        let mainStoryboard = UIStoryboard(name: "Storyboard", bundle: nil)
        let panController =  mainStoryboard.instantiateViewController(withIdentifier: "PanController") as! PanController
        panController.delegate = fromParent as PanControllerDelegate
        panController.cameraDelegate = cameraDelegate
        
        let leftController = newBoarStoryboard.instantiateViewController(withIdentifier: "webshopsVC") as! webshopsVC
        self.webshopVCDelegate = leftController
        fromParent.leftVCDelegate = leftController
        leftController.buttonsDelegate = self.buttonDelegate
        leftController.hideButtomButtonDelegate = fromParent
       
        let rightController = newBoarStoryboard.instantiateViewController(withIdentifier: "DashboardMainVC") as! DashboardMainVC
        self.dashboardVCDelegate = rightController
    
        rightController.hideButtomButtonDelegate = fromParent
        
        fromParent.rightVCDelegate = rightController
        let horizontalControllers = [
            leftController,
            panController,
            rightController
        ]
        leftController.shouldCalculateScrollDirection = false
        rightController.shouldCalculateScrollDirection = false
        view.addSubview(scrollContainer)
        scrollContainer.fit(to: view)
        scrollView = UIScrollView.makeHorizontal(with: horizontalControllers, in: self)
        scrollView.delegate = fromParent as? UIScrollViewDelegate
        scrollContainer.addSubview(scrollView)
        scrollView.fit(to: scrollContainer)
        DispatchQueue.main.async {
            leftController.shouldCalculateScrollDirection = true
            
            rightController.shouldCalculateScrollDirection = true
        }
    }
}

extension CustomCameraViewController: CameraControllerDelegate {
    func backButtonAction(_ button: UIButton) {
        self.backButtonTapped(button)
    }
    
    func flashButtonAction() {
        self.flashAction(flashButton)
    }
    
    func switchCameraButtonAction(_ button: UIButton) {
        self.switchButton(button)
    }
    
    func nextButtonTap(_ button:UIButton) {
        self.nextButtonAction(button)
    }
}

extension CustomCameraViewController: CaputreButtonDelegate {
    func captureImage() {
        self.cameraButton_TouchUpInside()
    }
}
