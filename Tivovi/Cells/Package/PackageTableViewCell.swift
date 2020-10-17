//
//  PackageTableViewCell.swift
//  Tivovi
//
//  Created by Đinh Trọng Tú on 2/21/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit
import FSPagerView
import SDWebImage

protocol ActionPackageDelegate {
    func didTapWarrantyButton(atIndex: IndexPath)
    func didTapPriceMatchButton(atIndex: IndexPath)
    func didTapReturnDateButton(atIndex: IndexPath)
    func didTapTrackInfoButton(atIndex: IndexPath)
    func didTapTakePhotoButton(atIndex: IndexPath)
    func didTapRefeshButton(atIndex: IndexPath)
    func didTapShareButton(atIndex: IndexPath)
    func didTapMessageButton(atIndex: IndexPath)
    func didTapTraceButton(atIndex: IndexPath)
    func didTapSaveButton(atIndex: IndexPath)
    func didTapCloseButton(atIndex: IndexPath)
    func didTapSwitchButton(atIndex: IndexPath)
    func didTapLoadMoreButton()
    func didTapMoreButton(atIndex: IndexPath)
    func didTapShareUseButton(atIndex: IndexPath)
    func didTapCloseInfoBarButton(atIndex: IndexPath)
    func didTapCloseInfoWarrantyButton(atIndex: IndexPath)
    func didTapShopNameLabel(text: String)
    func didTapBoxNumber(atIndex: IndexPath, mode: PackageExtendMode)
    func shouldChangeCommentsAtIndex(indexPath: IndexPath, strComments: String)
}


enum PackageExtendMode: Int {
    case None = 0
    case Warranty = 1
    case ReturnDate = 2
    case PriceMatch = 3
    case TraceAndTruck = 4
    case Comments = 5
}

class PackageTableViewCell: BaseTableViewCell {
    
    static let TXT_PLACEHOLDER_TEXT = "Please enter comment"
    
    //MARK: - Package Container
    @IBOutlet weak var containerView: UIView! {
        didSet {
            containerView.layer.cornerRadius = 15
            containerView.clipsToBounds = true
            
            containerView.layer.shadowColor = UIColor.black.cgColor
            containerView.layer.shadowOpacity = 0.3
            containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
            containerView.layer.shadowRadius = 7
            containerView.layer.masksToBounds = false
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            let tapOnNumber = UITapGestureRecognizer(target: self, action: #selector(handleTapShopNameLabel(sender:)))
            titleLabel.addGestureRecognizer(tapOnNumber)
            titleLabel.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var image_height_constrain: NSLayoutConstraint!
    @IBOutlet weak var frame_height_constrain: NSLayoutConstraint!
    @IBOutlet weak var emptyImageView: UIImageView! {
        didSet {
            let tapOnNumber = UITapGestureRecognizer(target: self, action: #selector(didTapCameraButton(_:)))
            emptyImageView.addGestureRecognizer(tapOnNumber)
            emptyImageView.isUserInteractionEnabled = true
        }
    }
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
        }
    }
    
    @IBOutlet weak var btnCollectionView: UICollectionView!
    @IBOutlet weak var warrantyButton: SSBadgeButton!
    @IBOutlet weak var priceMatchButton: UIButton!
    @IBOutlet weak var returDateButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var warningButton: UIButton! {
        didSet {
            warningButton.alpha = 0.0
        }
    }
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var traceButton: UIButton!
    @IBOutlet weak var actionStackView: UIStackView!
    
    //MARK: - Warranty Container
    @IBOutlet weak var warrantyContainerView: UIView!
    @IBOutlet weak var placeIconImageView: UIImageView!
    
    @IBOutlet weak var titleSubContainer: UILabel!
    @IBOutlet weak var titleLeftBoxLabel: UILabel!
    @IBOutlet weak var titleRightBoxLabel: UILabel!
    
    @IBOutlet weak var dayLeftBoxLabel: UILabel!
    @IBOutlet weak var dayRightBoxLabel: UILabel!
    
    
    @IBOutlet weak var unitLeftBoxLabel: UILabel!
    @IBOutlet weak var unitRightBoxLabel: UILabel!
    
    @IBOutlet weak var dateLeftBoxLabel: UILabel!
    @IBOutlet weak var dateRigtBoxLabel: UILabel!
    
    @IBOutlet weak var subLeftBoxLabel: UILabel!
    @IBOutlet weak var subRightBoxLabel: UILabel!
    
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var tblComments: UITableView!
    @IBOutlet weak var txtComments: UITextView!
    @IBOutlet weak var btnSend: UIButton!
    var commentModel: [CommentModel]? = nil
    var commentDateModel: [String]? = nil
    @IBOutlet weak var containerViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var viewBrandDetails: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var saveButton: UIButton! {
        didSet {
            saveButton.backgroundColor = UIColor(hex: "#f0c2b1")
        }
    }
    @IBOutlet weak var switchButton: UIButton!
    
    @IBOutlet weak var boxLeftView: UIView! {
        didSet {
            let tapOnNumber = UITapGestureRecognizer(target: self, action: #selector(handleTapOnBoxNumber(sender:)))
            boxLeftView.addGestureRecognizer(tapOnNumber)
            boxLeftView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var boxRightView: UIView! {
        didSet {
            let tapOnNumber = UITapGestureRecognizer(target: self, action: #selector(handleTapOnBoxNumber(sender:)))
            boxRightView.addGestureRecognizer(tapOnNumber)
            boxRightView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var heightWarrantyConstraint: NSLayoutConstraint!
    let MAX_HEIGHT_WARRANTY_CONSTRAINT: CGFloat = 440.0
    let MIN_HEIGHT_WARRANTY_CONSTRAINT: CGFloat = 0.0
    
    //MARK: - On Board
    @IBOutlet weak var onBoardView: UIView! {
        didSet {
            let tapOnNumber = UITapGestureRecognizer(target: self, action: #selector(handleTapOnBoardView(sender:)))
            onBoardView.addGestureRecognizer(tapOnNumber)
            onBoardView.isUserInteractionEnabled = true
        }
    }
    
    @IBOutlet weak var closeOnBoardButton: UIButton!
    
    //MARK: - More View
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var showMoreButton: UIButton!
    
    //MARK: - Track View
    
    @IBOutlet weak var trackInfoView: UIView!
    @IBOutlet weak var lblCourier: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblSuffixNumber: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var activityIndiactor: UIActivityIndicatorView!
    
    //MARK: - Setup
    
    fileprivate var longPressGesture: UILongPressGestureRecognizer!
    var btn_collection_img_array = [["warranty_active","warranty_inactive"],["pricematch_active","pricematch_inactive"],["return_date_active","return_date_inactive"],["share_user_active","share_user_inactive"],["camera_active","camera_inactive"],["share_active","share_inactive"],["comments_active","comments_inactive"],["trace_active","trace_inactive"]]
    var cell_index = [0,1,2,3,4,5,6,7]
    
    var delegate: ActionPackageDelegate?
    var extendMode: PackageExtendMode = .None {
        didSet {
            switch extendMode {
            case .Warranty:
                trackInfoView.isHidden = true
                commentView.isHidden = true
                warrantyContainerView.isHidden = false
                setupWarranyUI()
                break
            case .ReturnDate:
                trackInfoView.isHidden = true
                commentView.isHidden = true
                warrantyContainerView.isHidden = false
                setupReturnDateUI()
                break
            case .PriceMatch:
                trackInfoView.isHidden = true
                commentView.isHidden = true
                warrantyContainerView.isHidden = false
                setupPriceMatchUI()
                break
            case .TraceAndTruck:
                warrantyContainerView.isHidden = true
                commentView.isHidden = true
                trackInfoView.isHidden = false
                setupTrackUI()
                break
            case .Comments:
                warrantyContainerView.isHidden = true
                trackInfoView.isHidden = true
                commentView.isHidden = false
                break
            case .None:
                
                trackInfoView.isHidden = true
                warrantyContainerView.isHidden = true
                commentView.isHidden = true
                setupOnBoardUI()
                break
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewBrandDetails.layer.cornerRadius = viewBrandDetails.frame.size.height/2
        viewBrandDetails.layer.masksToBounds = true
        
        brandImageView.layer.cornerRadius = brandImageView.frame.size.width/2
        brandImageView.layer.masksToBounds = true
        
        pagerView.layer.cornerRadius = 15
        pagerView.clipsToBounds = true
//        pagerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]

        pagerView.dataSource = self
        pagerView.delegate = self
        
        btnCollectionView.register(UINib(nibName: "ButtonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ButtonCollectionViewCell")
        btnCollectionView.dataSource = self
        btnCollectionView.delegate = self
        
        let image = UIImage(named: "dashboard_more_icon_24")?.withRenderingMode(.alwaysTemplate)
        editButton.setImage(image, for: .normal)
        editButton.tintColor = UIColor.white
        editButton.layer.cornerRadius = editButton.frame.size.height/2
        editButton.layer.masksToBounds = true
        
        registerTableCell()
    }
    
    func setup(model: AnyObject, atIndex: IndexPath, mode: PackageExtendMode) {
        super.setup(model: model, atIndex: atIndex)
        
        guard let package = model as? PackageModel else {
            return
        }
        
        extendMode = mode
        if extendMode == .None {
            containerViewBottomConstraint.constant = 5
        } else {
            containerViewBottomConstraint.constant = -5
        }
        
        let suffixNumber = String(package.shipmentId.suffix(6))
        lblCourier.text = package.courier
        lblNumber.text = package.shipmentId
        lblSuffixNumber.text = suffixNumber
        lblDescription.text = package.text_description
        
//        emptyImageView.alpha = (package.imageUrls.count > 0 ? 0 : 1)
        emptyImageView.alpha = 0
        titleLabel.text = (package.title.count == 0 ? "No name" : package.title)
        
        if package.avatar.count > 0 {
            brandImageView.sd_setImage(with: URL(string: (NetworkingConstants.baseURL + package.avatar)), placeholderImage: UIImage(named: "placeholder"))
        } else {
            brandImageView.image = UIImage(named: "placeholder")
        }
        
        dateLabel.text = package.getPurchaseDateDisplay()
        
        let height = 180
         self.activityIndiactor.stopAnimating()
        if package.imageUrls.count > 0 {
            self.activityIndiactor.startAnimating()
//            let urlImageStr = NetworkingConstants.baseURL + package.imageUrls[0]
            
            self.frame_height_constrain.constant = 464
            self.image_height_constrain.constant = 374
            
//            UIImageView().sd_setImage(with: URL(string: urlImageStr), placeholderImage: UIImage(), options: .refreshCached, completed: { (image, error, cacheType, url) in
//                if let image = image {
//                    let image_ratio = image.resize(image: image, targetSize: CGSize(width: self.frame.size.width, height: self.frame.size.width))
//                    var height = 180
//                    height += Int(image_ratio.size.height )
//                    self.frame_height_constrain.constant = CGFloat(height)
//                    self.image_height_constrain.constant = CGFloat(height) - 180
//                    self.layoutIfNeeded()
//                }
//            })
            
//            UIImageView().sd_setImage(with: URL(string: urlImageStr), completed: { (image, error, cacheType, url) in
//                if let image = image {
//                    var image_width = image.size.width
//                    var image_height = image.size.height
//                    let image_ratio: Double = Double(image_width/image_height)
//                    let device_width = UIScreen.main.bounds.width
//
//                    image_width = device_width
//                    image_height = image_width/CGFloat(image_ratio)
//                    height += Int(image_height)
//
//                    self.frame_height_constrain.constant = CGFloat(height)
//                    self.image_height_constrain.constant = CGFloat(height) - 180
//                }
//            })
        }
        else
        {
            self.frame_height_constrain.constant = CGFloat(height)
            self.image_height_constrain.constant = CGFloat(80)
        }
        

        pagerView.reloadData()
        setupOnBoardUI()
        
        pageControl.numberOfPages = package.imageUrls.count
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.btnLongGesture(gesture:)))
        btnCollectionView.addGestureRecognizer(longPressGesture)
        
        if package.imageUrls.count > 0 {
            cameraButton.tag = 1
            cameraButton.setImage(UIImage(named: "camera_active"), for: .normal)
        } else {
            cameraButton.setImage(UIImage(named: "camera_inactive"), for: .normal)
            cameraButton.tag = 0
        }
        
        if package.shipmentId.count > 0 {
            traceButton.setImage(UIImage(named: "trace_active"), for: .normal)
            traceButton.tag = 1
        } else {
            traceButton.tag = 0
            traceButton.setImage(UIImage(named: "trace_inactive"), for: .normal)
        }
        
        if package.commentCount.count > 0 {
            messageButton.tag = 1
            messageButton.setImage(UIImage(named: "comments_active"), for: .normal)
        } else {
            messageButton.tag = 0
            messageButton.setImage(UIImage(named: "comments_inactive"), for: .normal)
        }
        
        
        //        reorderAction()
        
    }
    
    @IBAction func didTappedSendComments(_ sender: Any) {
    }
    
    @objc func btnLongGesture(gesture: UILongPressGestureRecognizer) {
        switch(gesture.state) {
            
        case .began:
            guard let selectedIndexPath = btnCollectionView.indexPathForItem(at: gesture.location(in: btnCollectionView)) else {
                break
            }
            btnCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            btnCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view!))
        case .ended:
            btnCollectionView.endInteractiveMovement()
        default:
            btnCollectionView.cancelInteractiveMovement()
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutIfNeeded()
    }
    
    @IBAction func didTapRefeshTrackButton(_ sender: UIButton) {
        
        UIButton.animate(withDuration: 0.5) { () -> Void in
            sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        
        UIButton.animate(withDuration: 0.5, delay: 0.45, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
            sender.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
        }, completion: nil)
        
        delegate?.didTapRefeshButton(atIndex: index!)
    }
}

//MARK: - Setup UI
extension PackageTableViewCell {
    
    func reloadActionOrder(changeType: OptionPackageEnum, completionBlock: ((Bool) -> Void)? = nil) {
        guard let package = model as? PackageModel else {
            return
        }
        
        if changeType == .Photo {
            cameraButton.setImage(UIImage(named: "camera_active"), for: .normal)
            if cameraButton.tag == 0 {
                moveNext(viewSwap: cameraButton, index: 3) { (isCompleted) in
                    completionBlock!(true)
                    return
                }
            }
        } else if changeType == .Track {
            traceButton.setImage(UIImage(named: "trace_active"), for: .normal)
            if package.activeAction.contains(.Photo) {
                moveNext(viewSwap: self.traceButton, index: 4 ) { (isCompleted) in
                    completionBlock!(true)
                    return
                }
            } else {
                moveNext(viewSwap: self.traceButton, index: 3) { (isCompleted) in
                    completionBlock!(true)
                    return
                }
            }
        } else if changeType == .Message {
            if package.text_description.count > 0 {
                messageButton.setImage(UIImage(named: "comments_active"), for: .normal)
                if messageButton.tag == 0 {
                    
                    if package.activeAction.contains(.Photo) && package.activeAction.contains(.Track) && package.activeAction.contains(.Share) {
                        moveNext(viewSwap: messageButton, index: 6)  { (isCompleted) in
                            completionBlock!(true)
                            return
                        }
                    } else if  (package.activeAction.contains(.Track) && package.activeAction.contains(.Photo)){
                        moveNext(viewSwap: messageButton, index: 5)  { (isCompleted) in
                            completionBlock!(true)
                            return
                        }
                    } else if package.activeAction.contains(.Photo) || package.activeAction.contains(.Track) || package.activeAction.contains(.Share) {
                        moveNext(viewSwap: messageButton, index: 4)  { (isCompleted) in
                            completionBlock!(true)
                            return
                        }
                    } else {
                        moveNext(viewSwap: messageButton, index: 3)  { (isCompleted) in
                            completionBlock!(true)
                            return
                        }
                    }
                }
            }
        }
        
        completionBlock!(true)
    }
    
    func reorderAction() {
        
        guard let package = model as? PackageModel else {
            return
        }
        
//        actionStackView.removeArrangedSubview(messageButton)
//        actionStackView.removeArrangedSubview(shareButton)
//        actionStackView.removeArrangedSubview(traceButton)
//        actionStackView.removeArrangedSubview(warningButton)
        
        //print("action : " + "\(package.activeAction)")
        //print("stack : " + "\(actionStackView.arrangedSubviews.count)")
        
        if package.activeAction.contains(.Photo) {
            moveNext(viewSwap: self.cameraButton, index: 4) { (isCompleted) in
                return
            }
            
           /* UIView.animate(withDuration: 0.5, animations: {
                self.actionStackView.removeArrangedSubview(self.cameraButton)
                self.actionStackView.insertArrangedSubview(self.cameraButton, at: self.actionStackView.arrangedSubviews.count)
                self.actionStackView.layoutIfNeeded()
            }) { (isCompleted) in
            }*/
        }
        
        if package.activeAction.contains(.Track) {
            moveNext(viewSwap: self.shareButton, index: 8) { (isCompleted) in
                return
            }
            /* UIView.animate(withDuration: 0.5, animations: {
                self.actionStackView.removeArrangedSubview(self.traceButton)
                self.actionStackView.insertArrangedSubview(self.traceButton, at: self.actionStackView.arrangedSubviews.count)
                self.actionStackView.layoutIfNeeded()
            }) { (isCompleted) in
            } */
        }
        
        if package.activeAction.contains(.Message) {
            moveNext(viewSwap: self.messageButton, index: 7) { (isCompleted) in
                return
            }
           /* UIView.animate(withDuration: 0.5, animations: {
                self.actionStackView.removeArrangedSubview(self.messageButton)
                self.actionStackView.insertArrangedSubview(self.messageButton, at: self.actionStackView.arrangedSubviews.count)
                self.actionStackView.layoutIfNeeded()
            }) { (isCompleted) in
            }*/
        }
        
        if package.activeAction.contains(.Share) {
            moveNext(viewSwap: self.shareButton, index: 6) { (isCompleted) in
                return
            }
          /*  UIView.animate(withDuration: 0.5, animations: {
                self.actionStackView.removeArrangedSubview(self.shareButton)
                self.actionStackView.insertArrangedSubview(self.shareButton, at: self.actionStackView.arrangedSubviews.count)
                self.actionStackView.layoutIfNeeded()
            }) { (isCompleted) in
            } */
        }
        actionStackView.removeArrangedSubview(warningButton)
        
        actionStackView.insertArrangedSubview(warningButton, at: actionStackView.arrangedSubviews.count)
        actionStackView.layoutIfNeeded()
        
        if !package.activeAction.contains(.Share) {
            actionStackView.removeArrangedSubview(shareButton)
            
            actionStackView.insertArrangedSubview(shareButton, at: actionStackView.arrangedSubviews.count)
            actionStackView.layoutIfNeeded()
        }
        
        if !package.activeAction.contains(.Message) {
            actionStackView.removeArrangedSubview(messageButton)
            
            actionStackView.insertArrangedSubview(messageButton, at: actionStackView.arrangedSubviews.count)
            actionStackView.layoutIfNeeded()
        }
        
        if !package.activeAction.contains(.Track) {
            actionStackView.removeArrangedSubview(traceButton)
            
            actionStackView.insertArrangedSubview(traceButton, at: actionStackView.arrangedSubviews.count)
            actionStackView.layoutIfNeeded()
        }
        
        if !package.activeAction.contains(.Photo) {
            actionStackView.removeArrangedSubview(cameraButton)
            actionStackView.insertArrangedSubview(cameraButton, at: actionStackView.arrangedSubviews.count)
            actionStackView.layoutIfNeeded()
        }
        
        self.actionStackView.layoutIfNeeded()
    }
    
    private func setupWarranyUI() {
        
        guard let package = model as? PackageModel else {
            return
        }
        
        placeIconImageView.image = UIImage(named: "warranty")
        
        onBoardView.isHidden = true
        
        
        titleSubContainer.text = "Warranty"
        
        dayLeftBoxLabel.text = "\(package.waranty_months)"
        titleLeftBoxLabel.text = "Garantperiode"
        unitLeftBoxLabel.text = "år"
        dateLeftBoxLabel.text = package.getWarrantyDateDisplay()
        subLeftBoxLabel.text = "\(package.getWarrantyDay()) dage"
        
        dayRightBoxLabel.text = "\(package.w_notification_days)"
        titleRightBoxLabel.text = "Notification"
        unitRightBoxLabel.text = "dage"
        dateRigtBoxLabel.text = package.getNotificationWarrantyDateDisplay()
        subRightBoxLabel.text = "\(package.getNotificationWarrantyDay()) dage"
        
        setSwitchOnOff(bOn: (package.setNotificationWarrantyDay == "on"))
        let dayDifference = package.dateDifference(notificationDate: package.getNotificationWarrantyDateDisplay())
        if dayDifference >= 0 {
            warrantyButton.badgeBackgroundColor = UIColor.red
            warrantyButton.badge = String(package.getWarrantyDay()-package.getNotificationWarrantyDay())
        }
    }
    
    private func setupReturnDateUI() {
        
        guard let package = model as? PackageModel else {
            return
        }
        
        placeIconImageView.image = UIImage(named: "return_date")
        
        onBoardView.isHidden = true
        titleSubContainer.text = "Retur"
        
        dayLeftBoxLabel.text = "\(package.return_days)"
        titleLeftBoxLabel.text = "Retur senest"
        unitLeftBoxLabel.text = "dage"
        dateLeftBoxLabel.text = package.getReturnDateDisplay()
        subLeftBoxLabel.text = "\(package.getReturnDay()) dage"
        
        dayRightBoxLabel.text = "\(package.notification_days)"
        titleRightBoxLabel.text = "Notification"
        unitRightBoxLabel.text = "dage"
        dateRigtBoxLabel.text = package.getNotificationReturnDateDisplay()
        subRightBoxLabel.text = "\(package.getNotificationReturnDay()) dage"
        
        setSwitchOnOff(bOn: (package.setNotificationReturnDay == "on"))
    }
    
    private func setupPriceMatchUI() {
        
        guard let package = model as? PackageModel else {
            return
        }
        
        placeIconImageView.image = UIImage(named: "pricematch")
        
        onBoardView.isHidden = true
        titleSubContainer.text = "Price Match"
        
        dayLeftBoxLabel.text = "\(package.priceMatchDay)"
        titleLeftBoxLabel.text = "Retur senest"
        unitLeftBoxLabel.text = "dage"
        dateLeftBoxLabel.text = package.getPriceMatchDateDisplay()
        subLeftBoxLabel.text = "\(package.getPriceMatchDay()) dage"
        
        dayRightBoxLabel.text = "\(package.priceMatchNotificationDay)"
        titleRightBoxLabel.text = "Notification"
        unitRightBoxLabel.text = "dage"
        dateRigtBoxLabel.text = package.getNotificationPriceMatchDateDisplay()
        subRightBoxLabel.text = "\(package.getNotificationPriceMatchDay()) dage"
        
        setSwitchOnOff(bOn: (package.setNotificationPriceMatchDay == "on"))
    }
    
    private func setupTrackUI() {
        guard let package = model as? PackageModel else {
            return
        }
        
        onBoardView.isHidden = true
        let suffixNumber = String(package.shipmentId.suffix(6))
        lblCourier.text = package.courier
        lblNumber.text = package.shipmentId
        lblSuffixNumber.text = suffixNumber
        lblDescription.text = package.text_description
    }
    
    private func setupOnBoardUI() {
        
        guard let package = model as? PackageModel else {
            return
        }
        
        onBoardView.isHidden = true
        if extendMode == .None {
            if package.status! == "DELIVERED" || package.status! == "Being Delivered" {
                onBoardView.isHidden = false
            }
        }
    }
    
    
}

//MARK: - Action
extension PackageTableViewCell {
    
    
    @IBAction func didTapCloseInfoWarrantyButton(_ sender: Any) {
        delegate?.didTapCloseInfoWarrantyButton(atIndex: index!)
    }
        
    @IBAction func didTapShareUserButton(_ sender: Any) {
        delegate?.didTapShareUseButton(atIndex: index!)
    }
    
    @IBAction func didTapMoreButton(_ sender: Any) {
        delegate?.didTapMoreButton(atIndex: index!)
    }
    
    func updateWarrantyAndReutDateUI(numberLeft: Int, numberRight: Int, activeSubmit: Bool, switchState: Bool) {
        
        guard let package = model as? PackageModel else {
            return
        }
        
        let packageClone = package.clone()
        
        switch extendMode {
        case .Warranty:
            
            placeIconImageView.image = UIImage(named: "warranty")
            packageClone.waranty_months = numberLeft + 1
            packageClone.w_notification_days = numberRight
            
            dayLeftBoxLabel.text = "\(numberLeft + 1)"
            dateLeftBoxLabel.text = packageClone.getWarrantyDateDisplay()
            subLeftBoxLabel.text = "\(packageClone.getWarrantyDay()) dage"
            
            dayRightBoxLabel.text = "\(numberRight)"
            dateRigtBoxLabel.text = packageClone.getNotificationWarrantyDateDisplay()
            subRightBoxLabel.text = "\(packageClone.getNotificationWarrantyDay()) dage"
            
            break
        case .ReturnDate:
            
            placeIconImageView.image = UIImage(named: "return_date")
            packageClone.return_days = numberLeft
            packageClone.notification_days = numberRight
            
            dayLeftBoxLabel.text = "\(numberLeft)"
            dateLeftBoxLabel.text = packageClone.getReturnDateDisplay()
            subLeftBoxLabel.text = "\(packageClone.getReturnDay()) dage"
            
            dayRightBoxLabel.text = "\(numberRight)"
            dateRigtBoxLabel.text = packageClone.getNotificationReturnDateDisplay()
            subRightBoxLabel.text = "\(packageClone.getNotificationReturnDay()) dage"
            
            break
            
        case .PriceMatch:
            
            placeIconImageView.image = UIImage(named: "pricematch")
            packageClone.priceMatchDay = numberLeft
            packageClone.priceMatchNotificationDay = numberRight
            
            dayLeftBoxLabel.text = "\(numberLeft)"
            dateLeftBoxLabel.text = packageClone.getPriceMatchDateDisplay()
            subLeftBoxLabel.text = "\(packageClone.getPriceMatchDay()) dage"
            
            dayRightBoxLabel.text = "\(numberRight)"
            dateRigtBoxLabel.text = packageClone.getNotificationPriceMatchDateDisplay()
            subRightBoxLabel.text = "\(packageClone.getNotificationPriceMatchDay()) dage"
            break
            
        case .Comments:
            reloadTableView()
            break
        default: break
            
        }
        
        setSwitchOnOff(bOn: switchState)
        setActiveSubmitButton(isActive: activeSubmit)
    }
    
    private  func setActiveSubmitButton(isActive: Bool) {
        saveButton.isEnabled = isActive
        saveButton.backgroundColor = (isActive == true ? UIColor.red : UIColor(hex: "#f0c2b1"))
    }
    
    private func setSwitchOnOff(bOn: Bool) {
        
        if bOn {
            switchButton.setBackgroundImage(UIImage(named: "btn_switch_on"), for: .normal)
            switchButton.setBackgroundImage(UIImage(named: "btn_switch_off"), for: .highlighted)
        } else {
            switchButton.setBackgroundImage(UIImage(named: "btn_switch_off"), for: .normal)
            switchButton.setBackgroundImage(UIImage(named: "btn_switch_on"), for: .highlighted)
        }
    }
    
    @objc func handleTapOnBoxNumber(sender: Any) {
        delegate?.didTapBoxNumber(atIndex: index!, mode: extendMode)
    }
    
    @objc func handleTapShopNameLabel(sender: Any) {
        
        guard let package = model as? PackageModel else {
            return
        }
        
        delegate?.didTapShopNameLabel(text: package.title)
    }
    
    @objc func handleTapOnBoardView(sender: Any) {
        delegate?.didTapTrackInfoButton(atIndex: index!)
    }
    
    @IBAction func didTapShowMoreButton(_ sender: Any) {
        delegate?.didTapLoadMoreButton()
    }
    
    @IBAction func didTapCloseOnBoardButton(_ sender: Any) {
        delegate?.didTapCloseInfoBarButton(atIndex: index!)
    }
    
    @IBAction func didTapSaveButton(_ sender: Any) {
        if saveButton.isEnabled == true {
            delegate?.didTapSaveButton(atIndex: index!)
        }
    }
    
    @IBAction func didTapSwitchButton(_ sender: Any) {
        delegate?.didTapSwitchButton(atIndex: index!)
    }
    
    @IBAction func didTapCloseButton(_ sender: Any) {
        delegate?.didTapCloseButton(atIndex: index!)
    }
    
    @IBAction func didTapWarrantyButton(_ sender: Any) {
        setActiveSubmitButton(isActive: false)
        delegate?.didTapWarrantyButton(atIndex: index!)
    }
    
    @IBAction func didTapPriceMatchButton(_ sender: Any) {
        setActiveSubmitButton(isActive: false)
        delegate?.didTapPriceMatchButton(atIndex: index!)
    }
    
    @IBAction func didTapReturDateButton(_ sender: Any) {
        setActiveSubmitButton(isActive: false)
        delegate?.didTapReturnDateButton(atIndex: index!)
    }
    
    @IBAction func didTapCameraButton(_ sender: Any) {
        setActiveSubmitButton(isActive: false)
        delegate?.didTapTakePhotoButton(atIndex: index!)
    }
    
    @IBAction func didTapWarningButton(_ sender: Any) {
        setActiveSubmitButton(isActive: false)
    }
    
    @IBAction func didTapShareButton(_ sender: Any) {
        setActiveSubmitButton(isActive: false)
        delegate?.didTapShareButton(atIndex: index!)
    }
    
    
    func moveNext(viewSwap: UIView, index: Int, completion: ((Bool) -> Void)? = nil) {
        
        if let currentIndex = actionStackView.arrangedSubviews.firstIndex(of: viewSwap) {
            if currentIndex == index {
                if let completedBlock = completion {
                    completedBlock(true)
                }
                
                return
            }
            
            UIView.animate(withDuration: 0.7, animations: {
                self.actionStackView.removeArrangedSubview(viewSwap)
                self.actionStackView.insertArrangedSubview(viewSwap, at: index)
                self.actionStackView.layoutIfNeeded()
            }) { (isCompleted) in
                //self.moveNext(viewSwap: viewSwap, index: index)
            }
        }
    }
    
    func moveNextClone(viewSwap: UIView, index: Int, completion: ((Bool) -> Void)? = nil) {
        
        if let currentIndex = actionStackView.arrangedSubviews.firstIndex(of: viewSwap) {
            if currentIndex == index {
                if let completedBlock = completion {
                    completedBlock(true)
                }
                
                return
            }
            
            UIView.animate(withDuration: 0.5, animations: {
                self.actionStackView.removeArrangedSubview(viewSwap)
                self.actionStackView.insertArrangedSubview(viewSwap, at: currentIndex - 1)
                self.actionStackView.layoutIfNeeded()
            }) { (isCompleted) in
                //self.moveNext(viewSwap: viewSwap, index: index)
            }
        }
    }
    
    @IBAction func didTapMessageButton(_ sender: Any) {
        setActiveSubmitButton(isActive: false)
        delegate?.didTapMessageButton(atIndex: index!)
        reloadTableView()
    }
    
    @IBAction func didTapTraceButton(_ sender: Any) {
        setActiveSubmitButton(isActive: false)
        delegate?.didTapTraceButton(atIndex: index!)
    }
}

//MARK: - FSPagerViewDataSource
extension PackageTableViewCell: FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        
        guard let package = model as? PackageModel else {
            return 0
        }
        
        return package.imageUrls.count
    }
    
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        pageControl.currentPage = index
        
        guard let package = model as? PackageModel else {
            return cell
        }
        
        let urlImageStr = NetworkingConstants.baseURL + package.imageUrls[index]
        //print(urlImageStr)
//        cell.imageView?.contentMode = .scaleToFill
        cell.imageView?.sd_setImage(with: URL(string: urlImageStr), placeholderImage: UIImage(), options: .refreshCached, completed: { (image, error, cacheType, url) in
            self.activityIndiactor.stopAnimating()
            if let image = image {
//                let image_ratio = image.resize(image: image, targetSize: CGSize(width: self.frame.size.width, height: self.frame.size.width))
                var height = 180
                height += 374
                self.frame_height_constrain.constant = 464
                self.image_height_constrain.constant = 374
            }
        })
        
//        cell.imageView?.sd_setImage(with: URL(string: urlImageStr), completed: { (image, error, cacheType, url) in
//            if let image = image {
//                let image_ratio = image.resize(image: image, targetSize: CGSize(width: self.frame.size.width, height: self.frame.size.width))
//                var height = 180
//                height += Int(image_ratio.size.height )
//                self.frame_height_constrain.constant = CGFloat(height)
//                self.image_height_constrain.constant = CGFloat(height) - 180
//            }
//        })
//        let tapOnNumber = UITapGestureRecognizer(target: self, action: #selector(didTapCameraButton(_:)))
//        emptyImageView.addGestureRecognizer(tapOnNumber)
//        emptyImageView.isUserInteractionEnabled = true
        
        return cell
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        
        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        
        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!
        
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        
        return image
    }
}

//MARK: - FSPagerViewDelegate
extension PackageTableViewCell: FSPagerViewDelegate {
    
}


extension PackageTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return btn_collection_img_array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let item_space = 10
        
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCollectionViewCell", for: indexPath) as! ButtonCollectionViewCell
        if btn_collection_img_array[indexPath.row][0] == ""
        {
            cell.img_btn.isHidden = true
        }
        else
        {
            cell.img_btn.isHidden = false
            cell.img_btn.setImage(UIImage.init(named: btn_collection_img_array[indexPath.row][0]), for: .normal)
        }
//        let swipeRightPager = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToCameraSwipeGesture))
//        swipeRightPager.direction = UISwipeGestureRecognizerDirection.right
//        swipeRightPager.delegate = self
//        cell.contentView.addGestureRecognizer(swipeRightPager)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        

        let first_num = cell_index[sourceIndexPath.row]
        let second_num = cell_index[destinationIndexPath.row]
        let original_array = btn_collection_img_array
        if first_num < second_num
        {
            var new_array = [[String]]()
            for i in 0..<original_array.count
            {
                
            }
            
        }
        //print("-----------------")
        //print("source is : \(first_num) - target is : \(second_num)")
        
    }
}

extension PackageTableViewCell {
    func transitionAnimation(fromView: CGRect, toView: CGRect) {
        UIView.animate(withDuration: 2.0, animations: { () -> Void in
//            appleImage1.frame = appleImage.frame
//            appleImage.frame = appleImage1.frame
        })
    }
    
    @objc func respondToCameraSwipeGesture(_ recognizer: UISwipeGestureRecognizer) {
        print("Screen edge swiped!")
        
        if let swipeGesture = recognizer as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                print("Swiped right")
                if let index = pagerView?.currentIndex {
                    print(#function, index)
                }
            default:
                break
            }
        }
//        didTapTakePhotoButton(atIndex: IndexPath(item: 0, section: 0))
    }
            
//    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if let index = pagerView?.currentIndex,
//            let cell = pagerView.cellForItem(at: index) {
//            if index == 0{
//                self.respondToCameraSwipeGesture(gestureRecognizer as! UISwipeGestureRecognizer)
//            }
//            return touch.location(in: cell).y > 50
//        }
//        return false
//    }
}

extension PackageTableViewCell: UITableViewDelegate, UITableViewDataSource {
    
    func registerTableCell() {
        let headerNib = UINib(nibName: String(describing: DateHeaderTableViewCell.self), bundle: nil)
        self.tblComments.register(headerNib, forCellReuseIdentifier: String(describing: DateHeaderTableViewCell.self))
        
        let senderNib = UINib(nibName: String(describing: SenderTableViewCell.self), bundle: .main)
        self.tblComments.register(senderNib, forCellReuseIdentifier: String(describing: SenderTableViewCell.self))
        
        let RecieverNib = UINib(nibName: String(describing: RecieverTableViewCell.self), bundle: .main)
        self.tblComments.register(RecieverNib, forCellReuseIdentifier: String(describing: RecieverTableViewCell.self))
        
        self.tblComments.estimatedRowHeight = 51
        self.tblComments.rowHeight = UITableView.automaticDimension
        txtComments.delegate = self
    }
    
    func reloadTableView() {
        self.tblComments.dataSource = self
        self.tblComments.delegate = self
        self.tblComments.reloadData()
        DispatchQueue.main.async {
            if self.tblComments.contentSize.height > (self.tblComments.frame.size.height + 30) {
               self.tblComments.setContentOffset(CGPoint(x: self.tblComments.frame.origin.y, y: self.tblComments.contentSize.height+10), animated: true)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sectionCount = self.commentDateModel?.count else { return 0 }
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let aryFilter = self.commentModel?.filter({ $0.created_at == self.commentDateModel?[section] })
        guard let rowCount = aryFilter?.count else { return 0 }
        return rowCount
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       guard let strCreatedDate = self.commentDateModel?[section] else { return UIView() }
        if let headerView = self.tblComments.dequeueReusableCell(withIdentifier: String(describing: DateHeaderTableViewCell.self)) as? DateHeaderTableViewCell {
            headerView.lblCommentDate.text = strCreatedDate
            return headerView.contentView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aryFilter = self.commentModel?.filter({ $0.created_at == self.commentDateModel?[indexPath.section] })
        guard let model_data = aryFilter?[indexPath.row] else { return SenderTableViewCell() }
        
        let user_details = UserModel.sharedInstance
        if user_details.user_id == model_data.userid {
            guard let cellReceiver = tableView.dequeueReusableCell(withIdentifier: String(describing: RecieverTableViewCell.self), for: indexPath) as? RecieverTableViewCell else {  return RecieverTableViewCell() }
            cellReceiver.configureReceiverCell(model: model_data, indexPath: indexPath)
            return cellReceiver
        } else {
            guard let cellSender = tableView.dequeueReusableCell(withIdentifier: String(describing: SenderTableViewCell.self), for: indexPath) as? SenderTableViewCell else { return SenderTableViewCell() }
            cellSender.configureSenderCell(model: model_data, indexPath: indexPath)
            return cellSender
        }
    }
}

extension PackageTableViewCell : UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        animateViewWhenKeyboardApear()
        if textView == txtComments && textView.text == PackageTableViewCell.TXT_PLACEHOLDER_TEXT {
            txtComments.text = ""
            txtComments.textColor = .black
        }
        return true
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.delegate?.shouldChangeCommentsAtIndex(indexPath: index!, strComments: textView.text)
        animateViewWhenKeyboardDisApear()
    }
    
    func textViewDidChange(_ textView: UITextView) {
         self.delegate?.shouldChangeCommentsAtIndex(indexPath: index!, strComments: textView.text)
    }
        
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.count + text.count - range.length
        if(text == "\n") {
            if newLength == 0 || txtComments.text.isEmpty {
                txtComments.text = PackageTableViewCell.TXT_PLACEHOLDER_TEXT
                txtComments.textColor = .darkGray
//                self.delegate?.shouldChangeCommentsAtIndex(indexPath: index!, strComments: textView.text)
            }
            animateViewWhenKeyboardDisApear()
            textView.resignFirstResponder()
            return false
        }
        if newLength > 0 {
            if textView == txtComments && textView.text == PackageTableViewCell.TXT_PLACEHOLDER_TEXT {
                if text.count == 0 {
                    return false // ignore it
                }
                txtComments.text = ""
            }
//            self.delegate?.shouldChangeCommentsAtIndex(indexPath: index!, strComments: textView.text)
            return true
        } else {
            txtComments.text = PackageTableViewCell.TXT_PLACEHOLDER_TEXT
            txtComments.textColor = .darkGray
//            self.delegate?.shouldChangeCommentsAtIndex(indexPath: index!, strComments: textView.text)
            return false
        }
    }
}

extension PackageTableViewCell {
    func animateViewWhenKeyboardApear() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        UIView.animate(withDuration: 0.5, animations: {
            appDelegate?.window?.frame = CGRect(x: 0, y: -250, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }) { (isCompleted) in
        }
    }
    
    func animateViewWhenKeyboardDisApear() {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        UIView.animate(withDuration: 0.5, animations: {
            appDelegate?.window?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        }) { (isCompleted) in
        }
    }
}
