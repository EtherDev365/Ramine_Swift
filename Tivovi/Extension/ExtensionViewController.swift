//
//  ExtensionViewController.swift
//  Tivovi
//
//  Created by TechnoToil on 06/05/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit


extension UIView{
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
           let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
           let mask = CAShapeLayer()
           mask.path = path.cgPath
           layer.mask = mask
       }
       
       
       @IBInspectable
       var masksToBounds: Bool {
           get {
               return layer.masksToBounds
           }
           set {
               layer.masksToBounds = newValue
           }
       }
       
       @IBInspectable
       var cornerRadius: CGFloat {
           get {
               return layer.cornerRadius
           }
           set {
               layer.cornerRadius = newValue
           }
       }
       
    
    @IBInspectable var shadowOffset: CGSize{
        get{
            return self.layer.shadowOffset
        }
        set{
            self.layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowColor: UIColor{
        get{
            return UIColor(cgColor: self.layer.shadowColor!)
        }
        set{
            self.layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable var shadowRadius: CGFloat{
        get{
            return self.layer.shadowRadius
        }
        set{
            self.layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable var shadowOpacity: Float{
        get{
            return self.layer.shadowOpacity
        }
        set{
            self.layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var cornerradius: CGFloat{
        get{
            return self.layer.cornerRadius
        }
        set{
            self.layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor{
        get{
            return UIColor(cgColor: self.layer.borderColor!)
        }
        set{
            self.layer.borderColor = newValue.cgColor
        }
    }
    @IBInspectable var borderWidth: CGFloat{
        get{
            return self.layer.borderWidth
        }
        set{
            self.layer.borderWidth = newValue
        }
    }
    
}
@IBDesignable
extension UIImageView {
    
    
    @IBInspectable
    var imageTintColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                //     layer.shadowColor = color.cgColor
                let templateImage = self.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                self.image = templateImage
                self.tintColor = color
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    
}

