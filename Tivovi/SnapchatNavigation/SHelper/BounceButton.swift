//
//  BounceButton.swift
//  SnapchatNavigation
//
//  Created by inder on 24/08/20.
//  Copyright © 2020 Artur Chabera. All rights reserved.
//

import Foundation
import  UIKit
class BounceButton: UIButton {
    var shouldBounce = false
    override var isHighlighted: Bool {
        didSet {
            super.isHighlighted = false
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //self.layer.cornerRadius = 28.5
        showsTouchWhenHighlighted = false
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //self.layer.cornerRadius = 28.5
        showsTouchWhenHighlighted = false
        
    }
    
    // Add some animations on button click
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isTransitionRunning {return}
        super.touchesBegan(touches, with: event)
        if !shouldBounce { return }
        // Scale up the button
        
        UIView.animate(withDuration: 0.1, animations: {
            // Reset the sizes to defaults
            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if !shouldBounce { return }
        UIView.animate(withDuration: 0.3, animations: {
            self.transform = CGAffineTransform.identity
        }, completion: nil)
        
    }
}


