//
//  LogoutVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit

class LogoutVC: UIViewController {
    
    let prefs = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        let model = UserModel.sharedInstance
        prefs.set("0", forKey: "loginKey")
        UserDefaults.standard.removeObject(forKey: "notificationDayArray")
        let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "NViewController") as! NViewController
        self.navigationController?.pushViewController(vc, animated: false)
    }
    

}
