//
//  ExampleOverlayView.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import Koloda

private let overlayRightImageName = "yesOverlayImage"
private let overlayLeftImageName = "noOverlayImage"

class ExampleOverlayView: OverlayView {
    
    @IBOutlet lazy var overlayImageView: UIImageView! = {
        [unowned self] in
        
        var imageView = UIImageView(frame: self.bounds)
        self.addSubview(imageView)
        
        return imageView
        }()
    
    override var overlayState: SwipeResultDirection? {
        didSet {
            switch overlayState {
            case .left? :
                overlayImageView.image = UIImage(named: overlayLeftImageName)
            case .right? :
                overlayImageView.image = UIImage(named: overlayRightImageName)
            default:
                overlayImageView.image = nil
            }
        }
    }
    
}
