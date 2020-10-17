//
//  DashboardCell.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
protocol YourCellDelegate : class {
    func didPressButton(_ tag: Int)
}
protocol CustomCellDelegate: class {
    func updateTableView(row: Int)
}
protocol PopupCellDelegate: class {
    func didToggleRadioButton(_ indexPath: IndexPath)
}
class DashboardCell: UITableViewCell {
    
    @IBOutlet var lblUpdateText: UILabel!
    weak var delegateCheck: PopupCellDelegate?
    var cellDelegate: YourCellDelegate?
    @IBOutlet var imgNExt: UIImageView!
    @IBOutlet var firstViewBtn: UIButton!
    weak var delegate: CustomCellDelegate?
    
    
    @IBOutlet weak var btnPlus: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoImageViewButton: UIButton!

    @IBOutlet weak var lblSecondNumber: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    
    @IBOutlet weak var lblPostnord: UILabel!
    
    @IBOutlet weak var lblStatus: UILabel!
    //bottom details outlets here
    @IBOutlet weak var btnShare: UIButton!
    @IBOutlet weak var btnComment: UIButton!
    
    @IBOutlet weak var testAAA: UIButton!
    @IBOutlet var lblCat: UILabel!
    
    @IBOutlet var lblTitle: UILabel!
    
    
    @IBOutlet var lblNumberD: UILabel!
    
    
    @IBOutlet var imgStatus: UIButton!
    
    @IBOutlet var lblStatusD: UILabel!
    
    @IBOutlet var lblPlace: UILabel!
    
    @IBOutlet var lblShares: UILabel!
    
    @IBOutlet var lblComments: UILabel!
    var abc = ""
    
    
    @IBOutlet weak var btnUpdate: UIButton!
    
    @IBOutlet var lblLastUpdate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func ShowHideSecondView(_ sender: UIButton) {
        //print("First View: \(sender.tag)")
      //  self.imgNExt.isHidden = true
        delegate?.updateTableView(row: sender.tag)
        cellDelegate?.didPressButton(sender.tag)
        //delegateCheck?.didToggleRadioButton(<#T##indexPath: IndexPath##IndexPath#>)
    }
    
    func initCellItem(_ indexPath: IndexPath, idn: Int) {
        let deselectedImage = UIImage(named: "next")?.withRenderingMode(.alwaysOriginal)
    
        let selectedImage = UIImage(named: "arrow-down")?.withRenderingMode(.alwaysOriginal)
        firstViewBtn.setImage(deselectedImage, for: .normal)
        firstViewBtn.setImage(selectedImage, for: .selected)
        //btnSelect.tag = (indexPath.section*100)+indexPath.row
        firstViewBtn.tag = indexPath.row
        firstViewBtn.addTarget(self, action: #selector(self.radioButtonTapped), for: .touchUpInside)
    }
    @objc func radioButtonTapped(_ firstViewBtn: UIButton) {
        let isSelected = !self.firstViewBtn.isSelected
        self.firstViewBtn.isSelected = isSelected
        if isSelected {
            deselectOtherButton()
        }
        var view = self.superview
        while view != nil && (view is UITableView) == false {
            view = view?.superview
        }
        let tableView = view as! UITableView
        let tappedCellIndexPath = tableView.indexPath(for: self)!
        delegateCheck?.didToggleRadioButton(tappedCellIndexPath)
        
    }
    
    func deselectOtherButton() {
        var view = self.superview
        
        while view != nil && (view is UITableView) == false {
            view = view?.superview
        }
        
        let tableView = view as? UITableView
        
        //  let tableView = self.superview as! UITableView
        let tappedCellIndexPath = tableView!.indexPath(for: self)!
        let indexPaths = tableView!.indexPathsForVisibleRows
        for indexPath in indexPaths! {
            if indexPath.row != tappedCellIndexPath.row && indexPath.section == tappedCellIndexPath.section {
                let cell = tableView!.cellForRow(at: IndexPath(row: indexPath.row, section: indexPath.section)) as! DashboardCell
                cell.firstViewBtn.isSelected = false
                
            }
        }
    }
    

}
