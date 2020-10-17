//
//  BaseViewController.swift
//  Tivovi
//
//  Created by Đinh Trọng Tú on 2/21/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            //overrideUserInterfaceStyle = .light
        } else {
            // Fallback on earlier versions
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
