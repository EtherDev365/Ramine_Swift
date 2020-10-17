//
//  FriendsVCViewController.swift
//  Tivovi
//
//  Created by Raminde on 29/06/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit

class FriendsVCViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var logogArray : NSMutableArray = []
    var friendsArray : NSMutableArray = []
    let user_details = UserModel.sharedInstance
    @IBOutlet weak var View1: UIView!
    @IBOutlet weak var View2: UIView!
    @IBOutlet weak var View3: UIView!
    @IBOutlet weak var prevImage: UIImageView!
    @IBOutlet weak var frTable1: UITableView!
    @IBOutlet weak var frTable2: UITableView!
    @IBOutlet weak var frTable3: UITableView!
    
    @IBOutlet weak var frTabV3: UITableView!
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.frTable1)  {return friendsArray.count}
        if (tableView == self.frTable2)  {return friendsArray.count}
        if (tableView == self.frTabV3)  {return friendsArray.count}
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                //   cell.selectionStyle = .none
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendcell") as! FriendsTableViewCell

        if (tableView == self.frTable1)
        {

        let friendsdetail : NSDictionary = self.friendsArray[indexPath.row] as! NSDictionary;
        let image = friendsdetail.object(forKey: "s_image")
        let fname = friendsdetail.object(forKey: "s_first_name")
        let lname = friendsdetail.object(forKey: "s_last_name")
        let avtaar = "\(image!)"
 //     cell.secimage.sd_setImage(with: URL(string:( NetworkingConstants.baseURL + str1))) { (image, error, type, url) in
              //      }
        cell.firimage.sd_setImage(with: URL(string:(avtaar))) { (image, error, type, url) in
                     }
         cell.t1l1.text = "\(fname!) \(lname!)"
         //cell.firimage.image=UIImage(named: "btn_s1_d")
         //  cell.secimage.sd_setImage(with: URL(string: "https://robohash.org/123.png"), completed: nil)
            print("this  runs1")

        }
        if (tableView == self.frTable2)
        {
            
        let friendsdetail : NSDictionary = self.friendsArray[indexPath.row] as! NSDictionary;
        let image = friendsdetail.object(forKey: "s_image")
        let fname = friendsdetail.object(forKey: "s_first_name")
        let lname = friendsdetail.object(forKey: "s_last_name")
        let avtaar = "\(image!)"
//      cell.secimage.sd_setImage(with: URL(string:( NetworkingConstants.baseURL + str1))) { (image, error, type, url) in
             //      }
        cell.secimage.sd_setImage(with: URL(string:(avtaar))) { (image, error, type, url) in
                    }
         cell.t2l2.text = "\(fname!) \(lname!)"
         //cell.t1avtaar.image=UIImage(named: "btn_s1_d")
         //  cell.secimage.sd_setImage(with: URL(string: "https://robohash.org/123.png"), completed: nil)
            print("this  runs2")

       }
        if (tableView == self.frTable3)
        {
           

        let friendsdetail : NSDictionary = self.friendsArray[indexPath.row] as! NSDictionary;
        let image = friendsdetail.object(forKey: "s_image")
        let fname = friendsdetail.object(forKey: "s_first_name")
        let lname = friendsdetail.object(forKey: "s_last_name")
        let avtaar = "\(image!)"
            print("this  runs3")
//      cell.secimage.sd_setImage(with: URL(string:( NetworkingConstants.baseURL + str1))) { (image, error, type, url) in
             //      }
        cell.thirimage.sd_setImage(with: URL(string:(avtaar))) { (image, error, type, url) in
                    }
         cell.t3l3.text = "\(fname!) \(lname!)"
         //cell.t1avtaar.image=UIImage(named: "btn_s1_d")
         //  cell.secimage.sd_setImage(with: URL(string: "https://robohash.org/123.png"), completed: nil)
       }
        
        return  cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    override func viewWillAppear(_ animated: Bool) {
        //searchLogo()
        searchLogo2()
        
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func searchFriend(_ sender: Any) {
        

       // let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
        
        //let vc = storyboard.instantiateViewController(withIdentifier: "PackageShareVC") as! PackageShareVC
        
        //self.navigationController?.present(vc, animated: true, completion: nil)
        
       // searchLogo()
        //searchLogo2()

    }
    @IBAction func Back(_ sender: Any) {
      self.navigationController?.popViewController(animated: true)
        
    }

        
    func searchLogo() {

        let parameterDict =  [
            "imgS": "zalando",
            ] as [String : Any]

        APIManager.shared().requestWith(NetworkingConstants.baseURL + NetworkingConstants.company.API_searchLogo, method: .post, andParameters: parameterDict) { response in

            if response.status {
               //print("status: \(response)")
                //print("Status:\(response[0])")

                let responseDic = response.object! as [String: Any]
                //print(responseDic)
                //let firstlogo = (responseDic["filesnew"] as AnyObject).object(at: 1)
                //print(firstlogo)

                self.logogArray = NSMutableArray(array: responseDic["filesnew"] as! NSArray)
                self.logogArray = NSMutableArray(array: responseDic["filesnew"] as! NSArray)
                //print(logogArray[0])
                //let detail : NSDictionary = self.logogArray[0] as! NSDictionary;
                //let xxx = detail.object(forKey: "name")
                //let xxx2 = detail.object(forKey: "logo")
               // print(xxx)
                //print(xxx2)

                //self.logogArray.removeAll()
                //self.logogArray = responseDic["files"] as! [String]
                self.frTable1.reloadData()
                self.frTable2.reloadData()
            }else {
                //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: response.errorMessage)
            }
        }

    }
    
  

      func searchLogo2() {
             
              print("notcrashed a")
      //user_details.user_id
              let parameterDict =  ["user_id": "742"] as [String : Any]
              print("notcrashed 0")

              APIManager.shared().requestWith(NetworkingConstants.baseURL + NetworkingConstants.company.API_friends, method: .post, andParameters: parameterDict) { response in

                  if response.status {
                     //print("status: \(response)")
                      //print("Status:\(response[0])")

                      let responseDic = response.object! as [String: Any]
                     print(responseDic)
                      //let firstlogo = (responseDic["filesnew"] as AnyObject).object(at: 1)
                      //print(firstlogo)
                      print("notcrashed 1")

                      self.logogArray = NSMutableArray(array: responseDic["filesnew"] as! NSArray)
                      print("notcrashed 2")

                      //print(logogArray[0])
                     // self.awaitingArray = NSMutableArray(array: responseDic["awaiting"] as! NSArray)
                      print("notcrashed 3")
                   //   self.receivedArray = NSMutableArray(array: responseDic["received"] as! NSArray)
                      print("notcrashed 4")
                      self.friendsArray = NSMutableArray(array: responseDic["friends"] as! NSArray)

           //           print("counts \(self.awaitingArray.count) \(self.receivedArray.count) \(self.friendsArray.count)")
                      //let detail : NSDictionary = self.logogArray[0] as! NSDictionary;
                     // let xxx = detail.object(forKey: "name")
                     // let xxx2 = detail.object(forKey: "logo")
                     // print(xxx)
                      //print(xxx2)
                      print("notcrashed 5")

                      //self.logogArray.removeAll()
                      //self.logogArray = responseDic["files"] as! [String]
                      self.frTable1.reloadData()
                      self.frTable2.reloadData()
                  }else {
                      //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: response.errorMessage)
                  }
                  
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


