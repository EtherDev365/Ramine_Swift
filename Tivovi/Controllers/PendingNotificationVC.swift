//
//  PendingNotificationVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import SwiftyJSON
import RappleProgressHUD
import JKNotificationPanel
class PendingNotificationVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
       
    let user_details = UserModel.sharedInstance
    
    @IBOutlet var tblMain: UITableView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.API_getPendingNotificationByUserId()

    }
    
    
    @objc func clickRejectBtn(_ sender:UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblMain)
        let indexPath = self.tblMain.indexPathForRow(at:buttonPosition)
        self.API_RejectPackage(id: pendingNotifications[(indexPath?.row)!].id!)
       
    }
    
    @objc func clickAcceptBtn(_ sender:UIButton) {
        
        let buttonPosition = sender.convert(CGPoint.zero, to: self.tblMain)
        let indexPath = self.tblMain.indexPathForRow(at:buttonPosition)
        self.API_AcceptPackage(id: pendingNotifications[(indexPath?.row)!].id!)
    }
    
    @IBAction func clickDismiss(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func API_RejectPackage(id:String) {
        
        RappleActivityIndicatorView.startAnimating()
        let parameterDict =  ["id":  id ]
        DashboardManager.API_RejectPackage(information: parameterDict ) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            self.API_getPendingNotificationByUserId()
        }
    }
    
    func API_AcceptPackage(id:String) {
        
        RappleActivityIndicatorView.startAnimating()
        let parameterDict =  ["id":  id ]
        DashboardManager.API_AcceptPackage(information: parameterDict ) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            self.API_getPendingNotificationByUserId()
        }
    }
    
    func API_getPendingNotificationByUserId() {
        
        pendingNotifications.removeAll()
        RappleActivityIndicatorView.startAnimating()
        let parameterDict =  ["user_id":  self.user_details.user_id ?? ""]
        
        DashboardManager.API_getPendingNotificationByUserId(information: parameterDict ) { (json, wsResponse, error) in
            
            RappleActivityIndicatorView.stopAnimation()
            
            if error == nil {
                
                for (_, subJson) in json["message"] {
                    let modelList = PackageModel.init(json: subJson)
                    pendingNotifications.append(modelList)
                }
                self.tblMain.reloadData()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PendingNotificationCell") as! PendingNotificationCell
        cell.lblShipment.text = pendingNotifications[indexPath.row].shipmentId+" share by "+pendingNotifications[indexPath.row].share_by_user
        cell.btnReject.addTarget(self, action: #selector(clickRejectBtn), for: .touchUpInside)
        cell.btnAccept.addTarget(self, action: #selector(clickAcceptBtn), for: .touchUpInside)
        return cell
    }
}
