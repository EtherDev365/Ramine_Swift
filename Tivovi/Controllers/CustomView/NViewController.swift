//
//  NViewController.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit

class NViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let storyboard = UIStoryboard.init(name: "Auth", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
      //  self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(vc, animated: false)
       
    }
   

}
