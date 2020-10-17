//
//  menuAnimationFunctions.swift
//  Tivovi
//
//  Created by Raminde on 21/08/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import Foundation
import UIKit
func showWebshop(_ sender: Any)
   {
    if(LeftLineG?.center.x != BtnCubeG?.center.x){
        LeftLineG?.center.x = btnPlusG?.center.x ?? 0
           RightLineG?.center.x = btnPlusG?.center.x ?? 0
           LeftLineG?.alpha = 0
           RightLineG?.alpha = 0
           UIView.animate(withDuration: 0.2, delay: 0.0,
                          options: [.curveEaseInOut], animations: {
                           LeftLineG?.center.x = BtnCubeG?.center.x ?? 0
                           RightLineG?.center.x = btnPlusG?.center.x ?? 0
                           LeftLineG?.alpha = 1
                            RightLineG?.alpha = 0
           }) { (isCompeleted) in
               //  Vback.isHidden = false
           }
           
           let storyboard = UIStoryboard(name: "NewBoard", bundle: nil)
           
           let vc = storyboard.instantiateViewController(withIdentifier: "webshopsVC") as! webshopsVC
           // vc.shipmentId = singlePackageDetail.id
           GLOBAL_IMG = nil
           //navigationController?.present(vc, animated: true, completion: nil)
           // navigationController?.pushViewController(vc, animated: true)
           
           let transition = CATransition()
           transition.duration = 0.25
           transition.type = CATransitionType.moveIn
           transition.subtype = CATransitionSubtype.fromLeft
           transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
       // vc.tabBarController?.view.layer.add(transition, forKey: kCATransition)
           //navigationController?.popToRootViewController(animated: true)
    //    vc.navigationController?.pushViewController(vc, animated: false)
           
       }
   }
 
  func showAdded(_ sender: Any) {
       if(RightLineG?.center.x != BtnHeartG?.center.x){
        LeftLineG?.center.x = btnPlusG?.center.x ?? 0
        RightLineG?.center.x = btnPlusG?.center.x ?? 0
       LeftLineG?.alpha = 0
       RightLineG?.alpha = 0
       
       UIView.animate(withDuration: 0.2, delay: 0.0,
       options: [.curveEaseInOut], animations: {
       LeftLineG?.center.x = btnPlusG?.center.x ?? 0
       RightLineG?.center.x = BtnHeartG?.center.x ?? 0
     LeftLineG?.alpha = 0
      RightLineG?.alpha = 1
           }) { (isCompeleted) in
                                              //  Vback.isHidden = false
                                            }
       //tabBarController?.selectedIndex = 1
       //dismiss(animated: true, completion: nil)
                let transition = CATransition()
                      transition.duration = 0.25
                      transition.type = CATransitionType.moveIn
                      transition.subtype = CATransitionSubtype.fromRight
                      transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
       
     //   tabBarController?.view.layer.add(transition, forKey: kCATransition)
                      //navigationController?.popToRootViewController(animated: true)
     //  navigationController?.popToRootViewController(animated: false)

       }
   }
  
