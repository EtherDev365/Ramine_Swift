//
//  PickerVC.swift
//  TruckTrace
//
//  Created by Admin on 1/21/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

protocol PickerVCDelegate: AnyObject {
    func didSelectedAtIndexes(leftIndex: Int, rightIndex: Int, extendMode: (IndexPath, PackageExtendMode))
}

class PickerVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var picker: UIPickerView!
    
    var nLeftMin: Int = 1
    var nLeftMax: Int = 25
    var nRightMin: Int = 0
    var nRightMax: Int = 100
    var component : Int = 1
    
    var delegate: PickerVCDelegate?
    var extendMode = (IndexPath(row: 0, section: 0), PackageExtendMode.None)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.containerView.layer.cornerRadius = 20
        self.containerView.layer.masksToBounds = true
        
        picker.delegate = self
        picker.dataSource = self
        //picker.setValue(UIColor.white, forKey: "textColor")
    }
    
    func setRange(from: Int, to: Int, ofLeft: Bool) {
        if ofLeft {
            self.nLeftMin = from
            self.nLeftMax = to
        } else {
            self.nRightMin = from
            self.nRightMax = to
        }
    }
    
    func setInitValue(leftIndex: Int, rightIndex: Int) {
        picker.reloadAllComponents()
        
        picker.selectRow(leftIndex, inComponent: 0, animated: true)
        picker.selectRow(rightIndex, inComponent: 1, animated: true)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return component
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            return nLeftMax - nLeftMin + 1
        } else {
            return nRightMax - nRightMin + 1
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int)-> NSAttributedString? {
        var label = ""
        if component == 0 {
            label = "\(row + nLeftMin)"
        } else {
            label = "\(row + nRightMin)"
        }
        
        return NSAttributedString(string: label, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }

    /*
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            return "\(row + nLeftMin)"
        } else {
            return "\(row + nRightMin)"
        }
    }*/

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    @IBAction func onBtnConfirm(_ sender: Any) {
        
        if (component == 1)
        {
            self.delegate?.didSelectedAtIndexes(leftIndex: picker.selectedRow(inComponent: 0), rightIndex: 0, extendMode: extendMode)

        }else
        {
            self.delegate?.didSelectedAtIndexes(leftIndex: picker.selectedRow(inComponent: 0), rightIndex: picker.selectedRow(inComponent: 1), extendMode: extendMode)
        }
        self.view.removeFromSuperview()
    }
    
    @IBAction func onBtnCancel(_ sender: Any) {
        self.view.removeFromSuperview()
    }
}
