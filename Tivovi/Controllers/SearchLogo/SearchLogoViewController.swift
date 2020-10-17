//
//  SearchLogoViewController.swift
//  Tivovi
//
//  Created by Suhas Arvind Patil on 05/10/19.
//  Copyright © 2019 DevelopersGroup. All rights reserved.
//

import UIKit
import JKNotificationPanel
import RappleProgressHUD

class SearchLogoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    public var package : PackageModel?
    var logogArray = [String]()
    let pannel = JKNotificationPanel()
    let user_details = UserModel.sharedInstance

    @IBOutlet weak var packageTitleLabel: UILabel!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var logoResultTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        packageTitleLabel.text = package?.title
        
        searchBar.delegate = self
        logoResultTableView.delegate = self
        logoResultTableView.dataSource =  self
        logoResultTableView.tableFooterView = UIView()
        logoResultTableView.register(UINib.init(nibName: "LogoImageViewCell", bundle: nil), forCellReuseIdentifier: "LogoImageViewCell")
        
        searchBar.accessibilityIdentifier = "DE-ACTIVE"
        
        
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func saveButtonTapped() {
        
        guard self.logoResultTableView.indexPathForSelectedRow != nil else {
            self.navigationController?.popViewController(animated: true)
            return
        }
        
        applyLogo()
    }
    
    //MARK: TableView Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logogArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LogoImageViewCell") as! LogoImageViewCell
        cell.selectionStyle = .default
        
        cell.logoImageView?.setImageWithURL(urlString: NetworkingConstants.baseURL + self.logogArray[indexPath.row], placeholderImage: cell.logoImageView?.getPlaceHolderImage(text: "Loading..."))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "  Search Result"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
    }

   
    //MARK: API CALL FOR SEARCH LOGO
    
    func searchLogo() {

        let parameterDict =  [
            "imgS": self.searchBar.text!.lowercased(),
            ] as [String : Any]

        APIManager.shared().requestWith(NetworkingConstants.baseURL + NetworkingConstants.company.API_searchLogo, method: .post, andParameters: parameterDict) { response in

            if response.status {

                let responseDic = response.object! as [String: Any]
                
                self.logogArray.removeAll()
                self.logogArray = responseDic["files"] as! [String]
                self.logoResultTableView.reloadData()

            }else {
                self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: response.errorMessage)
            }
        }

    }
    
    
    
    //MARK: API CALL FOR APPLY LOGO

    func applyLogo() {
        
        RappleActivityIndicatorView.startAnimating()
        let parameterDict =  [
            "logoUrl": self.logogArray[(logoResultTableView.indexPathForSelectedRow?.row)!],
            "user_id": self.user_details.user_id!,
            "shipmentId": self.package!.shipmentId
            ] as [String : Any]
        
        APIManager.shared().requestWith(NetworkingConstants.baseURL + NetworkingConstants.company.API_applyLogo, method: .post, andParameters: parameterDict) { response in
            
            if response.status {
               
                let responseDic = response.object! as [String: Any]
                self.navigationController?.popViewController(animated: true)

            }else {
                
                self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: response.errorMessage)
            }
        }
    }

}


extension SearchLogoViewController : UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        
        searchBar.accessibilityIdentifier = "ACTIVE"
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard searchText.count > 1 else {
            return
        }
        
        self.perform(#selector(performSearchAPICall), with: nil, afterDelay: 0.2)
    }
    
    @objc func performSearchAPICall() {
        searchLogo()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        searchBar.text = ""
        searchBar.accessibilityIdentifier = "DE-ACTIVE"
    }
    
    func searchBarResultsListButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
