//
//  HDSwipBackPresentationController.swift
//  DnDStudio
//
//  Created by bo on 29/05/2020.
//  Copyright © 2020 Dung Nguyen. All rights reserved.
//

import UIKit

//provider pan swipbackable interactionTransitioning

class HDSwipBackPresentationController: UIPresentationController {
    
    var transitionDidEndCallBack : ((_ containerView : UIView?) -> Swift.Void)?
    
    convenience init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, transitionDidEnd : @escaping (_ containerView : UIView?) -> Swift.Void) {
        
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.transitionDidEndCallBack = transitionDidEnd
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        
        self.transitionDidEndCallBack?(self.containerView)
    }
}
