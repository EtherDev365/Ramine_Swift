//
//  Helper.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//
import UIKit

class Helper {
    static var navCon = UINavigationController()
//    static func setupNavigationBar(view:UIView,value:UINavigationController){
//        let nav = value
//        nav.navigationBar.isHidden = false
//        nav.navigationBar.barTintColor = UIColor(red:0.00, green:0.60, blue:0.83, alpha:1.0)
//        nav.navigationBar.tintColor = UIColor.white
//        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        nav.navigationBar.shadowImage = UIImage()
//        nav.navigationBar.isTranslucent = true
//        nav.navigationBar.topItem?.titleView?.tintColor = UIColor.white
//        
//        var shadow = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 64))
//        if UIDevice().userInterfaceIdiom == .phone {
//            switch UIScreen.main.nativeBounds.height {
//            case 2436:
//                shadow = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 84))
//            default:
//                shadow = UIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 64))
//            }
//        }
//        
//        shadow.backgroundColor = UIColor(red:0.00, green:0.60, blue:0.83, alpha:1.0)
//        shadow.layer.shadowColor = UIColor(red:0.00, green:0.00, blue:0.00, alpha:3.0).cgColor
//        shadow.layer.shadowOffset = CGSize(width: 0, height: 25)
//        shadow.layer.shadowOpacity = 0.12
//        shadow.layer.shadowRadius = 4.5
//        view.addSubview(shadow)
//    }
//    //function for set titlebar text
//    static func title(view:UIView,value:UINavigationItem,title:String){
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
//        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
//        label.text = title
//        label.textAlignment = .center
//        label.textColor = UIColor.white
//        view.addSubview(label)
//        value.titleView = view
//    }
//    static func setupNavigationBarWithOutShadow(view:UIView,value:UINavigationController){
//        let nav = value
//        nav.navigationBar.isHidden = false
//        nav.navigationBar.barTintColor = UIColor(red:0.00, green:0.60, blue:0.82, alpha:1.0)
//        nav.navigationBar.tintColor = UIColor.white
//        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        nav.navigationBar.shadowImage = UIImage()
//        nav.navigationBar.isTranslucent = false
//        nav.navigationBar.topItem?.titleView?.tintColor = UIColor.white
//        
//        
//    }
//    static func dashboardNavigation(value:UINavigationController,leftItem: UIBarButtonItem){
//        let nav = value
//        self.navCon = value
////        nav.navigationBar.isHidden = false
////        nav.navigationBar.barTintColor = UIColor(red:0.00, green:0.60, blue:0.82, alpha:1.0)
////        nav.navigationBar.tintColor = UIColor.white
////        nav.navigationBar.setBackgroundImage(UIImage(), for: .default)
////        nav.navigationBar.shadowImage = UIImage()
////        nav.navigationBar.isTranslucent = false
////        nav.navigationBar.topItem?.titleView?.tintColor = UIColor.white
////        let rect = CGRect(x: 0, y: 0, width: 10, height: 10)
////       let button: UIButton = UIButton(type: UIButton.ButtonType.custom) as! UIButton
////        button.setImage(UIImage(named: "user.png"), for: UIControl.State.normal)
////       button.setTitle("Henrick", for: .normal)
////       button.setTitleColor(UIColor.black, for: .normal)
////       button.addTarget(self, action: "addTapped", for: UIControl.Event.touchUpInside)
////        button.sizeToFit()
////        button.frame = rect
////
////       let barButton = UIBarButtonItem(customView: button)
////
////        value.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
//         nav.navigationItem.leftBarButtonItem = leftItem
//        // nav.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
//         nav.navigationItem.title = "Welcome"
//    }
//    @objc static func addTapped(){
//        //searchBar.placeholder = "Your placeholder"
//        //var leftNavBarButton = UIBarButtonItem(customView:searchBar)
//        //self.navigationItem.leftBarButtonItem = leftNavBarButton
//       // searchBar.showsCancelButton = true
//        ////print("Hi")
//        let alert = UIAlertController(title: "Title", message: "Please Select an Option", preferredStyle: .actionSheet)
//        
//        alert.addAction(UIAlertAction(title: "Approve", style: .default , handler:{ (UIAlertAction)in
//            //print("User click Approve button")
//        }))
//        
//        alert.addAction(UIAlertAction(title: "Edit", style: .default , handler:{ (UIAlertAction)in
//            //print("User click Edit button")
//        }))
//        
//        alert.addAction(UIAlertAction(title: "Delete", style: .destructive , handler:{ (UIAlertAction)in
//            //print("User click Delete button")
//        }))
//        
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
//            //print("User click Dismiss button")
//        }))
//        self.navCon.present(alert, animated: true,completion: {
//            //            //print("completion block")
////        self.present(alert, animated: true, completion: {
////            //print("completion block")
//       })
//    }
}
