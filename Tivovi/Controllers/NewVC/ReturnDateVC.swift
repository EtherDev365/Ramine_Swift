//
//  ReturnDateVC.swift
//  TruckTrace
//
//  Created by Admin on 1/20/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit
import RappleProgressHUD

class ReturnDateVC: UIViewController, PickerVCDelegate {

    

    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var viewContent: UIView!
    @IBOutlet weak var viewDateArea: UIView!
    @IBOutlet weak var viewDate1: UIView!
    @IBOutlet weak var viewDate2: UIView!

    @IBOutlet weak var lblBigNum1: UILabel!
    @IBOutlet weak var lblNumDesc1: UILabel!
    @IBOutlet weak var lblBigNum2: UILabel!
    @IBOutlet weak var lblNumDesc2: UILabel!

    @IBOutlet weak var lblDateDesc1: UILabel!
    @IBOutlet weak var lblDate1: UILabel!
    
    @IBOutlet weak var lblDateDesc2: UILabel!
    @IBOutlet weak var lblDate2: UILabel!
    
    @IBOutlet weak var btnOnOff: UIButton!
    @IBOutlet weak var btnSave: UIButton!
    
    var bSwitchedOn: Bool = true
    var pickerVC: PickerVC!
    
    var bReturnMode: Bool = true
    var nLeftNum: Int = 10
    var nRightNum: Int = 20
    
    var user_id: String?
    var package_id: String?
    var packageModel: PackageModel?

    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.initControls()
        self.initActions()
        
        self.pickerVC = (UIStoryboard(name: "NewBoard", bundle: nil).instantiateViewController(withIdentifier: "PickerVC") as! PickerVC)
        self.addChild(self.pickerVC)
        self.pickerVC.delegate = self
    }
    
    func set(returnMode: Bool, leftNum: Int, rightNum: Int) {
        self.bReturnMode = returnMode
        self.nLeftNum = leftNum
        self.nRightNum = rightNum
        
        self.refreshLabelsByMode()
        self.refreshNumbers()
    }
    
    func setAutoFontSize() {
        lblBigNum1.minimumScaleFactor = 0.1
        lblBigNum1.adjustsFontSizeToFitWidth = true
        lblBigNum1.lineBreakMode = .byClipping
        lblBigNum1.numberOfLines = 0

        lblBigNum2.minimumScaleFactor = 0.1
        lblBigNum2.adjustsFontSizeToFitWidth = true
        lblBigNum2.lineBreakMode = .byClipping
     
        lblBigNum2.numberOfLines = 0
    }
    
    func refreshLabelsByMode() {
        if self.bReturnMode {
            lblTitle.text = "Retur"
            lblNumDesc1.text = "dage"
            lblNumDesc2.text = "dage"
            lblDateDesc1.text = "Retur senest"
            lblDateDesc2.text = "Notification"
        } else {
            lblTitle.text = "Garanti"
            lblNumDesc1.text = "år"
            lblNumDesc2.text = "dage"
            lblDateDesc1.text = "Garantperiode"
            lblDateDesc2.text = "Notification"
        }
    }
    
    func refreshNumbers() {
        self.lblBigNum1.text = "\(self.nLeftNum)"
        self.lblBigNum2.text = "\(self.nRightNum)"
    }
    
    func setSwitchOnOff(bOn: Bool) {
        bSwitchedOn = bOn
        
        if bSwitchedOn {
            btnOnOff.setBackgroundImage(UIImage(named: "btn_switch_on"), for: .normal)
            btnOnOff.setBackgroundImage(UIImage(named: "btn_switch_off"), for: .highlighted)
        } else {
            btnOnOff.setBackgroundImage(UIImage(named: "btn_switch_off"), for: .normal)
            btnOnOff.setBackgroundImage(UIImage(named: "btn_switch_on"), for: .highlighted)
        }
    }
    
    func initControls() {
        self.setAutoFontSize()

        viewContent.layer.cornerRadius = 20
        viewContent.layer.masksToBounds = true
        
        viewDateArea.layer.cornerRadius = 20
        viewDateArea.layer.masksToBounds = true
        
        viewDate1.layer.cornerRadius = 20
        viewDate1.layer.masksToBounds = true
        
        viewDate2.layer.cornerRadius = 20
        viewDate2.layer.masksToBounds = true
        
        btnSave.layer.cornerRadius = 5
        btnSave.layer.masksToBounds = true
        
        setSwitchOnOff(bOn: true)
        self.refreshNumbers()
    }
    
    func initActions() {
        let tapOnNumber1 = UITapGestureRecognizer(target: self, action: #selector(handleTapOnBigNum(sender:)))
        self.viewDate1.addGestureRecognizer(tapOnNumber1)
        
        let tapOnNumber2 = UITapGestureRecognizer(target: self, action: #selector(handleTapOnBigNum(sender:)))
        self.viewDate2.addGestureRecognizer(tapOnNumber2)
    }
    
    @objc func handleTapOnBigNum(sender: Any) {
        showPickerView()
        
        if self.bReturnMode {
            self.pickerVC.setRange(from: 0, to: 100, ofLeft: true)
            self.pickerVC.setRange(from: 0, to: 100, ofLeft: false)
            self.pickerVC.setInitValue(leftIndex: self.nLeftNum, rightIndex: self.nRightNum)
        } else {
            self.pickerVC.setRange(from: 1, to: 25, ofLeft: true)
            self.pickerVC.setRange(from: 0, to: 100, ofLeft: false)
            self.pickerVC.setInitValue(leftIndex: self.nLeftNum-1, rightIndex: self.nRightNum)
        }
    }
    
    func showPickerView() {
        self.view.addSubview(self.pickerVC.view)
        self.pickerVC.view.frame = self.view.bounds
    }
    
    @IBAction func onBtnClose(_ sender: Any) {
        self.view.removeFromSuperview()
    }
    
    @IBAction func onBtnOnOff(_ sender: Any) {
        setSwitchOnOff(bOn: !self.bSwitchedOn)
    }
    
    @IBAction func onBtnSave(_ sender: Any) {
        saveData()
    }
    
    func didSelectedAtIndexes(leftIndex: Int, rightIndex: Int) {
        if self.bReturnMode {
            self.nLeftNum = leftIndex
        } else {
            self.nLeftNum = leftIndex + 1
        }
        
        self.nRightNum = rightIndex
        
        refreshNumbers()
    }
    
    func didSelectedAtIndexes(leftIndex: Int, rightIndex: Int, extendMode: (IndexPath, PackageExtendMode)) {
        
    }
    
    func saveData() {
        var type = "waranty"
        if self.bReturnMode {
            type = "return"
        }
        
        let value = "\(nLeftNum)"
        let notification = "\(nRightNum)"
        
        let parameterDict =  ["user_id":  self.user_id ?? "", "id": self.package_id ?? "", "type": type, "value": value, "notification": notification]
        
        API_updatePackage(parameterDict: parameterDict)
    }
    
    func API_updatePackage(parameterDict: [String: String]) {
        RappleActivityIndicatorView.startAnimating()
        
        DashboardManager.API_updatePackage(information: parameterDict) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()

            if error == nil {
                //print(json)
                
                if self.bReturnMode {
                    self.packageModel?.return_days = self.nLeftNum
                    self.packageModel?.notification_days = self.nRightNum
                } else {
                    self.packageModel?.waranty_months = self.nLeftNum
                    self.packageModel?.w_notification_days = self.nRightNum
                }                
            } else {
                //print("API_updatePackage failed")
            }
        }
    }
}
