//
//  ImageViewCell.swift
//  Tivovi
//
//  Created by Hardik on 6/5/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit

class ImageViewCell: UICollectionViewCell, UIScrollViewDelegate {

    @IBOutlet weak var imgProduct: UIImageView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var scrollImg: UIScrollView!

    var panGestureRecognizer: UIPanGestureRecognizer?
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //scrollImg = UIScrollView()
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
        

        
    }
    

    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
           if scrollImg.zoomScale == 1 {
            print("zoom")
               scrollImg.zoom(to: zoomRectForScale(scale: scrollImg.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
           } else {
            print("notzomm")
               scrollImg.setZoomScale(1, animated: true)
           }
       }
       
       func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
            print("zoomin")
           var zoomRect = CGRect.zero
           zoomRect.size.height = imgProduct.frame.size.height / scale
           zoomRect.size.width  = imgProduct.frame.size.width  / scale
           let newCenter = imgProduct.convert(center, from: scrollImg)
           zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
           zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
            print(zoomRect.origin.x,"zoomRect.origin.x")
            print(zoomRect.origin.y,"zoomRect.origin.y")
           return zoomRect
       }
       
       func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        print("viewForZooming")
           return self.imgProduct
       }
       
       override func layoutSubviews() {
           super.layoutSubviews()
           scrollImg.frame = self.bounds
           imgProduct.frame = self.bounds
        print("layoutSubviews")
       }
       
       override func prepareForReuse() {
           super.prepareForReuse()
           scrollImg.setZoomScale(1, animated: true)
        print("prepareForReuse")
        
       }
       
//       required init?(coder aDecoder: NSCoder) {
//           fatalError("init(coder:) has not been implemented")
//       }

}
