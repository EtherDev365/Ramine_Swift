
import UIKit
import SwiftyJSON
import RappleProgressHUD
import JKNotificationPanel
import FacebookShare
import FBSDKShareKit
import SDWebImage

class PackageShareVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UISearchBarDelegate {
    
    var share_by_user:String?
    var user_id:String?
    let pannel = JKNotificationPanel()
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCakes1 = [UserModel]()
    var result_data = [UserModel]()
    var shipmentId:String?
    @IBOutlet weak var tblMain: UITableView!
    //new search bar
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController.searchResultsUpdater = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        tblMain.tableHeaderView = searchController.searchBar
        self.API_ajaxdatauser()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredCakes1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PackageShareCell") as! PackageShareCell
        let model_data = self.filteredCakes1[indexPath.row]
        cell.lblName.text = model_data.first_name
        
        cell.imgUser.sd_setImage(with: URL(string: model_data.image ?? ""), placeholderImage: UIImage(named: "user"))
        cell.imgUser.layer.cornerRadius = cell.imgUser.frame.height/2
        cell.imgUser.clipsToBounds = true
        return cell
    }

    
    @IBAction func clickDismiss(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
            //filteredCakes1 = filteredCakes1
        } else {
            filteredCakes1 = result_data.filter{ ($0.first_name?.lowercased().contains(searchController.searchBar.text!.lowercased()))! }
        }
        
        self.tblMain.reloadData()
    }
    
    
    //
    func API_ajaxdatauser(){
        let user_details = UserModel.sharedInstance
        RappleActivityIndicatorView.startAnimating()
        let parameterDict =  ["":""]
        DashboardManager.getAllCompanyOne(information: parameterDict ) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
           
            if error==nil{
                if(json["status"]==true){
                    for (_, subJson) in json["message"] {
                        let modelList = UserModel.init(json: subJson)
                        self.result_data.append(modelList)
                        self.filteredCakes1.append(modelList)
                        self.tblMain.reloadData()
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchController.searchBar.endEditing(true)
        searchController.isActive = false
        let model_data = self.filteredCakes1[indexPath.row]
        self.share_by_user = model_data.first_name
        self.user_id = model_data.user_id
        self.API_share_userdata(userModel: model_data)
    }
    
    @IBAction func clickFbShare(_ sender: Any) {
        
    }
    
    @IBAction func clickInviteUser(_ sender: Any) {
        
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InviteViewController") as! InviteViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func API_share_userdata(userModel: UserModel){
        RappleActivityIndicatorView.startAnimating()
        let prefs = UserDefaults.standard
        let parameterDict =  [
            "id": self.shipmentId,
            "share_by_user": prefs.object(forKey: "user_name") as? String ?? "",
            "user_id": userModel.user_id ?? "",
            "device_token": userModel.deviceToken,
            "first_name": prefs.object(forKey: "first_name") as? String ?? "",
        ]
        DashboardManager.API_share_userdata(information: parameterDict as! [String : String]) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            
            if error==nil{
                if(json["status"]==true){
                    let refreshAlert = UIAlertController(title: "Shared", message: json["message"].stringValue, preferredStyle: UIAlertController.Style.alert)
                    
                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                       self.dismiss(animated: true, completion: nil)
                    }))
                    
                    refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                        //print("Handle Cancel Logic here")
                    }))
                    
                    self.present(refreshAlert, animated: true, completion: nil)
                }else{
                    
                   self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
}
