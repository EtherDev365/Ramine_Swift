//
//  ShareScreen.swift
//  Tivovi
//
//  Created by Raminde on 10/07/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit

var SStableS : UITableView? = nil

class ShareScreen: UIViewController, UITableViewDataSource, UITableViewDelegate , UISearchBarDelegate{
    @IBOutlet weak var searchbar: UISearchBar!

    @IBOutlet weak var SStable: UITableView!
    let user_details = UserModel.sharedInstance
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0 && SearchResultArrayS.count == 0){return 0}
        if(section == 1 && friendsArrayS.count == 0){return 0}
        if(section == 2 && receivedArrayS.count == 0){return 0}
        if(section == 3 && awaitingArrayS.count == 0){return 0}

             return 50
     }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       if(indexPath.section == 0){return 90}
        return 110
    }
    
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //return 5
       print("search result count \(SearchResultArrayS.count)")
       print("search result \(SearchResultArrayS)")

           if(section == 0){return SearchResultArrayS.count}
       if(section == 1){return friendsArrayS.count}

           if(section == 2){return receivedArrayS.count}
          print(awaitingArrayS.count)
           print(receivedArrayS.count)
           print(friendsArrayS.count)
            if(section == 3){return  awaitingArrayS.count}
    return 4
        }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var celidentifier = "CellType1"
             if (indexPath.section==0){
                 celidentifier = "CellType4"
             }
             if (indexPath.section==1){
                 celidentifier = "CellType3"
             }
             if (indexPath.section==2){
             celidentifier = "CellType2"
             }
             if (indexPath.section==3){
             celidentifier = "CellType1"
             }
             var cell = tableView.dequeueReusableCell(withIdentifier: celidentifier, for: indexPath) as! FCell1
             cell.selectionStyle = .none
             //var cell2 = tableView.dequeueReusableCell(withIdentifier: "CellType1", for: indexPath) as! FCell2
            // var cell3 = tableView.dequeueReusableCell(withIdentifier: "CellType1", for: indexPath) as! FCell1
        if (indexPath.section==0)
                    {
                      cell.selectionStyle = .none
                     let friendsdetail : NSDictionary = SearchResultArrayS[indexPath.row] as! NSDictionary;
                     let image = friendsdetail.object(forKey: "image")
                     let fname = friendsdetail.object(forKey: "first_name")
                     let lname = friendsdetail.object(forKey: "last_name")
                     let avtaar = "\(image!)"
              //     cell.secimage.sd_setImage(with: URL(string:( NetworkingConstants.baseURL + str1))) { (image, error, type, url) in
                           //      }
                       cell.UserPhoto1.sd_setImage(with: URL(string:(avtaar)),placeholderImage: UIImage.init(named: "7")) { (image, error, type, url) in
                                           }
                      cell.NameLabel1.text = "\(fname!)"
                      cell.LastNameLabel1.text = "\(lname!)".trimmingCharacters(in: .whitespacesAndNewlines)
                      
                      //cell.firimage.image=UIImage(named: "btn_s1_d")
                      //  cell.secimage.sd_setImage(with: URL(string: "https://robohash.org/123.png"), completed: nil)
                         print("this  runs1")
                       cell.Btn4.tag = indexPath.row
                          }
                      else if (indexPath.section==3)
                    {
                
                         cell.selectionStyle = .none
                       let friendsdetail : NSDictionary = awaitingArrayS[indexPath.row] as! NSDictionary;
                       let image = friendsdetail.object(forKey: "s_image")
                       let fname = friendsdetail.object(forKey: "s_first_name")
                       let lname = friendsdetail.object(forKey: "s_last_name")
                       let avtaar = "\(image!)"
                //     cell.secimage.sd_setImage(with: URL(string:( NetworkingConstants.baseURL + str1))) { (image, error, type, url) in
                             //      }
                         cell.UserPhoto1.sd_setImage(with: URL(string:(avtaar)),placeholderImage: UIImage.init(named: "7")) { (image, error, type, url) in
                                             }
                        cell.NameLabel1.text = "\(fname!) \(lname!)"
                        //cell.firimage.image=UIImage(named: "btn_s1_d")
                        //  cell.secimage.sd_setImage(with: URL(string: "https://robohash.org/123.png"), completed: nil)
                           print("this  runs1")
                         cell.Btn1.tag = indexPath.row

                      }
                else if (indexPath.section==2)
                 {
                  let friendsdetail : NSDictionary = receivedArrayS[indexPath.row] as! NSDictionary;
                          let image = friendsdetail.object(forKey: "s_image")
                          let fname = friendsdetail.object(forKey: "s_first_name")
                          let lname = friendsdetail.object(forKey: "s_last_name")
                          let avtaar = "\(image!)"
                   //     cell.secimage.sd_setImage(with: URL(string:( NetworkingConstants.baseURL + str1))) { (image, error, type, url) in
                                //      }
                            cell.UserPhoto1.sd_setImage(with: URL(string:(avtaar)),placeholderImage: UIImage.init(named: "7")) { (image, error, type, url) in
                                                }
                           cell.NameLabel1.text = "\(fname!) \(lname!)"
                           //cell.firimage.image=UIImage(named: "btn_s1_d")
                           //  cell.secimage.sd_setImage(with: URL(string: "https://robohash.org/123.png"), completed: nil)
                              print("this  runs ")
                            cell.Btn2.tag = indexPath.row
                    cell.Btn2b.tag = indexPath.row
                    
                      }
             else if (indexPath.section==1)
                     {
                    cell.selectionStyle = .none
                   let friendsdetail : NSDictionary = friendsArrayS[indexPath.row] as! NSDictionary;
                   var image = friendsdetail.object(forKey: "s_image")
                   var fname = friendsdetail.object(forKey: "s_first_name")
                   var lname = friendsdetail.object(forKey: "s_last_name")
                   var sender = friendsdetail.object(forKey: "sender")
                     print (user_details.user_id)
                             sender = ("\(sender!)")
                             print(sender)
                             print("ddddsadsaa")
                             if(user_details.user_id == sender as! String){
                                 print("TRUE")
                    fname = friendsdetail.object(forKey: "r_first_name")
                    lname = friendsdetail.object(forKey: "r_last_name")
                    image = friendsdetail.object(forKey: "r_image")
                              //  print(fname)
                               // print(lname)
                             }
                   let avtaar = "\(image!)"
                    //     cell.secimage.sd_setImage(with: URL(string:( NetworkingConstants.baseURL + str1))) { (image, error, type, url) in
                                 //      }
                        
                        
                        //cell.UserPhoto1.sd_setImage(with: URL(string:(avtaar))) { (image, error, type, url) in }
                        
                        cell.UserPhoto1.sd_setImage(with: URL(string:(avtaar)),placeholderImage: UIImage.init(named: "7")) { (image, error, type, url) in
                        }
                            cell.NameLabel1.text = "\(fname!) \(lname!)"
                            //cell.firimage.image=UIImage(named: "btn_s1_d")
                            //  cell.secimage.sd_setImage(with: URL(string: "https://robohash.org/123.png"), completed: nil)
                               print("this  runs1")
                             cell.Btn5.tag = indexPath.row
                             //cell.Btn2b.tag = indexPath.row

             }else{
               
             }
        
        cell.viewController = self 
             
             return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getfriends(SStable)
        SStableS = SStable
        // Do any additional setup after loading the view.
    
    }
    
    @IBAction func GoBack(_ sender: Any) {
        pr1 = false
        pr2 = false
        self.navigationController?.popViewController(animated: true)
    
    }
   

    @IBOutlet weak var btnNotification: UIView!
    @IBOutlet weak var btnFriends: SSBadgeButton!
    @IBAction func loadFriends(_ sender: Any) {
        GLOBAL_IMG = btnFriends.imageView
        GLOBAL_IMG = nil
         //self.navigationController?.delegate = self
         pr1 = true
         
         
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
    
 
        //////////////////////////////// SEARCH BAR FUNCTIONS////////////////////////////

        
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search string \(searchText)")
          if (searchBar.text?.count ?? 0) <= 1 {
             // searchEnabled = false
              //searchBar.showsCancelButton = false
              //SearchTableViewOutlet.reloadData()
          } else {
              //searchEnabled = true
              searchBar.showsCancelButton = true
            SearchUsersNew(keyword: searchText, reloadTable: StableS)
            lastsearch = searchText
            self.SStable?.reloadData()

             // FilterServicesCall(filterKey: searchBar.text!)
              //updateFilteredContent(forAirlineName: searchBar.text, scope: String(format: "%ld", searchBar.selectedScopeButtonIndex))
          }
      }

       func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            
        print("Search string \(searchBar.text)")
              if (searchBar.text?.count ?? 0) <= 1 {
                 // searchEnabled = false
                  //searchBar.showsCancelButton = false
                  //SearchTableViewOutlet.reloadData()
              } else {
                  //searchEnabled = true
                  searchBar.showsCancelButton = true
                SearchUsersNew(keyword: searchBar.text ?? " ")
                lastsearch = searchBar.text ?? " "
                self.SStable?.reloadData()
                searchBar.resignFirstResponder()

                 // FilterServicesCall(filterKey: searchBar.text!)
                  //updateFilteredContent(forAirlineName: searchBar.text, scope: String(format: "%ld", searchBar.selectedScopeButtonIndex))
              }
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
