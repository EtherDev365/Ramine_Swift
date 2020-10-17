//
//  PopupVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
 
import SwiftyJSON
import RappleProgressHUD

protocol refreshDataMessageDelegets {
    func getSuccessMessage()
}
class PopupVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate {
    var package_id:String?
    var imageArr = [String]()
    var filteredData: [CompanyModel]!
    @IBOutlet var txtSearch: UITextField!
    
    @IBOutlet var companyLogo: UIImageView!
    
    @IBOutlet var mainCollect: UICollectionView!
    var model_data = [CompanyModel]()
    var delegets:refreshDataMessageDelegets? = nil
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllCompany()
        self.imageArr.append("http://localhost/img/7.jpg")
        filteredData = model_data
        self.txtSearch.delegate = self
        // Do any additional setup after loading the view.
        self.txtSearch.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        let txtS = self.txtSearch.text
        let lowerSearchText = txtS?.lowercased()
        if self.txtSearch.text! == "" {
            filteredData = model_data
        } else {
            filteredData = model_data.filter{ ($0.url?.lowercased().contains(self.txtSearch.text!.lowercased()))! }
        }
        self.mainCollect.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.changePackagelogo(id: package_id!, image: self.filteredData[indexPath.row].user_image!)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.filteredData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopupViewCell",for: indexPath) as! PopupViewCell
        let modelData = self.filteredData[indexPath.row]
        
        if(modelData.user_image != nil && modelData.user_image != "") {
            
            cell.comapnyLogo.setImageWithURL(urlString: modelData.user_image!, placeholderImageName: "")
            cell.comapnyLogo.layer.borderWidth = 1
            cell.comapnyLogo.layer.masksToBounds = false
            cell.comapnyLogo.layer.borderColor = UIColor.clear.cgColor
            cell.comapnyLogo.layer.cornerRadius = cell.comapnyLogo.frame.height/2
            cell.comapnyLogo.clipsToBounds = true
        }
//        else{
//            cell.comapnyLogo.setImageWithURL(urlString: self.imageArr[0]!, placeholderImageName: "")
//            cell.comapnyLogo.layer.borderWidth = 1
//            cell.comapnyLogo.layer.masksToBounds = false
//            cell.comapnyLogo.layer.borderColor = UIColor.clear.cgColor
//            cell.comapnyLogo.layer.cornerRadius = cell.comapnyLogo.frame.height/2
//            cell.comapnyLogo.clipsToBounds = true
//        }
        cell.lblUrl.text = modelData.url
        cell.lblEmail.text = modelData.email
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenRect: CGRect = UIScreen.main.bounds
        let screenWidth: CGFloat = screenRect.size.width
        let cellWidth: Float = Float(Int(screenWidth/3.0))
        //Replace the divisor with the column count requirement. Make sure to have it in float.
        var size = CGSize()
        
        if self.view.frame.size.width == 320
        {
            size = CGSize(width: CGFloat(cellWidth-11), height: CGFloat(cellWidth-11))
        }
        else
        {
            size = CGSize(width: CGFloat(cellWidth-10), height: CGFloat(cellWidth-10))
        }
        
        
        return size
    }
    
    @IBAction func clickDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //function for get all company
    func getAllCompany(){
        let parameterDict =  ["":""]
        DashboardManager.getAllCompany(information: parameterDict) { (json, wsResponse, error) in
           
            if error==nil{
                
                for (_, subJson) in json["message"] {
                    let modelList = CompanyModel.init(json: subJson)
                    self.model_data.append(modelList)
                }
                self.filteredData = self.model_data
                self.mainCollect.reloadData()
            }
        }
    }
    func changePackagelogo(id:String,image:String){
        let userDetail = UserModel.sharedInstance
        let parameterDict =  [
            "id": id ?? "",
            "image": image ?? "",
            "user_id": userDetail.user_id ?? ""
        ]
        DashboardManager.API_updatePackageCompanyLogo(information: parameterDict) { (json, wsResponse, error) in
            
            if error==nil{
                self.delegets?.getSuccessMessage()
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
