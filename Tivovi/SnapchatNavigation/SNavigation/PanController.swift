//
//  PanController.swift
//  SnapchatNavigation
//
//  Created by Artur Chabera on 05/03/2019.
//  Copyright © 2019 Artur Chabera. All rights reserved.
//
import CameraManager
import CoreLocation
import UIKit


protocol PanControllerDelegate: class {
    func present(_ panel: Panel)
    func view(_ panel: Panel) -> UIView
}

class PanController: UIViewController {
  
    private var horizontalDirection: Panel = .center
    @IBOutlet weak var nextButton: UIButton!
    
    private var originalCenter = CGPoint()
    private var topPanelCenter = CGPoint()
    private var bottomPanelCenter = CGPoint()
    weak var cameraDelegate: CameraControllerDelegate?
    weak var delegate: PanControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGestureRecognizer.delegate = self
        view.addGestureRecognizer(panGestureRecognizer)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.view.setNeedsDisplay()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           print("PanVC view will appear")
       }
    
    @IBAction func flashButtonPressed(_ sender: UIButton) {
        cameraDelegate?.flashButtonAction()
    }
    
    @IBAction func camerSwitchButtonPressed(_ sender: UIButton) {
        cameraDelegate?.switchCameraButtonAction(sender)
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        cameraDelegate?.backButtonAction(sender)
    }
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        handle(velocity: recognizer.velocity(in: view).y/1000)
        handle(translationOf: recognizer)
    }
    
   
    
    private func handle(velocity: CGFloat) {
        switch velocity {
        case _ where velocity > 0.5: horizontalDirection = .top
        case _ where velocity < -0.5: horizontalDirection = .bottom
        default: break
        }
    }
    
    private func handle(translationOf recognizer: UIPanGestureRecognizer) {
        guard
            let scrollContainer = delegate?.view(.center)
            else { return }
        
        switch recognizer.state {
        case .began:
            originalCenter = scrollContainer.center
           
        case .changed: break;
        case .ended:
            /// 5. handle drag by pan or velocity changes
            switch scrollContainer.center {
            case _ where scrollContainer.center.y > view.center.y + view.frame.height/5:
                horizontalDirection = .top
            case _ where scrollContainer.center.y < view.center.y - view.frame.height/5:
                horizontalDirection = .bottom
            default:
                horizontalDirection = .center
            }
            handleEndedState()
        default: break
        }
    }
    @IBAction func nextButtonAction(_ sender: UIButton) {
        cameraDelegate?.nextButtonTap(sender)
    }
    
    private func handleEndedState() {
        UIView.animate(withDuration: 0.2) {
            switch self.horizontalDirection {
            case .bottom: self.delegate?.present(.bottom)
            case .top: self.delegate?.present(.top)
            case .center, .camera: self.delegate?.present(.center)
            default: break
            }
        }
    }
   func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    let view = super.view.hitTest(point, with: event)
        return view == self ? nil : view
    }
}

extension PanController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        self.view.endEditing(true)
        guard let recognizer = gestureRecognizer as? UIPanGestureRecognizer else { return false }
        let translation = recognizer.translation(in: view)
        return abs(translation.x) < abs(translation.y)
    }
    
}

