//
//  ViewController.swift
//  SnapchatNavigation
//
//  Created by Artur Chabera on 04/03/2019.
//  Copyright © 2019 Artur Chabera. All rights reserved.
//

import UIKit

enum Panel {
    case top, bottom, left, center, camera, right
}

protocol HideBottomButtonDelegate {
    func hideButton(_ bool: Bool)
}

class MainViewController: UIViewController {
    private var topContainer: UIView!
    private var centerContainer: UIView!
    private var scrollContainer: UIView!
    private var bottomContainer: UIView!
    private var buttonsContainer: UIView!
    var centerController: CustomCameraViewController!
    let mainStoryboard = UIStoryboard(name: "Storyboard", bundle: nil)
    var isStarting = true
    private var buttonAnimateDelegate: ButtonsAnimateDelegate?
    weak var captureDelegate: CaputreButtonDelegate?
  
    private var isCurrentCamera = false {
        didSet {
            if isCurrentCamera {
                hideButton(false)
            }
            
            if !isCurrentCamera {
                centerController.backButtonAction(UIButton())
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.buttonAnimateDelegate?.shouldBounce(bool: self.isCurrentCamera)
            }
        }
    }
    private var scrollView: UIScrollView!
    private var shouldAnimate: Bool = false
    var leftVCDelegate: WebShopVCDelegate?
    var rightVCDelegate: DashboardMainVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("MainVC view will appear")
        shouldRefreshDashboardData = true
         leftVCDelegate?.callVCLifeCycle()
         rightVCDelegate?.callViewLifeCycle()
        centerController.backButtonAction(UIButton())
    }

    
    private func setupUI() {
            self.setupHorizontalViews()
    }

    private func setupHorizontalViews() {
         let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        centerContainer = UIView()
        view.addSubview(centerContainer)
        centerContainer.fit(to: view)
        centerContainer.clipsToBounds = true
       centerController = storyboard.instantiateViewController(withIdentifier: "CustomCameraViewController") as! CustomCameraViewController
        centerController.buttonDelegate
         = self
        captureDelegate = centerController
        addChild(centerController, toContainer: centerContainer)
        
        scrollView = UIScrollView(frame: view.frame)
        scrollContainer = UIView()
        
        self.setupButtonsContainer()
        
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(runCode), userInfo: nil, repeats: false)
           Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(setIsStarting), userInfo: nil, repeats: false)
       
    }
    
    
    @objc func runCode() {
        centerController.loadChildViews(fromParent: self, scrollView: &self.scrollView, scrollContainer: &self.scrollContainer, cameraDelegate: centerController as! CameraControllerDelegate)
    }
    
    @objc func setIsStarting() {
          isStarting = false
       }
       
    
  
    private func setupButtonsContainer() {
        buttonsContainer = PassthroughView()
        
        view.insertSubview(buttonsContainer, aboveSubview: scrollView)
        buttonsContainer.translatesAutoresizingMaskIntoConstraints = false
        let bottomDistance: CGFloat = Layout.distanceFromBottom
        let containerHightAnchor = buttonsContainer.heightAnchor.constraint(equalToConstant: Layout.buttonContainerHeight)
        NSLayoutConstraint.activate([
            buttonsContainer.widthAnchor.constraint(equalTo: view.widthAnchor),
            containerHightAnchor,
            
            buttonsContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            buttonsContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomDistance)
            ])
        
        let buttonsController = mainStoryboard.instantiateViewController(withIdentifier: "ButtonsController") as! ButtonsController
       
        buttonsController.buttonContainer = buttonsContainer
        self.buttonAnimateDelegate = buttonsController as ButtonsAnimateDelegate
        buttonsController.delegate = self
        addChild(buttonsController, toContainer: buttonsContainer)
    }
}

extension MainViewController: PanControllerDelegate {
    func present(_ panel: Panel) {
        switch panel {
        case .bottom:
            bottomContainer.center = view.center
            scrollContainer.center.y = view.center.y - view.frame.height
            centerContainer.center.y = view.center.y - view.frame.height
            buttonsContainer.isHidden = true
            isCurrentCamera = false
        case .top:
            topContainer.center = view.center
            scrollContainer.center.y = view.center.y + view.frame.height
            centerContainer.center.y = view.center.y + view.frame.height
             buttonsContainer.isHidden = true
            isCurrentCamera = false
        default:
             buttonsContainer.isHidden = false
            scrollContainer.center = view.center
            centerContainer.center = scrollContainer.center
           // bottomContainer.center.y = view.center.y + view.frame.height
           // topContainer.center.y = view.center.y - (view.frame.height/2)
        }
        
    }

    func view(_ panel: Panel) -> UIView {
        switch panel {
        case .center: return scrollContainer
        case .top: return topContainer
        case .bottom: return bottomContainer
        default: return centerContainer
        }
    }
}

extension MainViewController: ButtonsDelegate {
    func scroll(to panel: Panel) {
       
        self.view.endEditing(true)
        shouldAnimate = scrollView.contentOffset.x == UIScreen.main.bounds.width || panel == .center
        if isCurrentCamera && panel == .center {
             captureDelegate?.captureImage()
        }
        switch panel {
        case .left:
           
            scrollView.setContentOffset(.zero, animated: true)
            activeVC = 1
        leftVCDelegate?.callVCLifeCycle()
            isCurrentCamera = false
        case .right: scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width * 2, y: 0), animated: true)
        activeVC = 2
      rightVCDelegate?.callViewLifeCycle()
            isCurrentCamera = false
        case .center:
            
            scrollView.setContentOffset(CGPoint(x: UIScreen.main.bounds.width, y: 0), animated: true)
        activeVC = 0
             isCurrentCamera = true
        default: break
        }
     //   setBottomGreenViewColor(panel: panel)
    }
    
   
//    func setBottomGreenViewColor(panel:Panel) {
//        buttonsController.shopSelectionView.backgroundColor = panel == .left ? .green : .clear
//        buttonsController.addedSelectionView.backgroundColor = panel == .right ? .green : .clear
//    }

    func backToCamera() {
        UIView.animate(withDuration: 0.2) { self.present(.center)
            self.isCurrentCamera = true
        }
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        shouldAnimate = true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
         let panel: Panel = scrollView.contentOffset.x < view.bounds.width ? .left : .right
        if shouldAnimate {
            let endColor: UIColor = .black
            let offset = (scrollView.contentOffset.x / view.frame.width) - 1
           // scrollContainer.backgroundColor = UIColor.transition(from: .clear, to: endColor, with: abs(offset))
            buttonAnimateDelegate?.animateButtonsWith(offest: offset, true)
               
        } else {
          
            let offset = (scrollView.contentOffset.x / view.frame.width) / 2
            //scrollContainer.backgroundColor = UIColor.transition(from: .black, to: .black, with: abs(offset))
            let modifiedOffset = (scrollView.contentOffset.x / view.frame.width) - 1
            
            buttonAnimateDelegate?.animateButtonsWith(offest:  modifiedOffset, false)
        }
       
        if scrollView.contentOffset.x == view.bounds.width  {
            isCurrentCamera = true
           
        } else {
            isCurrentCamera = false
        }
        
    }
}


extension UIImageView {
func applyshadowWithCorner(containerView : UIView, cornerRadious : CGFloat){
    containerView.clipsToBounds = false
    containerView.layer.shadowColor = UIColor.black.cgColor
    containerView.layer.shadowOpacity = 0.5
     containerView.layer.shadowOffset = CGSize(width: 1, height: 1)
    containerView.layer.shadowRadius = 3
    containerView.layer.cornerRadius = cornerRadious
    containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadious).cgPath
    self.clipsToBounds = true
    self.layer.cornerRadius = cornerRadious
}
}

extension MainViewController: HideBottomButtonDelegate {
    func hideButton(_ bool: Bool) {
        if isStarting { return }
        UIView.animate(withDuration: 0.5, animations: {
            self.buttonsContainer.alpha = bool ? 0 : 1
        })
    }
}

class PassthroughView: UIView {

    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Get the hit view we would normally get with a standard UIView
        let hitView = super.hitTest(point, with: event)

        // If the hit view was ourself (meaning no subview was touched),
        // return nil instead. Otherwise, return hitView, which must be a subview.
        return hitView == self ? nil : hitView
    }
}
