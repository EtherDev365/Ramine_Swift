//
//  SingleShopPackageViewController.swift
//  Tivovi
//
//  Created by Pranav on 22/05/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit
var GLOBAL_IMG3 : UIImageView? = nil

protocol singleShopVCDelegate : AnyObject {
    func returnBackFromSingleShopVC()
}

class SingleShopPackageViewController: UIViewController {
    //var isPush = false
    @IBOutlet weak var collectionview: UICollectionView!
    var dataList = [PackageModel]()
    var singlePackageDetail : PackageModel!
    var filterData = [PackageModel]()
    var delegate: singleShopVCDelegate?
    var context : DetailScreenViewController!
    var setData = ""
    @IBOutlet weak var lbl_selectedShopName: UILabel!
    @IBOutlet weak var img_selectedShopImage: UIImageView!
    
    
    @IBOutlet weak var view_backGroundShopName: UIView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("SingleShopPackageViewController")
        
        self.lbl_selectedShopName.text = singlePackageDetail.title
                   
        if (self.singlePackageDetail.defaultUrl != "/webshop.png")
        {
            self.img_selectedShopImage.sd_setImage(with: URL(string: NetworkingConstants.baseURL + self.singlePackageDetail.defaultUrl!)) { (image, error, type, url) in
            }
        }else
        {
            
            self.img_selectedShopImage.image = self.img_selectedShopImage?.getPlaceHolderImage(text: self.singlePackageDetail.title == "" ? "Shop" : self.singlePackageDetail.title)
            self.view_backGroundShopName.backgroundColor = UIColor(red: 0.30, green: 0.60, blue: 0.16, alpha: 1.00)
            self.img_selectedShopImage.backgroundColor = .clear

        }
        
        
        self.filterData = self.dataList.filter { (model) -> Bool in
        
              if(model.title == singlePackageDetail.title)
              {
                  return true
              }else
              {
                return false
            }
              
          };
        

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onClickBack(_ sender: Any) {
        //isPush = false
        r = 0
        pr2 = false
        GLOBAL_IMG = GLOBAL_IMG3
        //self.navigationController?.delegate = self
        if setData == "SingleShopPackageViewController"{
            pr2 = false
            self.navigationController?.popViewController(animated: true)
            self.delegate?.returnBackFromSingleShopVC()
        }else{
            pr2 = false
            self.navigationController?.popViewController(animated: true)
            self.delegate?.returnBackFromSingleShopVC()
        }
        
        
    }
    
    @IBAction func Click_Logo(_ sender: Any) {
        print("link")
                  let url = singlePackageDetail.shopurl!
                  print(url)
                         guard let urlopen = URL(string: "\(url)") else { return }
                          UIApplication.shared.open(urlopen)
    }
}


extension SingleShopPackageViewController :UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout
{

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.filterData.count
        
       
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
            let cell : DashboardCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "DashboardCollectionViewCell", for: indexPath as IndexPath) as! DashboardCollectionViewCell
            
            let details = self.filterData[indexPath.row]
            
            if (details.imageUrls.count > 0)
            {
                cell.img_images.sd_setImage(with: URL(string: NetworkingConstants.baseURL + details.imageUrls[0]), completed: nil)
            }else
            {
                cell.img_images.image = UIImage(named: "placeholder")
            }
            cell.img_images.contentMode = .scaleAspectFill
            
            //added by raminde
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            formatter.dateFormat = "dd/MM-yyyy"

            let frmdate = formatter.string(from: Date(details.created_at)!)
            cell.lbl_date.text = "\(frmdate)"
            //added by raminde ends
            
            //cell.lbl_date.text = "\(details.created_at)"
            
            cell.lbl_title.text = details.title == "" ? "webshop" : details.title
            
           return cell
        
        
    }


    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat
    {
          return 0;
        
    }

          func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat
          {

               return 0;
              

          }

          func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
          {

               return CGSize(width: (((collectionView.frame.width ) / 3 )  - 5) , height: 250)
            
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let storyboard = UIStoryboard.init(name: "NewBoard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailScreenViewController") as! DetailScreenViewController

        vc.singlePackageDetail = self.filterData[indexPath.row]
        
        vc.packageModel = self.dataList
//        vc.homeSearchDelegate = self
        
        
        //self.navigationController?.delegate = self
        if let cell = collectionView.cellForItem(at: indexPath) as? DashboardCollectionViewCell {
            GLOBAL_IMG = cell.img_images
            pr2 = true
        }
        /*self.navigationController?.present(vc, animated: true, completion: {
            
        })*/
       // isPush = true
        //self.navigationController?.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        //self.navigationController?.popViewController(animated: true)
        //self.delegate?.returnBackFromSingleShopVC()
    }
}


//MARK: Custom transition
extension SingleShopPackageViewController : UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("zoom: single shop")
        let trans = HDZoomAnimatedTransitioning()
        trans.transitOriginalView = GLOBAL_IMG!
              trans.isPresentation = false;
        return trans;
    }
}
