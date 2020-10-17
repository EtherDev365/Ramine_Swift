//
//  ExtUtility.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import AEAccordion
extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineHeight: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: size.width, height: lineHeight)))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    func resize(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func scale(image: UIImage, by scale: CGFloat) -> UIImage? {
        let size = image.size
        let scaledSize = CGSize(width: size.width * scale, height: size.height * scale)
        return self.resize(image: image, targetSize: scaledSize)
    }
}

extension UIViewController
{
    func loadXib(SView:UIView,value:UINavigationController)
    {
        let subV = HeaderView()
        SView.addSubview(subV.instantXib(frame: SView.frame,value: value))
    }
    func loadSection(SView:UIView,value:UINavigationController,lblnumber:String,status:String,imgArr:String,logoImg:String,tagId:Int){
        let subV = SectionView()
        SView.addSubview(subV.loadSection(frame: SView.frame, value: value, lblnumber: lblnumber, status: status, imgArr: imgArr,logoImg:logoImg,tagId:tagId))
        
        
    }
    func fillCellVal(SView:UIView,value:UINavigationController,lblCat:String,lblTitle:String,lblStatus:String,lblPlace:String,lblShares:String,lblComments:String,lblLastUpdate:String,lblNumber:String,m_id:String,comment_count:String){
        let subV = CellView()
        SView.addSubview(subV.fillCellVal(frame: SView.frame, value: value, lblCat: lblCat, lblTitle: lblTitle, lblStatus: lblStatus, lblPlace: lblPlace, lblShares: lblShares, lblComments: lblComments, lblLastUpdate: lblLastUpdate, lblNumber: lblNumber, m_id: m_id,comment_count:comment_count))
    }
}
extension AccordionTableViewController
{
     func loadXibOne(SView:UIView,value:UINavigationController)
    {
        let subV = HeaderView()
        SView.addSubview(subV.instantXib(frame: SView.frame,value: value))
    }
}

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
