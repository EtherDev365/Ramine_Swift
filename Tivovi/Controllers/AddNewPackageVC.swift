//
//  AddNewPackageVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import BubbleTransition
import IQKeyboardManagerSwift
import JKNotificationPanel
import RappleProgressHUD
import Flurry_iOS_SDK

protocol refreshData {
    func refresNewData()
}
class AddNewPackageVC: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var tblMain: UITableView!
    @IBOutlet var txtV: UIView!
    let user_details = UserModel.sharedInstance
    var delegate:refreshData? = nil
    let pannel = JKNotificationPanel()
    @IBOutlet weak var btnLatterKeyboard: UIButton!
    @IBOutlet weak var btnKeyboard: UIButton!
    @IBOutlet weak var txtPackage: UITextField!
//    weak var interactiveTransition: BubbleInteractiveTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtPackage.becomeFirstResponder()
        self.btnKeyboard.isHidden = true
        self.txtPackage.delegate = self
//        IQKeyboardManager.sharedManager().enable = false
        //closeButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        txtPackage.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        txtPackage.attributedPlaceholder = NSAttributedString(string: "Enter tracking number",
                                                               attributes: [NSAttributedString.Key.foregroundColor: UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)])
        
        Flurry.logEvent("Add_Package");

    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
         //self.txtV.backgroundColor = UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)
    }
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        self.txtV.backgroundColor = UIColor.red
//        return true
//    }
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        self.txtV.backgroundColor = UIColor.green
//        return true
//    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//
//    }
//    func textFieldDidEndEditing(_ textField: UITextField) {
//
//    }
    @IBAction func closeAction(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
        // NOTE: when using interactive gestures, if you want to dismiss with a button instead, you need to call finish on the interactive transition to avoid having the animation stuck
//        interactiveTransition?.finish()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBarStyle(.default, animated: true)
    }
    
    @IBAction func clickDismiss(_ sender: Any) {
        self.navigationController?.popViewController(animated: false)
    }
    
    @IBAction func clickNext(_ sender: Any) {
     //   self.txtV.backgroundColor = UIColor(red:0.22, green:0.65, blue:0.73, alpha:1.0)
        if(self.txtPackage.text != ""){
            self.API_shipment_action()
        }else{
            let alert = UIAlertController(title: "Error", message: "Please enter shipment id", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                    
                    
                }}))
            self.present(alert, animated: true, completion: nil)
            //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Please enter shipment id")
        }
    }
    
    func API_shipment_action(){
        RappleActivityIndicatorView.startAnimating()
        
        let parameterDict =  [
            "user_id":  self.user_details.user_id ?? "",
            "shipmentId": self.txtPackage.text ?? "",
            "status": "0"
        ]
        DashboardManager.API_shipment_action(information: parameterDict) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            if error==nil {
                
                if(json["status"]==true) {
                    //print(json)

                    if (self.delegate != nil) {
                        self.delegate?.refresNewData()
                    }
                    
                    self.navigationController?.popViewController(animated: false)
                    
                }else{
                    var msg:String?
                    msg = json["message"].stringValue
                    let alert = UIAlertController(title: "Error", message: msg, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                        }}))
                    self.present(alert, animated: true, completion: nil)
//                    self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: msg ?? "")
                    
                }
            }
        }
    }
    @IBAction func clickKeyboard(_ sender: Any) {
       // self.txtV.backgroundColor = UIColor(red:0.22, green:0.65, blue:0.73, alpha:1.0)
//        self.btnKeyboard.isHidden = true
//        self.btnLatterKeyboard.isHidden = false
//        self.txtPackage.resignFirstResponder()
//        self.txtPackage.keyboardType = .numberPad
//        self.txtPackage.becomeFirstResponder()
        
    }
    
    @IBAction func clickDefaultKeyboard(_ sender: Any) {
      //  self.txtV.backgroundColor = UIColor(red:0.22, green:0.65, blue:0.73, alpha:1.0)
//        self.btnKeyboard.isHidden = false
//        self.btnLatterKeyboard.isHidden = true
//        self.txtPackage.resignFirstResponder()
//        self.txtPackage.keyboardType = UIKeyboardType.default
//        self.txtPackage.becomeFirstResponder()
    }
}
