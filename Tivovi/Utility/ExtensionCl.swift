//
//  ExtensionCl.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import AVFoundation
import Nuke



extension UIView {
    
    // If Swift version is lower than 4.2,
    // You should change the name. (ex. var renderedImage: UIImage?)
    var imageRender: UIImage? {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in layer.render(in: rendererContext.cgContext) }
    }
}

extension UIImageView {
    
    func getPlaceHolderImage(text: String) -> UIImage {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        view.backgroundColor = UIColor.clear
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        label.textColor = UIColor.white
        label.text = text
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        view.addSubview(label)
        return view.imageRender!
    }
    
    var imageSize: CGSize {
        if let image = image {
            return AVMakeRect(aspectRatio: image.size, insideRect: bounds).size
        }
        return CGSize.zero
    }
    
    var contentClippingRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }
        
        let scale: CGFloat
        if image.size.width > image.size.height {
            scale = bounds.width / image.size.width
        } else {
            scale = bounds.height / image.size.height
        }
        
        let size = CGSize(width: image.size.width * scale, height: image.size.height * scale)
        let x = (bounds.width - size.width) / 2.0
        let y = (bounds.height - size.height) / 2.0
        
        return CGRect(x: x, y: y, width: size.width, height: size.height)
    }
    
    
    func setImageWithURL(urlString:String, placeholderImageName:String?) {
        
        guard let url = URL(string: urlString) else {return}
        
        let request = NukeMethods.makeRequest(url: url, view: self)
        
        if let placeholderImage = placeholderImageName {
            DispatchQueue.main.async {
                self.image = UIImage(named: placeholderImage)
            }
        } else {
            DispatchQueue.main.async {
                self.image = nil
            }
        }

        Nuke.loadImage(with: request, options: .shared, into: self, progress: nil) { (response, error) in
            guard let image = response?.image else {return}
            NukeMethods.setImage(image, to: self)
        }
        
    }
    
    func setImageWithURL(urlString:String, placeholderImage:UIImage?) {
        
        guard let url = URL(string: urlString) else {return}
        
        let request = NukeMethods.makeRequest(url: url, view: self)
        
        DispatchQueue.main.async {
            self.image = placeholderImage
        }
        
        Nuke.loadImage(with: request, options: .shared, into: self, progress: nil) { (response, error) in
            guard let image = response?.image else {return}
            NukeMethods.setImage(image, to: self)
        }
        
    }
    
    
    func setImageWithURLAndLoader(urlString:String, placeholderImageName:String?, loader:UIActivityIndicatorView) {
        
        loader.isHidden = false
        loader.hidesWhenStopped = true
        loader.startAnimating()
        
        guard let url = URL(string: urlString) else {return}
        
        let request = NukeMethods.makeRequest(url: url, view: self)
        
        if let placeholderImage = placeholderImageName {
            DispatchQueue.main.async {
                self.image = UIImage(named: placeholderImage)
            }
        } else {
            DispatchQueue.main.async {
                self.image = nil
            }
        }
        
//        Manager.shared.loadImage(with: request, into: self) { (result, status) in
//
//            loader.stopAnimating()
//            guard let image = result.value else {return}
//            NukeMethods.setImage(image, to: self)
//        }
        
        Nuke.loadImage(with: request, options: .shared, into: self, progress: nil) { (response, error) in
            guard let image = response?.image else {return}
            NukeMethods.setImage(image, to: self)
          }
        }
}

extension UITextField {
    
    func setBottomBorder() {
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
                case 2436:
                    let border = CALayer()
                    let width = CGFloat(2.0)
                    border.borderColor = UIColor(red:0.90, green:0.00, blue:0.00, alpha:1.0).cgColor
                    border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width+30, height: self.frame.size.height)
                    border.borderWidth = width
                    self.layer.addSublayer(border)
                    self.layer.masksToBounds = true
                case 2688:
                    let border = CALayer()
                    let width = CGFloat(2.0)
                    border.borderColor = UIColor(red:0.90, green:0.00, blue:0.00, alpha:1.0).cgColor
                    border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width+30, height: self.frame.size.height)
                    border.borderWidth = width
                    self.layer.addSublayer(border)
                    self.layer.masksToBounds = true
                case 1792:
                    let border = CALayer()
                    let width = CGFloat(2.0)
                    border.borderColor = UIColor(red:0.90, green:0.00, blue:0.00, alpha:1.0).cgColor
                    border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width+30, height: self.frame.size.height)
                    border.borderWidth = width
                    self.layer.addSublayer(border)
                    self.layer.masksToBounds = true
                default:
                    let border = CALayer()
                    let width = CGFloat(2.0)
                    border.borderColor = UIColor(red:0.90, green:0.00, blue:0.00, alpha:1.0).cgColor
                    border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
                    border.borderWidth = width
                    self.layer.addSublayer(border)
                    self.layer.masksToBounds = true
            }
        }
    }
}

extension Bundle {
    
    var versionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
    
    var bundleName: String? {
        return infoDictionary?["CFBundleName"] as? String
    }
}


extension NSDictionary {
    
    class func convertStringToDictionary(text: String) -> [String:AnyObject]? {
        if let data = text.data(using: String.Encoding.utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String:AnyObject]
            } catch let error as NSError {
                ////print(error)
            }
        }
        return nil
    }
}



class NukeMethods {

    class func makeRequest(url: URL, view: UIImageView) -> ImageRequest {
        var request = ImageRequest(url: url)
        request.processor = AnyImageProcessor(ImageDecompressor(targetSize: targetSize(for: view), contentMode: .aspectFill))
        return request
    }

    class func targetSize(for view: UIView) -> CGSize { // in pixels
        let scale = UIScreen.main.scale
        let size = view.bounds.size
        return CGSize(width: size.width * scale, height: size.height * scale)
    }

    class func setImage(_ image : UIImage, to imageView : UIImageView) {
        DispatchQueue.main.async {
            imageView.image = image
        }
    }

}

extension Date {
    
    func addMonth(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .month, value: n, to: self)!
    }
    
    func addYear(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .year, value: n, to: self)!
    }
    
    func addDay(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .day, value: n, to: self)!
    }
    
    func addSec(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .second, value: n, to: self)!
    }
    
    func minusMonth(n: Int) -> Date {
        let cal = NSCalendar.current

        return cal.date(byAdding: .month, value: -n, to: self)!
    }
    
    func minusYear(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .year, value: -n, to: self)!
    }
    
    func minusDay(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .day, value: -n, to: self)!
    }
    
    func minusSec(n: Int) -> Date {
        let cal = NSCalendar.current
        return cal.date(byAdding: .second, value: -n, to: self)!
    }
    
    public static func daysBetween(start: Date, end: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: start, to: end).day!
    }
}

extension UIViewController {
    func showAlertController(title: String?, message: String?) {
        if message?.isEmpty ?? false { return }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
