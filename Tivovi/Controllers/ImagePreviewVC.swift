//
//  ImagePreviewVC.swift
//  photosApp2
//
//  Created by Muskan on 10/4/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit
import RappleProgressHUD


protocol ImagePreviewVCDelegate: AnyObject {
    func returnBackFromGalleryVC()
}

class ImagePreviewVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    var delegate: ImagePreviewVCDelegate?
    var myCollectionView: UICollectionView!
    var imgArray = [String]()
    var passedContentOffset = IndexPath()
    var currentIndexPath = IndexPath()
    var panGestureRecognizer: UIPanGestureRecognizer?
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(_:)))
        view.addGestureRecognizer(panGestureRecognizer!)
        self.view.backgroundColor=UIColor.black
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing=0
        layout.minimumLineSpacing=0
        layout.scrollDirection = .horizontal
        
      //  let pagercount = UIPageControl()
        
        
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(ImagePreviewFullViewCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.isPagingEnabled = true
        self.view.addSubview(myCollectionView)
        
        myCollectionView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) | UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.currentIndexPath = self.passedContentOffset
            self.myCollectionView.scrollToItem(at: self.passedContentOffset, at: .centeredHorizontally, animated: false)
        }
        let crossButton = UIButton(frame: CGRect.init(x: 5, y: 20, width: 30, height: 30))
        crossButton.setImage(UIImage(named: "backwhite"), for: .normal)
        crossButton.addTarget(self, action: #selector(dismissScreen(sender:)), for: .touchUpInside)
        self.view.addSubview(crossButton)
        
        let downloadButton = UIButton(frame: CGRect.init(x: (self.view.frame.size.width-60), y: 20, width: 50, height: 30))
        downloadButton.setImage(UIImage(named: "download"), for: .normal)
        downloadButton.addTarget(self, action: #selector(downloadImages(sender:)), for: .touchUpInside)
        self.view.addSubview(downloadButton)
    }
    @objc func dismissScreen(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.delegate?.returnBackFromGalleryVC()

    }
    @objc func downloadImages(sender: UIButton) {
        RappleActivityIndicatorView.startAnimating()
        DispatchQueue.global(qos: DispatchQoS.background.qosClass).async {
            do {
                let data = try Data(contentsOf: URL(string: NetworkingConstants.defaultImageUrl + self.imgArray[self.currentIndexPath.row])!)
                let getImage = UIImage(data: data)
                DispatchQueue.main.async {
                    guard let selectedImage = getImage else {
                        //print("Image not found!")
                        return
                    }
                    UIImageWriteToSavedPhotosAlbum(selectedImage, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                    return
                }
            }
            catch {
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
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImagePreviewFullViewCell
        let imageObj = NetworkingConstants.defaultImageUrl + imgArray[indexPath.row]
        cell.imgView.setImageWithURL(urlString: imageObj, placeholderImageName: "")
        return cell
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        for cell in myCollectionView.visibleCells {
            if let indexPath = myCollectionView.indexPath(for: cell) {
                self.currentIndexPath = indexPath
            }
        }
    }
    @objc func panGestureAction(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)

         if sender.state == UIGestureRecognizer.State.began {
             initialTouchPoint = touchPoint
         } else if sender.state == UIGestureRecognizer.State.changed {
             if touchPoint.y - initialTouchPoint.y > 0 {
                 self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
             }
         } else if sender.state == UIGestureRecognizer.State.ended || sender.state == UIGestureRecognizer.State.cancelled {
             if touchPoint.y - initialTouchPoint.y > 100 {
                 self.dismiss(animated: true, completion: nil)
             } else {
                 UIView.animate(withDuration: 0.3, animations: {
                     self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                 })
             }
         }
        self.dismiss(animated: false, completion: nil)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        flowLayout.itemSize = myCollectionView.frame.size
        
        flowLayout.invalidateLayout()
        
        myCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let offset = myCollectionView.contentOffset
        let width  = myCollectionView.bounds.size.width
        
        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)
        
        myCollectionView.setContentOffset(newOffset, animated: false)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.myCollectionView.reloadData()
            
            self.myCollectionView.setContentOffset(newOffset, animated: false)
        }, completion: nil)
    }

}


class ImagePreviewFullViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    var scrollImg: UIScrollView!
    var imgView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollImg = UIScrollView()
        scrollImg.delegate = self
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()
        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 4.0
        
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        scrollImg.addGestureRecognizer(doubleTapGest)
        
        self.addSubview(scrollImg)
        
        imgView = UIImageView()
        imgView.image = UIImage(named: "user3")
        scrollImg.addSubview(imgView!)
        imgView.contentMode = .scaleAspectFit
    }
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollImg.zoomScale == 1 {
            scrollImg.zoom(to: zoomRectForScale(scale: scrollImg.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollImg.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imgView.frame.size.height / scale
        zoomRect.size.width  = imgView.frame.size.width  / scale
        let newCenter = imgView.convert(center, from: scrollImg)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollImg.frame = self.bounds
        imgView.frame = self.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollImg.setZoomScale(1, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

