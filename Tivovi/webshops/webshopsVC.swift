//
//  webshopsVC.swift
//  Tivovi
//
//  Created by Raminde on 08/08/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit
var logogArray : [NSDictionary] = []
var searchedArray = logogArray
var favoriteArray : [NSDictionary] = UserDefaultManager().fetchFavorites() as! [NSDictionary]
var WtableS : UITableView? = nil
var searchedTable: UITableView? = nil
var isSearchActive = false


protocol WebShopVCDelegate: class {
    func callVCLifeCycle()
}


class webshopsVC: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,CustomCameraVCDelegate, UIScrollViewDelegate, WebShopVCDelegate {
    func imageUploadedSuccssfully() {
        NotificationMsgShowText = "New Box added Sucessfully"

                pr1 = false
                pr2 = false
                 self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var Wtable: UITableView!
    
    @IBOutlet weak var searchTableView: UITableView!
    let user_details = UserModel.sharedInstance
    var buttonsDelegate: ButtonsDelegate?
    var hideButtomButtonDelegate: HideBottomButtonDelegate?
  
    enum ScrollDirection {
        case up, down
    }
    
    var shouldCalculateScrollDirection = false
    private var lastContentOffset: CGFloat = 0
    private var scrollDirection: ScrollDirection = .up
     @IBAction func GoBack(_ sender: Any) {
         pr1 = false
         pr2 = false
        
       let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.reveal   
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        tabBarController?.view.layer.add(transition, forKey: kCATransition)
        self.navigationController?.popViewController(animated: false)
         
     
     }
    @IBAction func cancelButtonAction(_ sender: UIButton) {
         view.endEditing(true)
        isSearchActive = false
        searchBar.text  = ""
        searchBar.resignFirstResponder()
        cancelButton.isHidden = true
        Wtable.isHidden = false
        searchTableView.isHidden = true
        Wtable.reloadData()
        searchTableView.reloadData()
        
    }
    @IBAction func BtnCenter(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
                           let vc = storyboard.instantiateViewController(withIdentifier: "CustomCameraViewController") as! CustomCameraViewController
                         //  vc.packageId = packageId!
                          // vc.delegate = self
                          // vc.modalPresentationStyle = .overFullScreen
                          // self.present(vc, animated: true, completion: nil)
        
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromTop
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        tabBarController?.view.layer.add(transition, forKey: kCATransition)
                      //self.navigationController?.popToRootViewController(animated: true)
                      self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @IBAction func Dashboard(_ sender: Any) {
        pr1 = false
              pr2 = false
             btntype = "dashboard"
            let transition = CATransition()
             transition.duration = 0.25
             transition.type = CATransitionType.reveal
             transition.subtype = CATransitionSubtype.fromRight
             transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
             tabBarController?.view.layer.add(transition, forKey: kCATransition)
             self.navigationController?.popToRootViewController(animated: false)
    }
    
     @IBOutlet weak var btnNotification: UIView!
     @IBOutlet weak var btnFriends: SSBadgeButton!
     @IBAction func loadFriends(_ sender: Any) {
         GLOBAL_IMG = btnFriends.imageView
         GLOBAL_IMG = nil
          //self.navigationController?.delegate = self
          pr1 = true
          
          btntype = "webshop"
          let storyboard = UIStoryboard.init(name: "NewBoard", bundle: nil)
          
         // let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
          //let vc = storyboard.instantiateViewController(withIdentifier: "PackageShareVC") as! PackageShareVC
         // vc.shipmentId = singlePackageDetail.id
          

           let vc = storyboard.instantiateViewController(withIdentifier: "FriendsVC2") as! FriendsV
          // vc.shipmentId = singlePackageDetail.id
          
          
            
            
          
          //self.navigationController?.present(vc, animated: true, completion: nil)
          self.navigationController?.pushViewController(vc, animated: true)
     }
     

     @IBOutlet weak var btnSettingOutlet: SSBadgeButton!
      @IBOutlet weak var searchBar: UISearchBar!
     @IBAction func onBtnSetting(_ sender: Any) {
          GLOBAL_IMG = btnSettingOutlet.imageView
         //self.navigationController?.delegate = self as! UINavigationControllerDelegate
          pr1 = true
         GLOBAL_IMG = nil
         pr1 = false
         pr2 = false
          let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
          let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
          self.navigationController?.pushViewController(vc, animated: true)
          
      }
    override func viewDidLoad() {
        super.viewDidLoad()
       // searchLogo(keyword: "")
        // Do any additional setup after loading the view.
        searchBar.placeholder = "Søg"
     
       
        
        isSearchActive = false
        cancelButton.isHidden = true
        WtableS = Wtable
        searchedTable = searchTableView
        WtableS?.contentInset = UIEdgeInsets.init(top: -45, left: 0, bottom: 200, right: 0);
               
        searchedTable?.contentInset = UIEdgeInsets.init(top: -45, left: 0, bottom: 200, right: 0);
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        MenuViewG?.isHidden = false
//        LeftLineG?.center.x = btnPlusG!.center.x
//        RightLineG?.center.x =  (btnPlusG?.center.x)!
//        LeftLineG?.alpha = 0
//        RightLineG?.alpha = 0
//        UIView.animate(withDuration: 0.2, delay: 0.1,
//                 options: [.curveEaseInOut], animations: {
//                    LeftLineG?.center.x = (BtnCubeG?.center.x)!
//                    RightLineG?.center.x = (btnPlusG?.center.x)!
//                    LeftLineG?.alpha = 1
//                    RightLineG?.alpha = 0
//                                           }) { (isCompeleted) in
//                                             //  self.Vback.isHidden = false
//                                           }
    }
    override func viewWillAppear(_ animated: Bool) {
        //searchLogo(keyword: "")
        WtableS = Wtable

    }
    func callVCLifeCycle() {
        DispatchQueue.main.async {
            if activeVC != 1 { return }
                       self.viewWillAppear(true)
                       self.viewDidAppear(true)
                       self.cancelButtonAction(UIButton())
        }
             
    }
    
    
  ////////////////////////////////////
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == searchedTable && searchedArray.count == 0 {
            return 0
        } else if section == 0 && favoriteArray.count == 0 {
            return 0
        } else if section == 1 && logogArray.count == 0 {
            return 0
        } else {
         return 40
        }
//         if(section == 0 && logogArray.count == 0){return 0}
//         if(section == 1 && receivedArrayS.count == 0){return 0}
//         if(section == 2 && friendsArrayS.count == 0){return 0}
//             return 50
     }
     func tableView(_ tableView: UITableView,
    viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))

        let label = UILabel()
        label.frame = CGRect.init(x: 0, y: 0, width: headerView.frame.width-10, height: headerView.frame.height)
        label.center.x = headerView.center.x
        var title = ""
        if tableView == searchedTable {
            title = "Søgte"
        } else {
           title = section == 0 ? "favoritter" : "interessant"
        }
        label.text = title
        label.font = UIFont.systemFont(ofSize: 17) // my custom font
        label.textColor = .systemBlue // my custom colour
        label.textAlignment = .center
        headerView.addSubview(label)

        return headerView
    }
     
     func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == searchTableView {
            return 1
        }
         return 2
         
     }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         return 80
     }
         func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableView.isHidden {
                return 0
            }
            if tableView == searchTableView {
                
                return searchedArray.count
            }
            return section == 0 ? favoriteArray.count : logogArray.count
         }
         
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celidentifier = "CellType4"
        let cell = tableView.dequeueReusableCell(withIdentifier: celidentifier, for: indexPath) as! FCell1
        cell.selectionStyle = .none
        cell.buttonsDelegate = self.buttonsDelegate
        cell.Btn6Img.image=UIImage(named: "Add")
        var friendsdetail: NSDictionary!
        if tableView == searchTableView {
            friendsdetail = searchedArray[indexPath.row] 
        } else {
        if indexPath.section == 0 {
            friendsdetail = favoriteArray[indexPath.row] ;
        } else {
             friendsdetail = logogArray[indexPath.row] ;
        }
        }
       
        cell.viewController = self
        let image = friendsdetail.object(forKey: "logo")
        let fname = friendsdetail.object(forKey: "name")
        let lname = friendsdetail.object(forKey: "website")
        let avtaar = "\(NetworkingConstants.baseURL)/\(image!)"
        //     cell.secimage.sd_setImage(with: URL(string:( NetworkingConstants.baseURL + str1))) { (image, error, type, url) in
        //      }
        print(image)
        cell.UserPhoto1.sd_setImage(with: URL(string:(avtaar)),placeholderImage: UIImage.init(named: "7")) { (image, error, type, url) in
        }
        cell.NameLabel1.text = "\(fname!)"
        cell.title = "\(fname!)"
        cell.LastNameLabel1.text = "\(lname!)".trimmingCharacters(in: .whitespacesAndNewlines)
        //cell.firimage.image=UIImage(named: "btn_s1_d")
        //  cell.secimage.sd_setImage(with: URL(string: "https://robohash.org/123.png"), completed: nil)
        print("this  runs1")
        // cell.Btn1.tag = indexPath.row
        if tableView == searchTableView {
           
            if favoriteArray.contains(where: { (dict) -> Bool in
                               let name = dict["name"] as! String
                               let secondName = friendsdetail["name"] as! String
                               return name == secondName
                           }) {
            cell.addToFavoriteButton.setTitle( "- Fjern", for: .normal)
            } else {
                cell.addToFavoriteButton.setTitle( "+ favorit", for: .normal)
            }
        } else {
        let addTitle = indexPath.section==0 ? "- Fjern" :
        "+ favorit"
        cell.addToFavoriteButton.setTitle(addTitle, for: .normal)
        }
        cell.addToFavoriteButton.tag = indexPath.row
        cell.crossButton.tag = indexPath.row
        cell.addToFavoriteButton.accessibilityIdentifier = "\(indexPath.section)"
        cell.crossButton.accessibilityIdentifier = "\(indexPath.section)"
        cell.favoriteButtonAction = { button in
            self.view.endEditing(true)
            let index = button.tag
            let section = Int(button.accessibilityIdentifier!)!
            if tableView == searchedTable {
                let element = searchedArray[index]
            if let elementIndex = favoriteArray.firstIndex(where: { (dict) -> Bool in
                                                      let name = dict["name"] as! String
                                                      let secondName = element["name"] as! String
                                                      return name == secondName
                                                  }) {
                logogArray.append(favoriteArray.remove(at: elementIndex))
    
                } else {
                    favoriteArray.append(searchedArray[index])
                    if let elementIndex = logogArray.firstIndex(where: { (dict) -> Bool in
                                       let name = dict["name"] as! String
                                       let secondName = element["name"] as! String
                                       return name == secondName
                                   }) {
                                       logogArray.remove(at: elementIndex)
                                       
                                   }
                }
                searchedTable?.reloadData()
            } else {
            if section == 0 {
                logogArray.append(favoriteArray.remove(at: index))
                tableView.reloadData()
                
            } else {
                favoriteArray.append(logogArray.remove(at: index))
                tableView.reloadData()
            }
            }
        }
        cell.crossButtonAction = { button in
            self.view.endEditing(true)
            let index = button.tag
             let section = Int(button.accessibilityIdentifier!)!
            
            
            if tableView == searchedTable {
                
                let element = searchedArray[index]
               
                if let elementIndex = logogArray.firstIndex(where: { (dict) -> Bool in
                    let name = dict["name"] as! String
                    let secondName = element["name"] as! String
                    return name == secondName
                }) {
                    logogArray.remove(at: elementIndex)
                    
                    
                } else if let favIndex = favoriteArray.firstIndex(where: { (dict) -> Bool in
                    let name = dict["name"] as! String
                    let secondName = element["name"] as! String
                    return name == secondName
                }) {
                     favoriteArray.remove(at: favIndex)
                   
                    
                }
               searchedArray.remove(at: index)
                tableView.reloadData()
              
            } else {
            if section == 0 {
                favoriteArray.remove(at: index)
                  tableView.reloadData()
            } else {
                logogArray.remove(at: index)
                  tableView.reloadData()
            }
            }
        }
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FCell1
        
        cell.addShopBtn()
    }
    
    
     //////////// UI Search bar calls ///////////////////////////////
    
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         print("Search string \(searchText)")
         if (searchBar.text?.count ?? 0) <= 0 {
             // searchEnabled = false
             //searchBar.showsCancelButton = false
             //SearchTableViewOutlet.reloadData()
         } else {
             //searchEnabled = true
            // searchBar.showsCancelButton = true
             searchLogo(keyword: searchText)
             lastsearch = searchText
             
            self.searchTableView.reloadData()
             
             // FilterServicesCall(filterKey: searchBar.text!)
             //updateFilteredContent(forAirlineName: searchBar.text, scope: String(format: "%ld", searchBar.selectedScopeButtonIndex))
         
          //   let vc = storyboard!.instantiateViewController(withIdentifier: "SearchVC") as! FindFriendVC
             //self.navigationController?.pushViewController(vc, animated: true)
            // vc.searchstring = searchText
             
         }
     }
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        Wtable.isHidden = true
        searchTableView.isHidden = false
        isSearchActive = true
        cancelButton.isHidden = false
        searchedArray = []
        searchedTable?.reloadData()
        return true
    }
    
   

     func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
         print("Search button clicked \(searchBar.text)")
         if (searchBar.text?.count ?? 0) <= 0 {
             // searchEnabled = false
             //searchBar.showsCancelButton = false
             //SearchTableViewOutlet.reloadData()
         } else {
             //searchEnabled = true
            
             searchLogo(keyword: searchBar.text ?? " ")
             lastsearch = searchBar.text ?? " "
             self.Wtable?.reloadData()
             
             // FilterServicesCall(filterKey: searchBar.text!)
             //updateFilteredContent(forAirlineName: searchBar.text, scope: String(format: "%ld", searchBar.selectedScopeButtonIndex))
         
            // let vc = storyboard!.instantiateViewController(withIdentifier: "SearchVC") as! FindFriendVC
           //  self.navigationController?.pushViewController(vc, animated: true)
           //  vc.searchstring = searchBar.text ?? " "
             
         }
         
     }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        hideButtomButtonDelegate?.hideButton(false)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
             hideButtomButtonDelegate?.hideButton(false)
       }
      
    
    
    //scrolling
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
       
          let offset = scrollView.contentOffset.y
                
                // Determine the scolling direction
                if lastContentOffset > offset && shouldCalculateScrollDirection {
                    scrollDirection = .down
                }
                else if lastContentOffset < offset && shouldCalculateScrollDirection {
                    scrollDirection = .up
                }
                hideButtomButtonDelegate?.hideButton(scrollDirection == .up)
          lastContentOffset = offset
          
       }
       
       func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
           

               //            searchButton.backgroundColor = .black
               //            btnSetting.backgroundColor = .black
               
               UIView.animate(withDuration: 0.2, animations: {
                   MenuViewG?.alpha = 0.0
                   
                   //self.headerView.alpha = 0.0
                   
                 //  self.backgradient.alpha = 0.0
                  // self.arrowView.alpha = 0.0

               }) { (isCompeleted) in
                   MenuViewG?.isHidden = true
                   // self.navigationController?.setNavigationBarHidden(true, animated: true)
                   //self.headerView.isHidden = true
                  // self.backgradient.isHidden = true
                   //self.arrowView.isHidden = true

                   //delay reappear
                   DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                          // do stuff 42 seconds later
                      
                       print("This was delayed")
                      // self.headerView.isHidden = false
                      // self.backgradient.isHidden = false
                        if targetContentOffset.pointee.y < 100 {
                      // self.arrowView.isHidden = false
                      //     self.arrowView.alpha = 1

                        }else{
                         //  self.arrowView.isHidden = true
                         //  self.arrowView.alpha = 0.0

                       }

                              UIView.animate(withDuration: 0.5, animations: {
                                  MenuViewG?.alpha = 1.0
                             //  self.backgradient.alpha = 1
                                  // self.navigationController?.setNavigationBarHidden(false, animated: true)
                                //  self.headerView.alpha = 1.0
                               //self.arrowView.alpha = 1.0
                               
                            

                              }) { (isCompeleted) in
                                  MenuViewG?.isHidden = false
                               //self.backgradient.isHidden = false
                             
                              }
                      }
                   
                   
                   
                   
               }
               
               
                    if targetContentOffset.pointee.y > 50 {
                       // self.arrowView.alpha = 0.0
                   //     self.arrowView.isHidden = true
                       print("away")

                    }else{
                       print("inside")

                      //   self.arrowView.alpha = 1
                      //  self.arrowView.isHidden = false
                    }
               
       }
       func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
           guard !decelerate else { return }
           shouldCalculateScrollDirection = false
       }
       
       func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
           shouldCalculateScrollDirection = false
       }
       
       func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
           shouldCalculateScrollDirection = true
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
func searchLogo(keyword: String) {

    let parameterDict =  [
        "imgS": keyword,
        ] as [String : Any]

    APIManager.shared().requestWith(NetworkingConstants.baseURL + NetworkingConstants.company.API_searchLogo, method: .post, andParameters: parameterDict) { response in

        if response.status {
           //print("status: \(response)")
            //print("Status:\(response[0])")

            let responseDic = response.object! as [String: Any]
            print(responseDic)
            //let firstlogo = (responseDic["filesnew"] as AnyObject).object(at: 1)
            //print(firstlogo)
            if isSearchActive {
                searchedArray = NSMutableArray(array: responseDic["filesnew"] as! NSArray) as! [NSDictionary]
                     searchedArray = NSMutableArray(array: responseDic["filesnew"] as! NSArray) as! [NSDictionary]
                 print(searchedArray)
                
                 searchedTable?.reloadData()
                
                
            } else {
            logogArray = NSMutableArray(array: responseDic["filesnew"] as! NSArray) as! [NSDictionary]
                logogArray = NSMutableArray(array: responseDic["filesnew"] as! NSArray) as! [NSDictionary]
            print(searchedArray)
         
            WtableS?.reloadData()
        }
        }else {
            //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: response.errorMessage)
        }
    }

}
