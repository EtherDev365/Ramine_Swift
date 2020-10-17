//
//  TruckCell.swift
//  TruckTrace
//
//  Created by Admin on 1/18/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol TruckCellDelegate: AnyObject {
    func didClickOnTitleArea(cell: TruckCell)
    
    func didClickOnReturnDateButton(cell: TruckCell)
    func didClickOnWarrantyDateButton(cell: TruckCell)
    
    func didClickOnTruck(cell: TruckCell)
    func didClickOnCamera(cell: TruckCell)
    func didClickOnRefresh(cell: TruckCell)
    func didClickOnShare(cell: TruckCell)
    func didClickOnComment(cell: TruckCell)
}

class TruckCell: UITableViewCell {
        
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var topRightView: UIView!
    @IBOutlet weak var iconsView: UIView!
    
    @IBOutlet weak var viewTitleBG: UIView!
    @IBOutlet weak var imgViewAvatar: UIImageView!
    @IBOutlet weak var lblTitleURL: UILabel!
    @IBOutlet weak var lblTitleDate: UILabel!
    
    @IBOutlet weak var imgViewRunning: UIImageView!
    @IBOutlet weak var viewMenu: UIView!
    @IBOutlet weak var viewImgContent: UIView!
    
    @IBOutlet weak var lblCourier: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblSuffixNumber: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    var imgViews: [UIImageView] = []
    
    var topRightExpanded: Bool = false
    var delegate : TruckCellDelegate?
    var packageModel: PackageModel? = nil
    var rowIndex: Int = 0

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.contentView.layoutIfNeeded()
        
        var i: Int = 0;
        for itemView in self.imgViews {
            let hei = self.viewImgContent.frame.height
            let gap: CGFloat = 10
            let totalWid = self.viewImgContent.frame.width
            let wid = (totalWid - gap*2)/3
            itemView.frame = CGRect(x: (wid+gap)*CGFloat(i), y: 0, width: wid, height: hei)
            i = i + 1
        }
    }
    
    func initControls() {
        self.containerView.layer.cornerRadius = 10
        self.containerView.layer.masksToBounds = true
        
        self.topRightView.layer.cornerRadius = 20
        self.topRightView.layer.masksToBounds = true
        
        self.viewTitleBG.backgroundColor = .clear
        self.imgViewAvatar.layer.cornerRadius = 10
        self.imgViewAvatar.layer.masksToBounds = true
        
        self.viewImgContent.backgroundColor = .clear
        
        self.iconsView.backgroundColor = .clear
        
        //self.backgroundColor = .white
    }
    
    func initActions() {
        let tapOnTitle = UITapGestureRecognizer(target: self, action: #selector(handleTapOnTitleArea(sender:)))
        self.viewTitleBG.addGestureRecognizer(tapOnTitle)
        
        let tapOnRightTop = UITapGestureRecognizer(target: self, action: #selector(handleTapOnTopRight(sender:)))
        self.topRightView.addGestureRecognizer(tapOnRightTop)
        
        //let topOnEntireArea = UITapGestureRecognizer(target: self, action: #selector(handleTapOnEntireArea(sender:)))
        //self.addGestureRecognizer(topOnEntireArea)
    }
    
    func initButtons() {
        for i in 0...5 {
            var image_n = UIImage(named: "btn_s\(i+1)_n")
            var image_d = UIImage(named: "btn_s\(i+1)_d")
            
            let button = UIButton(type: .custom)
            
            if i == 3 {
                //image_n = UIImage(named: "Update icon")
                image_n = UIImage(named: "Comment icon")
                image_d = nil
            } else if i == 5 {
                image_n = UIImage(named: "Share icon")
                image_d = nil
            } else {
                button.setBackgroundImage(image_d, for: .highlighted)
            }
            
            button.setBackgroundImage(image_n, for: .normal)
            button.tag = i
            
            self.iconsView.addSubview(button)
            
            let hei = self.iconsView.frame.height
            let wid = hei
            let gap = hei/4
            button.frame = CGRect(x: gap+(wid+gap)*CGFloat(i), y: 0, width: wid, height: hei)
            button.addTarget(self, action: #selector(onBtnIconClicked(sender:)), for: .touchUpInside)
        }
    }
    
    open func expandTopRightView() {
        for constraint in self.topRightView.constraints {
            if constraint.identifier == "topright_view_width" {
               constraint.constant = 240
            }
            if constraint.identifier == "topright_view_height" {
               constraint.constant = 150
            }
        }
        self.layoutIfNeeded()
        self.topRightExpanded = true
    }
    
    open func compactTopRightView() {
        for constraint in self.topRightView.constraints {
            if constraint.identifier == "topright_view_width" {
               constraint.constant = 76
            }
            if constraint.identifier == "topright_view_height" {
               constraint.constant = 90
            }
        }

        self.layoutIfNeeded()
        self.topRightExpanded = false
    }
    
    @objc func onBtnIconClicked(sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        
        if button.tag == 0 {
            self.delegate?.didClickOnReturnDateButton(cell: self)
        } else if button.tag == 1 {
            self.delegate?.didClickOnWarrantyDateButton(cell: self)
        } else if button.tag == 2 { // truck
            self.delegate?.didClickOnTruck(cell: self)
        } else if button.tag == 3 {
            self.delegate?.didClickOnComment(cell: self)
        } else if button.tag == 4 {
            self.delegate?.didClickOnCamera(cell: self)
        } else if button.tag == 5 {
            self.delegate?.didClickOnShare(cell: self)
        }
    }
    
    @IBAction func onBtnRefresh(_ sender: Any) {
        self.delegate?.didClickOnRefresh(cell: self)
    }
    
    @objc func handleTapOnTitleArea(sender: Any) {
        self.delegate?.didClickOnTitleArea(cell: self)
    }
    
    @objc func handleTapOnTopRight(sender: Any) {
        if topRightExpanded == false {
            UIView.animate(withDuration: 0.2) {
                self.expandTopRightView()
            }
        } else {
            UIView.animate(withDuration: 0.2) {
                self.compactTopRightView()
            }
        }
    }
    
    @objc func handleTapOnEntireArea(sender: Any) {
        if topRightExpanded {
            UIView.animate(withDuration: 0.2) {
                self.compactTopRightView()
            }
        }
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()

        self.initControls()
        self.initButtons()
        self.initActions()
        
        self.compactTopRightView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        /*
        if selected == true {
            contentView.backgroundColor = UIColor.lightGray
        } else {
            contentView.backgroundColor = UIColor.white
        }*/
    }
    
    func setCurrentRunStep(step: Int) {
        imgViewRunning.image = UIImage(named: "icon_run\(step)")
    }
    
    func setType(type: Int) {
        setCurrentRunStep(step: type)
        
        self.viewImgContent.isHidden = false
        self.imgViewRunning.isHidden = false
        self.viewMenu.isHidden = false
        self.viewTitleBG.isHidden = false
        
        if type == 3 {
            self.containerView.backgroundColor = UIColor.init(red: 230/255.0, green: 240/255.0, blue: 226/255.0, alpha: 1.0)
        } else if type == 2 {
            self.containerView.backgroundColor = UIColor.init(red: 252/255.0, green: 228/255.0, blue: 238/255.0, alpha: 1.0)
        } else {
            self.containerView.backgroundColor = UIColor.init(red: 219/255.0, green: 219/255.0, blue: 234/255.0, alpha: 1.0)
        }
    }
    
    func initContentImages(imgUrls: [String]) {
        
        for view in self.imgViews {
            view.removeFromSuperview()
        }
        
        self.imgViews = []
        var i: Int = 0
        
        for url in imgUrls {
            let image = UIImage(named: "img\(i+1)")
            let itemView = UIImageView(image: image)
            
            let fullPath = (NetworkingConstants.baseURL + url)
            itemView.setImageWithURL(urlString: fullPath, placeholderImage: nil)
            
            self.viewImgContent.addSubview(itemView)
            self.imgViews.append(itemView)

            let hei = self.viewImgContent.frame.height
            let gap: CGFloat = 10
            let totalWid = self.viewImgContent.frame.width
            let wid = (totalWid - gap*2)/3
            itemView.frame = CGRect(x: (wid+gap)*CGFloat(i), y: 0, width: wid, height: hei)
            i = i + 1
        }
    }
    
    func setData(_ model_data: PackageModel, atRow row:Int) {
        self.packageModel = model_data
        self.rowIndex = row

        /*
        if model_data.logoUrl!.isEmpty {
            if model_data.defaultUrl! != "" {
                let myLogoImage = (NetworkingConstants.baseURL + model_data.defaultUrl!)
                cell.logoImageView.setImageWithURL(urlString: myLogoImage, placeholderImage: cell.logoImageView.getPlaceHolderImage(text: model_data.title!))
            } else {
                cell.logoImageView.setImageWithURL(urlString: "", placeholderImage: cell.logoImageView.getPlaceHolderImage(text: model_data.title!))
            }
        } else {
            let myLogoImage = NetworkingConstants.baseURL + model_data.logoUrl!
            cell.logoImageView.setImageWithURL(urlString: myLogoImage, placeholderImage: cell.logoImageView.getPlaceHolderImage(text: model_data.title!))
        }

        // to cahnge the image on tap
        cell.logoImageViewButton.tag = indexPath.row
        cell.logoImageViewButton.addTarget(self, action: #selector(packageImageViewTapped(_:)), for: .touchUpInside)
        */

        let courier = model_data.courier
        let suffixNumber = String(model_data.shipmentId.suffix(6))

        self.lblCourier.text = courier
        self.lblNumber.text = model_data.shipmentId
        self.lblSuffixNumber.text = suffixNumber
        self.lblDescription.text = model_data.text_description
        
        self.lblTitleURL.text = model_data.title
        
        if model_data.time == nil {
            self.lblTitleDate.text = model_data.time
        } else {
            self.lblTitleDate.text = String(model_data.time!.prefix(10))
        }

        var txtStatus = ""
        if( model_data.status! == "DELIVERED" || model_data.status! == "Being Delivered" ) {
            txtStatus = "Leveret"
            self.setType(type: 3)
        } else if(model_data.status! == "AVAILABLE_FOR_DELIVERY" || model_data.status! == "INDELIVERY"){
            if(model_data.status! == "AVAILABLE_FOR_DELIVERY"){
                txtStatus = "Klar til afhentning"
            } else {
                txtStatus = "Snart klar"
            }
            self.setType(type: 2)
        } else if(model_data.status! == "EN_ROUTE" || model_data.status! == "INTRANSIT" || model_data.status! == "INWAREHOUSE") {
            txtStatus = "På vej"
            self.setType(type: 1)
        } else {
            if( model_data.status! == "INFORMED" ) {
                txtStatus = "Kurer informeret"
            }
            if( model_data.status! == "PREADVICE" ) {
                txtStatus = "Kurer informeret"
            }
            self.setType(type: 0)
        }
        
        self.initContentImages(imgUrls: model_data.imageUrls)
    }
}
