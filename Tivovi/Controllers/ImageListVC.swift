//
//  ImageListVC.swift
//  Tivovi
//
//  Created by Padam on 11/12/19.
//  Copyright © 2019 DevelopersGroup. All rights reserved.
//

import UIKit
import Lightbox

class ImageListVC: UIViewController,LightboxControllerPageDelegate,LightboxControllerDismissalDelegate {

    
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
           
       }
       
       
       func lightboxControllerWillDismiss(_ controller: LightboxController){
           self.dismiss(animated: true, completion: nil);
       }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO:- Required Method
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        configureCell(cell: cell, forItemAt: indexPath)
        // TODO:- Required Method
        return cell
    }
    
    func configureCell(cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
    }
    //MARK: UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let images = [
                    LightboxImage(imageURL: URL(string: "https://cdn.arstechnica.net/2011/10/05/iphone4s_sample_apple-4e8c706-intro.jpg")!),
                  ]

                  // Create an instance of LightboxController.
                  let controller = LightboxController(images: images)

                  // Set delegates.
                  controller.pageDelegate = self
                  controller.dismissalDelegate = self

                  // Use dynamic background.
                  controller.dynamicBackground = true

                  // Present your controller.
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    

}
