//
//  Friends-Functions.swift
//  Tivovi
//
//  Created by Raminde on 08/07/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import Foundation
import UIKit

var awaitingArrayS : NSMutableArray = []
var receivedArrayS : NSMutableArray = []
var friendsArrayS : NSMutableArray = []
var SharedArrayS: NSMutableArray = []
var FtableS : UITableView? = nil
var SelectedShipmentId: String   = "0"


func getfriends(_ reloadTable: UITableView? = nil) {
        let user_details = UserModel.sharedInstance
        print(user_details.user_id)
         let parameterDict =  ["user_id": user_details.user_id!] as [String : Any]
         print("Getfriends Called")
         APIManager.shared().requestWith(NetworkingConstants.baseURL + NetworkingConstants.company.API_friends, method: .post, andParameters: parameterDict) { response in
             if response.status {
                 let responseDic = response.object! as [String: Any]
                print(responseDic)
                awaitingArrayS = NSMutableArray(array: responseDic["awaiting"] as! NSArray)
                 receivedArrayS = NSMutableArray(array: responseDic["received"] as! NSArray)
                  friendsArrayS = NSMutableArray(array: responseDic["friends"] as! NSArray)
                if(reloadTable == nil){}else{reloadTable!.reloadData()}
               // StableS?.reloadData()
                btnNotificationS!.badge = "\(receivedArrayS.count)"
                btnNotificationS!.badgeBackgroundColor = .red
             }else {
                 //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: response.errorMessage)
             }
         }
 }


func delfriends(id: Int, reloadTable: UITableView) {
        let user_details = UserModel.sharedInstance
print(user_details.user_id)
         let parameterDict =  ["id": id] as [String : Any]
         APIManager.shared().requestWith(NetworkingConstants.baseURL + NetworkingConstants.company.API_deleteFriend, method: .post, andParameters: parameterDict) { response in
            if response.status {
                 let responseDic = response.object! as [String: Any]
                print(responseDic)
                
                FtableS?.reloadData()
                 StableS?.reloadData()
             }else {
                 //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: response.errorMessage)
             }

         }
 }

func AcceptFriend(id: Int) {
        let user_details = UserModel.sharedInstance
         print("notcrashed a")
print(user_details.user_id)
         let parameterDict =  ["id": id] as [String : Any]
         print("Acceptfriends Called")
         APIManager.shared().requestWith(NetworkingConstants.baseURL + NetworkingConstants.company.API_acceptFriend, method: .post, andParameters: parameterDict) { response in
             if response.status {
                 let responseDic = response.object! as [String: Any]
                print(responseDic)
                FtableS?.reloadData()
                StableS?.reloadData()
             }else {
                 //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: response.errorMessage)
             }
           
         }
 }
func API_addFriend(receiver : String) {
    let user_details = UserModel.sharedInstance

print(receiver)
    let rec = "\(receiver)"
    let parameterDict =  ["user_id": user_details.user_id!, "receiver": rec] as [String : Any]
         print("Add Friend Called \(receiver)")
    print("Parameters")
    print(parameterDict)
         APIManager.shared().requestWith(NetworkingConstants.baseURL + NetworkingConstants.company.API_addFriend, method: .post, andParameters: parameterDict) { response in

             if response.status {

                 let responseDic = response.object! as [String: Any]
                print(responseDic)
                //let msg = response.object(forKey: "message")

                //let out = responseDic["message"]
               // print(out)
            
                //getfriends()
               
                SearchUsersNew(keyword: lastsearch, reloadTable: StableS)
                getfriends(FtableS!)
                FtableS?.reloadData()
               
             }else {
                 //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: response.errorMessage)
             }
             
         }
 }


func API_ShareShop(receiver : Int, shop_id: String) {
    let user_details = UserModel.sharedInstance

print(receiver)
    let rec = "\(receiver)"
    let parameterDict =  ["user_id": user_details.user_id!, "receiver_id": rec, "shop_id": shop_id] as [String : Any]
         print("Share A Shop Called \(receiver)")
    print("Parameters")
    print(parameterDict)
         APIManager.shared().requestWith(NetworkingConstants.baseURL + NetworkingConstants.company.API_ShareShop, method: .post, andParameters: parameterDict) { response in

             if response.status {

                 let responseDic = response.object! as [String: Any]
                print(responseDic)
                //let msg = response.object(forKey: "message")

                //let out = responseDic["message"]
               // print(out)
            
                //getfriends()
               
                SearchUsersNew(keyword: lastsearch, reloadTable: StableS)
                
              //  if(FtableS == nil){}else{getfriends(FtableS!)}

               // FtableS?.reloadData()
               
             }else {
                 //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: response.errorMessage)
             }
             
         }
 }




func SearchUsersNew(keyword : String, reloadTable: UITableView? = nil) {
        let user_details = UserModel.sharedInstance

    print(user_details.user_id)
    let parameterDict =  ["search": keyword, "user_id": user_details.user_id!] as [String : Any]
         print("Search user Called:\(keyword)")

         APIManager.shared().requestWith(NetworkingConstants.baseURL + NetworkingConstants.company.API_SearchUsers, method: .post, andParameters: parameterDict) { response in
            print(response)

             if response.status {

                 let responseDic = response.object! as [String: Any]
                print(responseDic)
                

                 SearchResultArrayS = NSMutableArray(array: responseDic["message"] as! NSArray)
                if(reloadTable == nil){}else{reloadTable!.reloadData()}

               // StableS?.reloadData()
             }else {
                 //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: response.errorMessage)
                print(response)
             }
             
         }
 }


