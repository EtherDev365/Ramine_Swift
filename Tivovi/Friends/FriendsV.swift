//
//  FriendsV.swift
//  Tivovi
//
//  Created by Raminde on 01/07/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit
import Contacts
var contacts = [ContactStruct]()

//var logogArrayS : NSMutableArray = []


class FriendsV: UIViewController, UITableViewDataSource,UITableViewDelegate , UISearchBarDelegate{
  
    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var Ftable: UITableView!
    let user_details = UserModel.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FtableS = self.Ftable
        // Do any additional setup after loading the view.
        let authorize = CNContactStore.authorizationStatus(for: .contacts)
                   if authorize == .notDetermined{
                       store.requestAccess(for: .contacts){(chk, error) in }
                       
                   }else if authorize == .authorized{
                       getcontacts2()
                       
                   }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getfriends(Ftable)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if(section == 0 && awaitingArrayS.count == 0){return 0}
        if(section == 1 && receivedArrayS.count == 0){return 0}
        if(section == 2 && friendsArrayS.count == 0){return 0}
            return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
      
        return 3
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
           if(section == 0){return awaitingArrayS.count}
           if(section == 1){return receivedArrayS.count}
          print(awaitingArrayS.count)
           print(receivedArrayS.count)
           print(friendsArrayS.count)
        
            if(section == 2){return  friendsArrayS.count}
            

    return 3
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            var celidentifier = "CellType1"
            if (indexPath.section==0){                celidentifier = "CellType1"            }
            if (indexPath.section==1){                celidentifier = "CellType2"            }
            if (indexPath.section==2){                celidentifier = "CellType3"            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: celidentifier, for: indexPath) as! FCell1
             cell.selectionStyle = .none
            if (indexPath.section==0)
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
            else if (indexPath.section==1)
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
                      print("this  runs1")
                    cell.Btn2.tag = indexPath.row
                    cell.Btn2b.tag = indexPath.row

                  }
            else if (indexPath.section==2)
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
                    }
                  let avtaar = "\(image!)"
                   //     cell.secimage.sd_setImage(with: URL(string:( NetworkingConstants.baseURL + str1))) { (image, error, type, url) in
                                //      }
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
        if(section == 0) {cell.HeadTitle.text = "Afventer accept(\(awaitingArrayS.count))"}
        if(section == 1) {cell.HeadTitle.text = "Venneranmodninger(\(receivedArrayS.count))"}
        if(section == 2) {cell.HeadTitle.text = "Venner(\(friendsArrayS.count))"}
               return cell
      }
    
    @IBAction func GoBack(_ sender: Any) {
        pr2 = false
        pr1 = false
        self.navigationController?.popViewController(animated: true)
    
    }
    
    @IBOutlet weak var btnNotification: SSBadgeButton!
    
    @IBAction func ContactsBtn(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "NewBoard", bundle: nil)
              //   let vc = storyboard.instantiateViewController(withIdentifier: "ContactScreen") as! FriendsVCViewController
           let vc = storyboard.instantiateViewController(withIdentifier: "ContactScreen") as! ContactScreen
          self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBOutlet weak var btnSettingOutlet: UIButton!
    @IBAction func onBtnSetting(_ sender: Any) {
       // GLOBAL_IMG = btnSettingOutlet.imageView
        self.navigationController?.delegate = self
        pr1 = true
               GLOBAL_IMG = nil
               pr1 = false
        
        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @IBAction func SearchNow(_ sender: Any) {
        print("DADADADASDADADASDASDA")
        let storyboard = UIStoryboard.init(name: "NewBoard", bundle: nil)
            //   let vc = storyboard.instantiateViewController(withIdentifier: "FriendsVC") as! FriendsVCViewController
         let vc = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! FindFriendVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
//////////// UI Search bar calls ///////////////////////////////
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("Search string \(searchText)")
        if (searchBar.text?.count ?? 0) <= 2 {
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
            searchbar.resignFirstResponder()
            let vc = storyboard!.instantiateViewController(withIdentifier: "SearchVC") as! FindFriendVC
            let transition = CATransition()
            transition.duration = 0.25
            transition.type = CATransitionType.fade
            transition.subtype = CATransitionSubtype.fromTop
            transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
            tabBarController?.view.layer.add(transition, forKey: kCATransition)
            self.navigationController?.pushViewController(vc, animated: false)
            vc.searchstring = searchText
            
        }
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
     
        print("Search button clicked \(searchBar.text)")
        if (searchBar.text?.count ?? 0) <= 2 {
            // searchEnabled = false
            //searchBar.showsCancelButton = false
            //SearchTableViewOutlet.reloadData()
        } else {
            //searchEnabled = true
            searchBar.showsCancelButton = true
            SearchUsersNew(keyword: searchBar.text ?? " ")
            lastsearch = searchBar.text ?? " "
            self.Ftable?.reloadData()
            
            // FilterServicesCall(filterKey: searchBar.text!)
            //updateFilteredContent(forAirlineName: searchBar.text, scope: String(format: "%ld", searchBar.selectedScopeButtonIndex))
        
            let vc = storyboard!.instantiateViewController(withIdentifier: "SearchVC") as! FindFriendVC
            self.navigationController?.pushViewController(vc, animated: true)
            vc.searchstring = searchBar.text ?? " "
            
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


var store = CNContactStore()
   func getcontacts2(){
       let key = [CNContactGivenNameKey as CNKeyDescriptor,CNContactFamilyNameKey as CNKeyDescriptor,CNContactPhoneNumbersKey as CNKeyDescriptor]
       let request = CNContactFetchRequest(keysToFetch: key)
       try! store.enumerateContacts(with: request){(contact,stoppingPointer) in
           let name = contact.givenName
           let familyname = contact.familyName
           let number = contact.phoneNumbers.first?.value.stringValue
           let contactapend = ContactStruct(givenName: name, familyName: familyname, number: number ?? "default value")
           contacts.append(contactapend)
       }
       print(contacts)
       
   }





func pr(){
    print("teste")
}

   //MARK: Custom transition
extension FriendsV : UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        print("return")
       let trans = HDZoomAnimatedTransitioning()
        print("zoom: Detailed")
        if(GLOBAL_IMG == nil){return nil}
        trans.transitOriginalView = GLOBAL_IMG
        trans.isPresentation = pr2;
        return trans;
        
    }
//    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        let transition = HDZoomAnimatedTransitioning()
//        transition.isPresentation = false
//        transition.transitOriginalView = GLOBAL_IMG
//        return transition
//    }
    
    
   
    
    
}

