//
//  ShareVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import SwiftyJSON
import RappleProgressHUD
import JKNotificationPanel
import FacebookShare
import FBSDKShareKit
import Flurry_iOS_SDK

protocol updateRequirement {
    func updateR()
}

class ShareVC: UIViewController,UISearchBarDelegate {
    var device_token = ""
    var share_by_user:String?
    var user_id = 0
    var delegate:updateRequirement? = nil
    let pannel = JKNotificationPanel()
    let user_details = UserModel.sharedInstance

    @IBOutlet weak var SearchTableViewOutlet: UITableView!
   
    var BankArray = NSArray()
    var SelectedBank = NSMutableArray()
    
    var SearchResultArray = NSArray()
    var SearchResultArrayD = NSArray()
    var SearchResultArrayI = NSArray()
    var SearchResultArrayLast = NSArray()
    var PropertyArrayCount = NSArray()
    var HotelCode = NSArray()
    var searchEnabled:Bool = true
    var nav:UINavigationController?
    let searchBar:UISearchBar = UISearchBar()
    var SearchButtonOutlet = UIBarButtonItem()
    let searchController = UISearchController(searchResultsController: nil)
    var shipmentId:String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nav?.navigationBar.isHidden = false
       // let height: CGFloat = 50 //whatever height you want to add to the existing height
        //let bounds = self.navigationController!.navigationBar.bounds
       // self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)

        searchBar.placeholder = "Search Your Destination."
        searchBar.tintColor = UIColor.blue
        searchBar.returnKeyType = .search
        searchBar.showsCancelButton = false
        searchBar.becomeFirstResponder()
        nav?.navigationItem.titleView = searchBar
        SearchTableViewOutlet.tableHeaderView = searchController.searchBar
        searchBar.delegate = self
        searchController.searchBar.delegate = self
      // SearchTableViewOutlet.tableHeaderView = searchBar
        
        
    }
    
    func updateFilteredContent(forAirlineName airlineName: String?, scope: String?) {
        if airlineName == nil { SearchResultArray = BankArray } else {
            if (scope == "0") {
                let pred = NSPredicate(format: "SELF contains[cd] %@", airlineName!)
                let search = BankArray.filtered(using: pred)
                SearchResultArray = search as NSArray
                SearchTableViewOutlet.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        updateFilteredContent(forAirlineName: searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
        //print("selectedScope: \(selectedScope)")
        //print(searchBar.scopeButtonTitles![selectedScope])
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count ?? 0) <= 2 {
            searchEnabled = false
            //searchBar.showsCancelButton = false
            SearchTableViewOutlet.reloadData()
        } else {
            searchEnabled = true
            searchBar.showsCancelButton = true
            FilterServicesCall(filterKey: searchBar.text!)
            updateFilteredContent(forAirlineName: searchBar.text, scope: String(format: "%ld", searchBar.selectedScopeButtonIndex))
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchEnabled = false
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        SearchTableViewOutlet.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if (searchBar.text?.count ?? 0) <= 2 {
            searchBar.resignFirstResponder()
        } else {
            searchBar.resignFirstResponder()
            searchBar.showsCancelButton = false
            searchEnabled = true
            FilterServicesCall(filterKey: searchBar.text!)
            updateFilteredContent(forAirlineName: searchBar.text, scope: String(format: "%ld", searchBar.selectedScopeButtonIndex))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  navigationController?.setNavigationBarHidden(false, animated: animated)
        let rightButtonItem = UIBarButtonItem.init(
            title: "X",
            style: .done,
            target: self,
            action: #selector(rightButtonAction(sender:))
        )
        
        self.navigationItem.rightBarButtonItem = rightButtonItem
        self.navigationController?.navigationBar.barTintColor = UIColor(red:0.22, green:0.65, blue:0.73, alpha:1.0)
        self.navigationController?.navigationBar.tintColor = UIColor.white
        //  self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"<", style:.done, target:self, action:#selector(rightButtonAction(sender:)))
        //self.navigationItem.backBarButtonItem = rightButtonItem
        
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func rightButtonAction(sender: UIBarButtonItem){
        if (self.delegate != nil){
            self.delegate?.updateR()
        }
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func FilterServicesCall(filterKey: String){
        
        //MARK:  NetWork Checked
        let originalString = filterKey
//        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        
        
            //let ServicesUrl = "http://test.zeektrip.com/index.php/home/destinationAutocomplete?json=true&input="+escapedString!+")"
            let ServicesUrl = NetworkingConstants.baseURL+NetworkingConstants.account.API_ajaxdatauserAPINew
            //print(ServicesUrl)
            // MARK:  Api Calling
        
        ApiCalling(ServicesUrl: ServicesUrl, parameters: ["search":originalString], handler: { (response) in
            
                let result = response.value(forKey: "message") as! NSArray
            
                if result.count == 0 {
                    
                }else{
                    print(result)
                    self.SearchResultArray = result.value(forKey: "first_name") as! NSArray
                    self.PropertyArrayCount = result.value(forKey: "last_name") as! NSArray
                    self.HotelCode = result.value(forKey: "id") as! NSArray
                    self.SearchResultArrayD = result.value(forKey: "device_token") as! NSArray
                    self.SearchResultArrayI = result.value(forKey: "image") as! NSArray
                    self.SearchTableViewOutlet.reloadData()
                    
                }
            
                // MARK:  Fetch Account Response Error
            }, errorhandler: { (error) in
                //print("Error:-",error)
                //LoadingView.Hide()
            })
        
       
    }
    @IBAction func clickDismiss(_ sender: Any) {
        if (self.delegate != nil){
            self.delegate?.updateR()
        }
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func clickFbShare(_ sender: Any) {
        
//        let content:FBSDKShareLinkContent =  FBSDKShareLinkContent()
//        content.contentURL = NSURL(string: "https://developers.facebook.com") as! URL
    }
    
    @IBAction func clickInviteUser(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InviteViewController") as! InviteViewController
        self.present(vc, animated: false) {
            
        }
    }
   
}
extension ShareVC : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchEnabled{
            return SearchResultArray.count
        }else{
            return BankArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageShareCell", for: indexPath) as! PackageShareCell
        cell.selectionStyle = .none
        if searchEnabled {
            let f_n = SearchResultArray[indexPath.row] as? String
            let l_n = PropertyArrayCount[indexPath.row] as? String
            cell.lblName.text = (f_n ?? "")+" "+(l_n ?? "") ?? ""
            
            if(SearchResultArrayI[indexPath.row] != nil && ((SearchResultArrayI[indexPath.row] as? String) != nil)) {
                
//                cell.imgUser.layer.borderWidth = 1
//                cell.imgUser.layer.masksToBounds = false
//                cell.imgUser.layer.borderColor = UIColor.clear.cgColor
//                cell.imgUser.layer.cornerRadius = cell.imgUser.frame.height/2
//                cell.imgUser.clipsToBounds = true
                
                var myLogoImage = SearchResultArrayI[indexPath.row]
                cell.imgUser.setImageWithURL(urlString: myLogoImage as! String, placeholderImageName: "")
                cell.imgUser.roundImage()
            }
           
        }else{
            cell.lblName.text = BankArray[indexPath.row] as? String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // let model_data = filteredCakes1[indexPath.row]
        self.share_by_user = SearchResultArray[indexPath.row] as? String
        self.user_id = HotelCode[indexPath.row] as! Int
        self.device_token = SearchResultArrayD[indexPath.row] as? String ?? ""
        self.API_share_userdata()
        
        Flurry.logEvent("Share_Package");

    }
    
    // MARK: API CALLS
    
    func API_share_userdata() {
        
        let user_details = UserModel.sharedInstance
        RappleActivityIndicatorView.startAnimating()
        let prefs = UserDefaults.standard
        let parameterDict =  [
            "id": self.shipmentId!,
            "share_by_user": user_details.user_name!, //self.share_by_user!,
            "user_id": String(self.user_id),
            "device_token": device_token,
            "first_name": prefs.object(forKey: "first_name") as! String? ?? "",
            ] as [String : Any]
        
        DashboardManager.API_share_userdata(information: parameterDict as! [String : String]) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            
            if error == nil {
                
                if (json["status"] == true) {
                    
                    let refreshAlert = UIAlertController(title: "Shared", message: json["message"].stringValue, preferredStyle: UIAlertController.Style.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                        if (self.delegate != nil){
                            self.delegate?.updateR()
                        }
                        self.dismiss(animated: true, completion: nil)
                    }))
                    
                    refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                        //print("Handle Cancel Logic here")
                    }))
                    
                    self.present(refreshAlert, animated: true, completion: nil)
                }else{
                    if (self.delegate != nil){
                        self.delegate?.updateR()
                    }
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}

extension UIImageView {
    
    func roundImage(){
        
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = UIColor.white.cgColor
       // self.contentMode = .scaleToFill
    }
}


extension UIButton {
    
    func roundButton(){
        
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = UIColor.white.cgColor
    }
}
