//
//  CameraViewController.swift
//  Tivovi
//
//  Created by Gagan Arora on 12/13/19.
//  Copyright © 2019 DevelopersGroup. All rights reserved.
//

import UIKit
import CameraManager
class CameraViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let cameraManager = CameraManager()
        cameraManager.addPreviewLayerToView(self.view)
        // Do any additional setup after loading the view.
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
