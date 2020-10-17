//
//  ButtonsController.swift
//  SnapchatNavigation
//
//  Created by Artur Chabera on 08/03/2019.
//  Copyright © 2019 Artur Chabera. All rights reserved.
//

import UIKit

protocol ButtonsDelegate: class {
    func scroll(to panel: Panel)
    func backToCamera()
}


protocol ButtonsAnimateDelegate: class {
    func animateButtonsWith(offest: CGFloat, _ shouldAnimate:Bool)
    func shouldBounce(bool: Bool)
}
var isTransitionRunning = false

class ButtonsController: UIViewController {
    
    weak var delegate: ButtonsDelegate?
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var centerButton: BounceButton!
    
    @IBOutlet weak var leftBar: UIView!
    @IBOutlet weak var rightBar: UIView!
    @IBOutlet weak var rightButton: UIButton!
    var orignalTransform: CGAffineTransform!
    var buttonContainer:UIView!
    var leftButtonCenterX:CGFloat!
    var rightButtonCenterX:CGFloat!
    var bottomViewLeftWidth:CGFloat =  32
    var bottomViewRightWidth:CGFloat = 42
    var bottomViewIntialCenter: CGFloat!
    
    var cameraButtonInitialCenterY: CGFloat!
    var cameraButtonTopSpace: CGFloat = 20
    var cameraButtonBottomSpace: CGFloat = 5

    var webShopVC: webshopsVC?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if orignalTransform == nil {
        orignalTransform = centerButton.transform
        leftButtonCenterX = leftButton.center.x
        rightButtonCenterX = rightButton.center.x
        }
    }
    
  
    
    private func setupUI() {
        leftButton.tag = 0
        leftButton.addTarget(self, action: #selector(changePanel(_:)), for: .touchUpInside)
        
        centerButton.tag = 1
        centerButton.addTarget(self, action: #selector(changePanel(_:)), for: .touchUpInside)
        
        rightButton.tag = 2
        rightButton.addTarget(self, action: #selector(changePanel(_:)), for: .touchUpInside)
    }
    
   
    @objc private func changePanel(_ sender: UIButton) {
        if isTransitionRunning { return }
        switch sender.tag {
        case 0: delegate?.scroll(to: .left)
        case 1: delegate?.scroll(to: .center)
        case 2: delegate?.scroll(to: .right)
        default: break
        }
    }
      var barToMove: UIView!
    func animateButtons(_ offset: CGFloat, _ shouldAnimateCameraButton: Bool = true ) {
        DispatchQueue.main.async {
            if abs(offset) == 1 || abs(offset) == 0 {
                
                 isTransitionRunning = false
                
            } else {
                 isTransitionRunning = true
            }
          
        if shouldAnimateCameraButton {
            if self.cameraButtonInitialCenterY == nil {
                self.cameraButtonInitialCenterY = self.centerButton.center.y
            }
            let incresedValue = abs(offset) * 80
            let newCenterValue = self.cameraButtonInitialCenterY + incresedValue
            if newCenterValue > self.cameraButtonInitialCenterY && newCenterValue < (self.view.frame.maxY - (self.centerButton.frame.height / 2 + self.cameraButtonBottomSpace + self.view.safeAreaInsets.bottom )) {
                self.centerButton.center.y = newCenterValue
            }
            let scaledTransform = self.orignalTransform.scaledBy(x: 1 - (abs(offset) * 0.25), y: 1 - (abs(offset) * 0.25))
            self.centerButton.transform = scaledTransform
            
        }
    
        
            if self.bottomViewIntialCenter == nil {
            self.bottomViewIntialCenter = self.centerButton.center.x
        }
            var newCenter = self.bottomViewIntialCenter * (1 - (offset * -1))
          
            if newCenter < self.bottomViewIntialCenter {
                self.barToMove = self.leftBar
            newCenter = newCenter + 39.5
            } else if newCenter > self.bottomViewIntialCenter  {
                self.barToMove = self.rightBar
                   newCenter =  newCenter - 40
        } else {
           // print("inside alpha", abs(offset))
                self.leftBar.alpha = abs(offset)
                self.leftBar.center.x = newCenter
                self.leftBar.isHidden = abs(offset) < 0.2
                DispatchQueue.main.async {
            self.rightBar.alpha = abs(offset)
            self.rightBar.center.x = newCenter
            self.rightBar.isHidden = abs(offset) < 0.2
                }
            return
        }
        self.barToMove.alpha = abs(offset)
            self.barToMove.isHidden = abs(offset) < 0.2
            self.barToMove.center.x = newCenter
           //   barToMove = nil
        }
    }
    
    
    
}

extension ButtonsController: ButtonsAnimateDelegate {
    func animateButtonsWith(offest: CGFloat, _ shouldAnimate: Bool) {
        self.animateButtons(offest, shouldAnimate)
    }
    func shouldBounce(bool: Bool) {
        
        self.centerButton.shouldBounce = bool
    }
}



