//
//  CustomTabBarController.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController,UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
                self.tabBar.tintColor = UIColor.black
                self.tabBar.unselectedItemTintColor = UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)
      //  tabBar.barTintColor = UIColor(red: 38/255, green: 196/255, blue: 133/255, alpha: 1)
        setupTabBar()
        self.delegate = self
        //self.edgesForExtendedLayout = UIRectEdge.top
    }
    
    func setupTabBar() {
        //let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        //let navOne = storyboard.instantiateViewController(withIdentifier: "DashboardNewVCNAV")
        let storyboard = UIStoryboard.init(name: "NewBoard", bundle: nil)
        let navOne = storyboard.instantiateViewController(withIdentifier: "DashboardNewVCNAV")
        
        navOne.title = ""
        navOne.tabBarItem.image = UIImage(named: "box_icon")?.withRenderingMode(.alwaysOriginal)
        let vc4 = storyboard.instantiateViewController(withIdentifier: "favoritenav")
        vc4.title = ""
        vc4.tabBarItem.image = UIImage(named: "valentines-heart")?.withRenderingMode(.alwaysOriginal)
        setViewControllers([navOne, vc4], animated: true)

        guard let items = tabBar.items else { return }

        for item in items {
            item.imageInsets = UIEdgeInsets.init(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.tabBar.tintColor = UIColor.black
//        self.tabBar.unselectedItemTintColor = UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)
//        self.edgesForExtendedLayout = []
//       // self.edgesForExtendedLayout = UIRectEdge
//        self.delegate = self
//        //self.navigationController?.delegate = self
//        //self.navigationController?.navigationBar.isHidden = false
//
//        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
//        let vc1 = storyboard.instantiateViewController(withIdentifier: "homenav")
//        vc1.title = ""
//        vc1.tabBarItem.image = UIImage(named: "box_icon")
//
//        let navOne = storyboard.instantiateViewController(withIdentifier: "DashboardNewVCNAV")
//        navOne.title = ""
//        navOne.tabBarItem.image = UIImage(named: "box_icon")
//
//
//        let vc4 = storyboard.instantiateViewController(withIdentifier: "favoritenav")
//        vc4.title = ""
//        vc4.tabBarItem.image = UIImage(named: "heart")
//
//
//
//        self.tabBar.barTintColor = UIColor.white
//       self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
  //    setViewControllers([navOne,vc4], animated: true)
//
//
//
//    }
//
    override func viewDidAppear(_ animated: Bool) {
        
    }
    override func viewWillAppear(_ animated: Bool) {
        //self.tabBar.tintColor = UIColor.black
    }
    override func viewWillDisappear(_ animated: Bool) {
       // self.tabBar.tintColor = UIColor.black
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        //print("Selected item")
        //print(tabBar.items)
      ///  //print(self.tabBarController?.selectedIndex)
    }
    
    func tabBarController(_ tabBarController: UITabBarController,
                          didSelect viewController: UIViewController) {
        
        if(self.selectedIndex == 1){
            self.tabBar.tintColor = UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)
            self.tabBar.unselectedItemTintColor = UIColor.black
        }else{
            self.tabBar.tintColor = UIColor.black
            self.tabBar.unselectedItemTintColor = UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)
        }
        if let vc = viewController as? UINavigationController {
            vc.popViewController(animated: false);
        }
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if let restoreID = viewController.restorationIdentifier {
            if restoreID == "NavigationCamera" {
                //print("Nav is allowed")
                let newVC = tabBarController.storyboard?.instantiateViewController(withIdentifier: "ShareVC") as! UIViewController
                tabBarController.present(UINavigationController.init(rootViewController: newVC), animated: true, completion: {
                    //print("complete")
                })
                return false
            }
        }
        return true
    }
}


