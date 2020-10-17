//
//  BottomTabBar.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit

class BottomTabBar: UITabBarController,UITabBarControllerDelegate {

    var status_id = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        setupTabBar()
        self.delegate = self
                self.tabBar.tintColor = UIColor.black
                self.tabBar.unselectedItemTintColor = UIColor(red:0.76, green:0.22, blue:0.21, alpha:1.0)
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            
            case 2436:
                self.tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.black, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height:  tabBar.frame.height-1), lineWidth: 2.0)
                
            case 2688:
                self.tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.black, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height:  tabBar.frame.height-1), lineWidth: 2.0)
                
            case 1792:
                self.tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.black, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height:  tabBar.frame.height-1), lineWidth: 2.0)
                
            default:
                self.tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.black, size: CGSize(width: tabBar.frame.width/CGFloat(tabBar.items!.count), height:  tabBar.frame.height), lineWidth: 2.0)
            }
        }
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        var tabFrame = tabBar.frame
//        tabFrame.size.height = 55
//        tabFrame.origin.y = self.view.frame.size.height - 55
//        tabBar.frame = tabFrame
    }
    
    func setupTabBar() {
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        //let navOne = storyboard.instantiateViewController(withIdentifier: "DashboardNewVCNAV")
        let newboard = UIStoryboard.init(name: "NewBoard", bundle: nil)
        let vc = MainViewController()
        let navOne = UINavigationController(rootViewController: vc)
       
        //newboard.instantiateViewController(withIdentifier: "NewboardVCNav")
        
//
//        navOne.title = ""
//        navOne.tabBarItem.image = UIImage(named: "box_icon")?.withRenderingMode(.automatic)
   let vc4 = storyboard.instantiateViewController(withIdentifier: "favoritenav")
//        vc4.title = ""
//        vc4.tabBarItem.image = UIImage(named: "valentines-heart")?.withRenderingMode(.automatic)
        setViewControllers([navOne, vc4], animated: true)
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

}

extension UIImage {
    func createSelectionIndicator(color: UIColor, size: CGSize, lineWidth: CGFloat) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: lineWidth))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
