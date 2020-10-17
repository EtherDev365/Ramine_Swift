//
//  HDZoomTransitionVCExtension.swift
//  DnDStudio
//
//  Created by bo on 29/05/2020.
//  Copyright © 2020 Dung Nguyen. All rights reserved.
//

import UIKit

extension UIViewController {
    
    //set the  presented viewController,
    //originalView: Which being tap in presenting view
    public func hd_setZoomTransition(originalView : UIView) {
        self.modalPresentationStyle = .custom
        self.modalPresentationCapturesStatusBarAppearance = true
        let transitioner = HDZoomTransitioner.init(vc: self)
        transitioner.transitOriginalView = originalView
        self.hd_transitioner = transitioner
        self.transitioningDelegate = self.hd_transitioner
    }
    
    public var hd_swipeBackDisabled : Bool {
        get {
            if let trans = self.hd_transitioner {
                return trans.swipeBackDisabled
            } else {
                return false
            }
        }
        
        set {
            self.hd_transitioner?.swipeBackDisabled = newValue
        }
    }
    
    
    private struct AssociatedKey {
        static var ZoomTransitioner = "hd_zoomTransitioner"
    }
    
    private var hd_transitioner : HDZoomTransitioner?{
        get {
            if let transitioner = objc_getAssociatedObject(self, &AssociatedKey.ZoomTransitioner) as? HDZoomTransitioner {
                return transitioner
            } else {
                return nil
            }
        }
        
        set {
            objc_setAssociatedObject(self, &AssociatedKey.ZoomTransitioner, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    
}
