//
//  FindFriendVC.swift
//  Tivovi
//
//  Created by Raminde on 02/07/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit
var SearchResultArrayS : NSMutableArray = []
var StableS : UITableView? = nil
var lastsearch: String = "xxxxxxxxxxxxx"
var multipleaddStr = ""

class FindFriendVC: UIViewController , UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    var searchstring = ""
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var Ftable: UITableView!
    @IBOutlet weak var containerVi: UIView!
    @IBOutlet weak var Vback: UIView!
    @IBOutlet weak var Vfriends: UIView!
    @IBOutlet weak var VSettings: UIView!
    @IBOutlet weak var previmage: UIImageView!
    @IBOutlet weak var scrollviewA: UIScrollView!
    @IBOutlet weak var stackv: UIStackView!
    let user_details = UserModel.sharedInstance

    @IBOutlet weak var AddView: UIView!
    @IBOutlet weak var AddMainView: UIView!
    
    @IBOutlet weak var AddBtnWrapper: UIView!
    @IBOutlet weak var AddLabelView: UILabel!
    @IBOutlet weak var AddMultipleBtn: UIButton!
    
    @IBAction func AddMultipleBtn(_ sender: Any) {
        AddMainView.isHidden = true
        API_addFriend(receiver:multipleaddStr)
        getfriends(FtableS!)
        FtableS?.reloadData()
        multipleaddStr = ""
        AddLabelView.text = ""
        self.navigationController?.popViewController(animated: true)

    }
    
    @IBOutlet weak var btnNotification: SSBadgeButton!
    
    @IBOutlet weak var btnSettingOutlet: UIButton!
    @IBAction func onBtnSetting(_ sender: Any) {
       // GLOBAL_IMG = btnSettingOutlet.imageView
        //self.navigationController?.delegate = self
        pr1 = true
               GLOBAL_IMG = nil
               pr1 = false
        
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
StableS = Ftable
        
        searchbar.becomeFirstResponder()
       // containerVi.frame = CGRectMake(0 , 0, self.view.frame.width, self.view.frame.height * 1)
//containerVi.frame =  CGRect(x:0, y: 0, width:0, height:0)
       // containerVi.frame.size.height = 0

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        getfriends(Ftable)
        searchbar.text = searchstring

    }
    
    /////////////////////////// table view related ////////////////////////////////////////
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section == 0 && SearchResultArrayS.count == 0){return 0}
        if(section == 1 && awaitingArrayS.count == 0){return 0}
        if(section == 2 && receivedArrayS.count == 0){return 0}
        if(section == 3 && friendsArrayS.count == 0){return 0}

             return 50
     }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
       // var arr = SearchResultArrayS[indexPath.row] as! NSDictionary
       // if(indexPath.section == 0){  arr = SearchResultArrayS[indexPath.row]as! NSDictionary}
      //  if(indexPath.section == 1){  arr = awaitingArrayS[indexPath.row]as! NSDictionary}
      //  if(indexPath.section == 2){  arr = receivedArrayS[indexPath.row]as! NSDictionary}
      //  if(indexPath.section == 3){  arr = friendsArrayS[indexPath.row]as! NSDictionary}

        //let friendsdetail : NSDictionary = arr

         //   let id = friendsdetail.object(forKey: "id")
            
         //   print("id=\(id)")
            //delfriends(id:id! as! Int)
            
          //  getfriends()
           // FtableS?.reloadData()
           // StableS?.reloadData()
            
        //guard editingStyle == .delete else { return }
        //tableView.remove(at: indexPath.row)
            //tableView.deleteRows(at: [indexPath], with: .automatic)
        
        //}
    }
     func numberOfSections(in tableView: UITableView) -> Int {
         return 1
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 0){return 90}
         return 110
     }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("search result count \(SearchResultArrayS.count)")
        print("search result \(SearchResultArrayS)")

            if(section == 0){return SearchResultArrayS.count}
        if(section == 1){return awaitingArrayS.count}

            if(section == 2){return receivedArrayS.count}
           print(awaitingArrayS.count)
            print(receivedArrayS.count)
            print(friendsArrayS.count)
             if(section == 3){return  friendsArrayS.count}
     return 4
         }
         
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             var celidentifier = "CellType1"
             if (indexPath.section==0){
                 celidentifier = "CellType4"
             }
             if (indexPath.section==1){
                 celidentifier = "CellType1"
             }
             if (indexPath.section==2){
             celidentifier = "CellType2"
             }
             if (indexPath.section==3){
             celidentifier = "CellType3"
             }
             var cell = tableView.dequeueReusableCell(withIdentifier: celidentifier, for: indexPath) as! FCell1
             cell.selectionStyle = .none
             //var cell2 = tableView.dequeueReusableCell(withIdentifier: "CellType1", for: indexPath) as! FCell2
            // var cell3 = tableView.dequeueReusableCell(withIdentifier: "CellType1", for: indexPath) as! FCell1
        if (indexPath.section==0)
                    {
                        cell.viewController2 = self
                        cell.AddLabelView = AddLabelView
                        cell.AddMainView = AddMainView
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
                        cell.Btn4Img.image=UIImage(named: "Add")
                       cell.Btn4.tag = indexPath.row
                          }
                      else if (indexPath.section==1)
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
             else if (indexPath.section==3)
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
                             cell.Btn3.tag = indexPath.row
                             //cell.Btn2b.tag = indexPath.row

             }else{
               
             }
             
             return cell
         }
    // func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      //  return "TITLE"
     //}
     
     func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let cell = tableView.dequeueReusableCell(withIdentifier: "HeadCell") as! HeadTVC
          // cell.textLabel?.text = mobileBrand[section].BrandName
         if(section == 0) {cell.HeadTitle.text = "Search Result"}
         if(section == 1) {cell.HeadTitle.text = "Afventer accept"}
         if(section == 2) {cell.HeadTitle.text = "Venneranmodninger"}
         if(section == 3) {cell.HeadTitle.text = "Venner"}
                return cell
       }

    
    /////////////////////////////button actions/////////////////////////////////////
    
    @IBAction func GoBack(_ sender: Any) {
            self.navigationController?.popViewController(animated: true)
        
        }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

//////////////////////////////// KEYBOARD FUNCTIONS////////////////////////////
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
   
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        print("scoped changed")
    }
    //////////////////////////////// SCROLLING FUNCTIONS////////////////////////////

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        resignFirstResponder()
        //if targetContentOffset.pointee.y < scrollView.contentOffset.y {
        

            //            searchButton.backgroundColor = .black
            //            btnSetting.backgroundColor = .black
            
            UIView.animate(withDuration: 0.2, animations: {
                self.Vback.alpha = 0.0
                self.Vfriends.alpha = 0.0
                self.VSettings.alpha = 0.0
               // self.headerView.alpha = 0.0
               // self.AddMainView.isHidden = true

            }) { (isCompeleted) in
                self.Vback.isHidden = true
                self.Vfriends.isHidden = true
                self.VSettings.isHidden = true
                //self.AddMainView.isHidden = false

                // self.navigationController?.setNavigationBarHidden(true, animated: true)
                //self.headerView.isHidden = true
                
                //delay reappear
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                       // do stuff 42 seconds later
                   
                    print("This was delayed")
                    self.Vback.isHidden = false
                   self.Vfriends.isHidden = false
                   self.VSettings.isHidden = false
                           UIView.animate(withDuration: 0.5, animations: {
                               self.Vback.alpha = 1.0
                               self.Vfriends.alpha = 10
                               self.VSettings.alpha = 1.0
                            
                            // self.navigationController?.setNavigationBarHidden(false, animated: true)
                               //self.he-aderView.alpha = 1.0
                           }) { (isCompeleted) in
                               self.Vback.isHidden = false
                           }
                   }
                
            }
            
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
        self.Ftable?.reloadData()

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
            self.Ftable?.reloadData()
            searchBar.resignFirstResponder()

             // FilterServicesCall(filterKey: searchBar.text!)
              //updateFilteredContent(forAirlineName: searchBar.text, scope: String(format: "%ld", searchBar.selectedScopeButtonIndex))
          }
    }
    
    }
//////////////////////////////// CLASS ENDS /////////////////////////////////

//////////////////////////////// GLOBAL FUNCTIONS//////////////////////////////////
func SearchUsers(keyword : String){
    let ServicesUrl = NetworkingConstants.baseURL+NetworkingConstants.account.API_ajaxdatauserAPINew
        //print(ServicesUrl)
        // MARK:  Api Calling
    
    ApiCalling(ServicesUrl: ServicesUrl, parameters: ["search":keyword], handler: { (response) in
        
            let result = response.value(forKey: "message") as! NSArray
        
            if result.count == 0 {
                
            }else{
                print(result)
                let first_name = result.value(forKey: "first_name") as! NSArray
                let last_name = result.value(forKey: "last_name") as! NSArray
                let id = result.value(forKey: "id") as! NSArray
                let device_token = result.value(forKey: "device_token") as! NSArray
                let image = result.value(forKey: "image") as! NSArray
                //self.SearchTableViewOutlet.reloadData()
                print("out\(first_name)")
            }
        
            // MARK:  Fetch Account Response Error
        }, errorhandler: { (error) in
            //print("Error:-",error)
            //LoadingView.Hide()
        })
    
}



