//
//  FCell1.swift
//  Tivovi
//
//  Created by Raminde on 01/07/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit

class FCell1: UITableViewCell {
    var buttonsDelegate: ButtonsDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        if userPhotoContainerView != nil {
            UserPhoto1.applyshadowWithCorner(containerView: userPhotoContainerView, cornerRadious: 30)
            addToFavoriteButton.layer.cornerRadius = 17.5
            addToFavoriteButton.layer.borderWidth = 1
            addToFavoriteButton.layer.borderColor = UIColor.systemBlue.cgColor
            addToFavoriteButton.layer.masksToBounds = true
            
        }
    
    }
    let user_details = UserModel.sharedInstance

    weak var viewController : UIViewController?
    weak var viewController2 : UIViewController?
    var AddLabelView : UILabel?
    var AddMainView : UIView?

    @IBOutlet weak var Btn1: UIButton!
    
    @IBOutlet weak var Btn2: UIButton!
    @IBOutlet weak var Btn2b: UIButton!
    @IBOutlet weak var Btn3: UIButton!
    @IBOutlet weak var Btn4: UIButton!
    @IBOutlet weak var Btn5: UIButton!
    @IBOutlet weak var NameLabel1: UILabel!
    @IBOutlet weak var LastNameLabel1: UILabel!
    @IBOutlet weak var UserPhoto1: UIImageView!
    @IBOutlet weak var FromToLabel: UILabel!
    @IBOutlet weak var userPhotoContainerView: UIView!
    
    
    @IBAction func FCellBtn1(_ sender: Any) {
        
      let storyboard = UIStoryboard.init(name: "NewBoard", bundle: nil)
             
            // let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
             //let vc = storyboard.instantiateViewController(withIdentifier: "PackageShareVC") as! PackageShareVC
            // vc.shipmentId = singlePackageDetail.id
             

        
        print("Awaiting delete button is pressed")
             let tags = (sender as AnyObject).tag
              print("tags=\(tags)")
        let friendsdetail : NSDictionary = awaitingArrayS[tags!] as! NSDictionary;
        print(friendsdetail)

        let id = friendsdetail.object(forKey: "id")
        
        print("id=\(id)")
        delfriends(id:id! as! Int, reloadTable: FtableS!)
        
        getfriends(FtableS!)
        FtableS?.reloadData()
        StableS?.reloadData()
        
        
        
    }

    @IBAction func FcellBtn2(_ sender: Any) {
         print("Received-Rejected delete button is pressed")
                   let tags = (sender as AnyObject).tag
                    print("tags=\(tags)")
              let friendsdetail : NSDictionary = receivedArrayS[tags!] as! NSDictionary;
              print(friendsdetail)

              let id = friendsdetail.object(forKey: "id")
              
              print("id=\(id)")
              delfriends(id:id! as! Int, reloadTable: FtableS!)
              
        getfriends(FtableS!)
              FtableS?.reloadData()
        StableS?.reloadData()
    }
    
    @IBAction func FcellBtn2b(_ sender: Any) {
   
        print("Accept friend button is pressed")
             let tags = (sender as AnyObject).tag
              print("tags=\(tags)")
        let friendsdetail : NSDictionary = receivedArrayS[tags!] as! NSDictionary;
        print(friendsdetail)

        let id = friendsdetail.object(forKey: "id")
        
        print("id=\(id)")
        AcceptFriend(id:id! as! Int)
        
        getfriends(FtableS!)
        FtableS?.reloadData()
        StableS?.reloadData()
    }
 
    @IBAction func FcellBtn3(_ sender: Any) {
              print("Friendship is deleted")
              let tags = (sender as AnyObject).tag
              print("tags=\(tags)")
             let friendsdetail : NSDictionary = friendsArrayS[tags!] as! NSDictionary;
             print(friendsdetail)

             let id = friendsdetail.object(forKey: "id")
             
             print("id=\(id)")
        delfriends(id:id! as! Int, reloadTable: FtableS!)
             
        getfriends(FtableS!)
             FtableS?.reloadData()
            StableS?.reloadData()

    }
    
    @IBOutlet weak var content4: UIView!
    
    @IBOutlet weak var Btn5wrapper: UIView!
    @IBOutlet weak var Btn4Img: UIImageView!
    var state = 0
    @IBAction func Btn4(_ sender: Any) {
        
        AddMainView?.isHidden = false
        let tags = (sender as AnyObject).tag
                            print("tags=\(tags)")
                               let friendsdetail : NSDictionary = SearchResultArrayS[tags!] as! NSDictionary;
                             print(friendsdetail)
                             let id = friendsdetail.object(forKey: "id")
               var first_name = friendsdetail.object(forKey: "first_name")
               first_name = first_name as! String
        
        if(state == 1){
            var replaced = ""
            var replaced2 = ""
            Btn4Img.image=UIImage(named: "Add")
            let lblv = AddLabelView?.text!
            if(AddLabelView?.text == "\(first_name!)"){
               AddLabelView?.text = ""
            }else{
                replaced = lblv?.replacingOccurrences(of: ", \(first_name!)", with: "") ?? ""
                AddLabelView?.text = replaced
            }
            if(multipleaddStr == "\(id!)"){
               multipleaddStr = ""
            }else{
                replaced2 = multipleaddStr.replacingOccurrences(of: ", \(id!)", with: "")
                multipleaddStr = replaced2
            }
 state = 0
            print("multi--",multipleaddStr)
        }else{
            state = 1
        let storyboard = UIStoryboard.init(name: "NewBoard", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SearchVC") as! FindFriendVC
         Btn4Img.image=UIImage(named: "btn_like_pressed")
        print("New friend Added")
                    
        let lblv = AddLabelView?.text!
        if(AddLabelView?.text == ""){
            AddLabelView?.text = first_name as! String
        }else{
        AddLabelView?.text = "\(lblv!), \(first_name!)"
        }
            
        if(multipleaddStr == ""){
            multipleaddStr = "\(id!)"
        }else{
            multipleaddStr = "\(multipleaddStr), \(id!)"
        }
        print("ids-stringout \(multipleaddStr)")

        print("id=\(String(describing: id))")
                  //    API_addFriend(receiver:id! as! Int)
        

                      let indexPath = IndexPath(row: tags!, section: 0)
                      let cell = StableS?.cellForRow(at: indexPath)
       // self.Btn5wrapper.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
      //  self.UserPhoto1.isHidden = true
        //cell.set
        //cell?.removeFromSuperview()
        //cell?.backgroundView?.isHidden=true
        
        //StableS?.deleteRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        StableS?.numberOfRows(inSection: 0)
        //cell?.height(constant: 0)
                     // getfriends()
                     //FtableS?.reloadData()
                     // StableS?.reloadData()
               
        }
    }
    
    typealias ButtonActionType = ((UIButton) -> ())
    var crossButtonAction: ButtonActionType?
    var favoriteButtonAction: ButtonActionType?
    
    @IBOutlet weak var addToFavoriteButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    @IBAction func addToFavoriteButtonAction(_ sender: Any) {
        favoriteButtonAction?(sender as! UIButton)
    }
    @IBAction func crossButtonAction(_ sender: UIButton) {
        crossButtonAction?(sender)
    }
    @IBOutlet weak var Btn5Img: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
    }
    
    @IBAction func FcellBtn5(_ sender: Any) {
        Btn5Img.image=UIImage(named: "btn_like_pressed")

        let alert = UIAlertController(title: "Share", message: "Package Shared Sucessfully", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
               }))
        viewController!.present(alert, animated: true, completion: nil)
        //self.isHidden = true
        let user_details = UserModel.sharedInstance
      //  print("New friend Added")
       // print(SelectedShipmentId)
                            let tags = (sender as AnyObject).tag
                            print("tags=\(tags)")
        //print(friendsArrayS)
                       let friendsdetail : NSDictionary = friendsArrayS[tags!] as! NSDictionary;
                            print(friendsdetail)
                             var id = friendsdetail.object(forKey: "receiver")
        let id2 = id as! Int
        let uid2 = Int(user_details.user_id!)

        print(id2)
        print(uid2)
        
        if(id2 == uid2){
            print("are equal")
            id = friendsdetail.object(forKey: "sender")
            
        }else{
            id = friendsdetail.object(forKey: "receiver")

        }
                            print("id=\(id)")
        API_ShareShop(receiver:id! as! Int, shop_id: SelectedShipmentId)
               

                 
                      
    }
    
    var id = 0
     var Btn6Img: UIImageView! = UIImageView()
    @IBAction func FcellBtn6(_ sender: Any) {
        
        print(id)
        DeleteShared(id: id)
        self.isHidden = true
    }
    var title = ""
    func addShopBtn() {
        self.accessoryType = .checkmark

        API_shipment_action2(title: title)
       // let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
       // let vc = storyboard.instantiateViewController(withIdentifier: "CustomCameraViewController") as! CustomCameraViewController
               
      // viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    func API_shipment_action2(title: String) {
           // let user_details = UserModel.sharedInstance
             print("API_shipment_action2")
    print(user_details.user_id)
        let parameterDict =  ["user_id": user_details.user_id!, "title": title] as [String : Any]
             print("API_shipment_action2 Called")
             APIManager.shared().requestWith(NetworkingConstants.baseURL + NetworkingConstants.account.API_shipment_action2, method: .post, andParameters: parameterDict) { response in
                 if response.status {
                     let responseDic = response.object! as [String: Any]
                    print(responseDic)
                    print(responseDic["id"])
                   // let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
                   // let vc = storyboard.instantiateViewController(withIdentifier: "CustomCameraViewController") as! CustomCameraViewController
                   // vc.packageId = "\(responseDic["id"])"
                    //vc.delegate = self.viewController as! CustomCameraVCDelegate
                    //self.viewController?.navigationController?.pushViewController(vc, animated: true)

                    NotificationMsgShowText = "New Box(\(title)) added Sucessfully"

                                  pr1 = false
                                  pr2 = false
                     shouldRefreshDashboardData = true
                    self.buttonsDelegate?.scroll(to: .right)
                   
//                    self.viewController?.navigationController?.popToRootViewController(animated: true)
                    
                    
                    //FtableS?.reloadData()
                   // StableS?.reloadData()
                 }else {
                     //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: response.errorMessage)
                 }
               
             }
     }
    
    
    func DeleteShared(id: Int) {
            let user_details = UserModel.sharedInstance
             print("Delete Shared")
    print(user_details.user_id)
             let parameterDict =  ["id": id] as [String : Any]
             print("Acceptfriends Called")
             APIManager.shared().requestWith(NetworkingConstants.baseURL + NetworkingConstants.company.API_deleteshared, method: .post, andParameters: parameterDict) { response in
                 if response.status {
                     let responseDic = response.object! as [String: Any]
                    print(responseDic)
                    //FtableS?.reloadData()
                   // StableS?.reloadData()
                 }else {
                     //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: response.errorMessage)
                 }
               
             }
     }
    
    
    
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
           
              
    }

}
