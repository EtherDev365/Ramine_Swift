//
//  ProductListVC.swift
//  TruckTrace
//
//  Created by Admin on 1/20/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol ProductListVCDelegate: AnyObject {
    func onHideProductList(vc: ProductListVC)
}

class ProductListVC: UIViewController {

    @IBOutlet weak var scrView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    var delegate: ProductListVCDelegate?
    
    var listItemViews: [ProductItemVC] = []
    var listDotViews: [UIView] = []
    var previosPos: CGFloat = 0
    
    var packageModel: [PackageModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initActions()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.refreshList()
    }
    
    func refreshList() {
        self.removeAllItemViews()
        self.removeAllDotViews()
        
        self.initList()
    }
    
    func removeAllItemViews() {
        for itemView in self.listItemViews {
            itemView.removeFromParent()
            itemView.view.removeFromSuperview()
        }
        
        self.listItemViews = []
    }
    
    func removeAllDotViews() {
        for dotView in self.listDotViews {
            dotView.removeFromSuperview()
        }
        self.listDotViews = []
    }
    
    func addProductItem(model: PackageModel, toTop: CGFloat) {
        let itemVC = (UIStoryboard(name: "NewBoard", bundle: nil).instantiateViewController(withIdentifier: "ProductItemVC") as! ProductItemVC)
        itemVC.packageModel = model
        self.addChild(itemVC)
        
        self.contentView.addSubview(itemVC.view)
        self.listItemViews += [itemVC]
        
        let frame = self.contentView.bounds
        let rect = CGRect(x: 0, y: toTop, width: frame.width, height: 50)
        itemVC.view.frame = rect
        
        var yPos = previosPos
        while yPos < toTop {
            let dotView = UIView()
            self.contentView.addSubview(dotView)
            
            dotView.backgroundColor = .gray
            dotView.frame = CGRect(x: 60, y: yPos, width: 5, height: 5)
            dotView.layer.cornerRadius = 2.5
            dotView.layer.masksToBounds = true
            dotView.layer.zPosition = -1
            
            self.listDotViews += [dotView]
            
            yPos += 20
        }
        
        previosPos = yPos
    }
    
    func initActions() {
        let tapOnBack = UITapGestureRecognizer(target: self, action: #selector(handleTapOnBack(sender:)))
        self.view.addGestureRecognizer(tapOnBack)
    }
    
    @objc func handleTapOnBack(sender: Any) {
        self.delegate?.onHideProductList(vc: self)
    }
    
    func initList() {
        guard let models = self.packageModel else {
            return
        }
        
        var top: CGFloat = 0
        previosPos = 0
        
        for model in models {
            self.addProductItem(model: model, toTop: top)
            top += 150
        }
        
        for constraint in self.contentView.constraints {
            if constraint.identifier == "contentHeight" {
               constraint.constant = top
            }
        }
        self.view.layoutIfNeeded()
    }
}
