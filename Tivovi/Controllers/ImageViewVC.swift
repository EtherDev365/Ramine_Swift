//
//  ImageViewVC.swift
//  Tivovi
//
//  Created by Hardik on 6/5/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit
import RappleProgressHUD

protocol ImageViewVCDelegate: AnyObject {
    func returnBackFromVC()
}


class ImageViewVC: UIViewController {

    @IBOutlet weak var pageCounter: UIPageControl!
    @IBOutlet weak var clvData: UICollectionView!
    @IBOutlet weak var btnSlet: UIButton!
    @IBOutlet weak var btnDownload: UIButton!
    @IBOutlet weak var lblNoData: UILabel!
    
   // var scrollImg: UIScrollView!
    var context : DetailScreenViewController!
    var imgArray = [String]()
    var passedContentOffset = IndexPath()
    var currentIndexPath = IndexPath()
    var delegate: ImageViewVCDelegate?
    let user_details = UserModel.sharedInstance
    var packageId = ""
    let itemcell = "ImageViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: itemcell, bundle: nil)
        clvData.register(nib, forCellWithReuseIdentifier: itemcell)
        clvData.delegate = self
        clvData.dataSource = self
        self.lblNoData.isHidden = true
        print(packageId , "self.API_addimage(packageId: packageId)")

       
        
       
        
         clvData.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) | UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
    }
    
    
    override func viewWillAppear(_ animated: Bool) {

        DispatchQueue.main.async {
            self.currentIndexPath = self.passedContentOffset
            self.clvData.scrollToItem(at: self.passedContentOffset, at: .centeredHorizontally, animated: false)
        }
        
    }
   
    
  
    
    @IBAction func onClickBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.returnBackFromVC()
    }
    
    func deleteImage(packageId:String){
        let visibleRect = CGRect(origin: self.clvData.contentOffset, size: self.clvData.bounds.size)
               let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
               if let visibleIndexPath = self.clvData.indexPathForItem(at: visiblePoint) {
                  let otherAlert = UIAlertController(title: "", message: "Are you sure you want to delete this image?", preferredStyle: UIAlertController.Style.alert)

                  let printSomething = UIAlertAction(title: "Delete", style: .default) { _ in
                         RappleActivityIndicatorView.startAnimating()
                   /*let parameterDict =  ["user_id":  self.user_details.user_id ?? "","p_id": packageId ,"del_image":String(visibleIndexPath.row)]*/
                    let parameterDict =  ["user_id":  self.user_details.user_id ?? "","p_id": packageId ,"del_image":(self.imgArray[visibleIndexPath.row]).replacingOccurrences(of: "/imguploads", with: "")]
                   print(parameterDict , "parameterDict")
                      
                      DashboardManager.API_getPackageGallery(information: parameterDict) { (json, wsResponse, error) in
                          RappleActivityIndicatorView.stopAnimation()
                          
                          if error==nil {
                              //print(json)
                             if json["error"] == 1 {
                                  //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Network Error")
                             } else {
                              //print(json["files"])
                                self.imgArray.remove(at: Int(visibleIndexPath.row))
                              
                           self.clvData.reloadData()
                           self.context.singlePackageDetail.imageUrls = self.imgArray
                                
                               if self.imgArray.count == 0{
                                   self.lblNoData.isHidden = false
                                   self.btnSlet.isHidden = true
                                   self.context.noImageAvailable.isHidden = false
                                       
                                   }else{
                                   self.context.noImageAvailable.isHidden = true
                                   }
                               }
                           self.context.collectionview_allImages.reloadData()
                             
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
               
        
    }
    
    @IBAction func onClickSlet(_ sender: Any) {
        deleteImage(packageId: String(self.packageId))
    }
    
    @IBAction func onClickDownload(_ sender: Any) {
        RappleActivityIndicatorView.startAnimating()
        print("Enter")
               DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
                   do {
                       let data = try Data(contentsOf: URL(string: NetworkingConstants.defaultImageUrl + self.imgArray[self.currentIndexPath.row])!)
                       let getImage = UIImage(data: data)
                    print("do")
                       DispatchQueue.main.async {
                        print("DispatchQueue")
                           guard let selectedImage = getImage else {
                               //print("Image not found!")
                               return
                           }
                           UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                           return
                       }
                    print("get image")
                   }
                   catch {
                    print("catch")
                           return
                   }
               }

        }
        //MARK: - Add image to Library
        @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            RappleActivityIndicatorView.stopAnimation()
            if let error = error {
                // we got back an error!
                showAlertWith(title: "Save error", message: error.localizedDescription)
            } else {
                showAlertWith(title: "Saved!", message: "Your image has been saved to your photos.")
            }
        }
    func showAlertWith(title: String, message: String){
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
}

extension ImageViewVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            print(imgArray.count , "imgArray.count")
           return imgArray.count
       }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = clvData.dequeueReusableCell(withReuseIdentifier: itemcell, for: indexPath)as! ImageViewCell
        let imageObj = NetworkingConstants.defaultImageUrl + imgArray[indexPath.row]
        cell.imgProduct.setImageWithURL(urlString: imageObj, placeholderImageName: "")
        
//        cell.scrollImg.delegate = self
//        cell.scrollImg.alwaysBounceVertical = false
//        cell.scrollImg.alwaysBounceHorizontal = false
//        cell.scrollImg.showsVerticalScrollIndicator = true
//        cell.scrollImg.flashScrollIndicators()
//        cell.scrollImg.minimumZoomScale = 1.0
//        cell.scrollImg.maximumZoomScale = 4.0
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return 1.0
       }
       
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: clvData.frame.width, height: clvData.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
              
                   pageCounter.hidesForSinglePage = true
                   pageCounter.numberOfPages = imgArray.count
                   self.pageCounter.currentPage = indexPath.section
              
           }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in clvData.visibleCells {
            if let indexPath = clvData.indexPath(for: cell) {
                self.currentIndexPath = indexPath
                print(currentIndexPath ,"clvData->CurrentIndexpath")
            }
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print("scoller")
        let visibleRect = CGRect(origin: self.clvData.contentOffset, size: self.clvData.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = self.clvData.indexPathForItem(at: visiblePoint) {
            self.pageCounter.currentPage = visibleIndexPath.row
            print(visibleIndexPath.row, "index")
        }
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
         print(imgArray.count)
        if imgArray.count == 0{
            lblNoData.isHidden = false
        }
        
        guard let flowLayout = clvData.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        flowLayout.itemSize = clvData.frame.size
        
        flowLayout.invalidateLayout()
        
        clvData.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let offset = clvData.contentOffset
        let width  = clvData.bounds.size.width
        
        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)
        
        clvData.setContentOffset(newOffset, animated: false)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.clvData.reloadData()
            
            self.clvData.setContentOffset(newOffset, animated: false)
        }, completion: nil)
    }
    
}
