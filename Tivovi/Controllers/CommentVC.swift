//
//  CommentVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import SwiftyJSON
import RappleProgressHUD
import JKNotificationPanel
import IQKeyboardManagerSwift

protocol CommentVCDelegate: AnyObject {
    func returnBackFromCommentVC()
}

class CommentVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let PLACEHOLDER_TEXT = "enter your comment"
    
    var commentModel = [CommentModel]()
    var shipmentId:String?
    let pannel = JKNotificationPanel()
    
    @IBOutlet weak var tblMain: UITableView!
    @IBOutlet weak var btnComment: UIButton!
    @IBOutlet weak var txtComment: UITextView!
    
    var delegate: CommentVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblMain.tableFooterView = UIView()
        self.tblMain.estimatedRowHeight = 60
        self.tblMain.rowHeight = UITableView.automaticDimension
        self.tblMain.backgroundColor = .white
        //self.btnComment.layer.cornerRadius = 15
        self.txtComment.layer.borderWidth = 1
        self.txtComment.layer.borderColor = UIColor.lightGray.cgColor
        self.ShowComments()
        roundedCorner()
    }
    
    func roundedCorner() {
        btnComment.layer.cornerRadius = 8.0
        btnComment.layer.masksToBounds = true
        
        txtComment.layer.cornerRadius = 2.0
        txtComment.layer.masksToBounds = true
        txtComment.text = PLACEHOLDER_TEXT
        txtComment.textColor = .darkGray
    }
    
    @IBAction func clickComment(_ sender: Any) {
        if(self.txtComment.text == ""){
//            self.pannel.show
//            self.pannel.showNotify(withStatus: .warning, inView: self, title: "Error", message: "Please enter comments")
            //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Please enter comments")
        }else{
            self.AddComment()
        }
    }
    
    @IBAction func clickDismiss(_ sender: Any) {
        //self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: false)
        self.delegate?.returnBackFromCommentVC()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentModel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell") as! CommentCell
        let model_data = self.commentModel[indexPath.row]
        
        cell.lblComment.text = model_data.comment
        cell.lblCommentBy.text = model_data.username
        cell.backgroundColor = .white
        cell.contentView.backgroundColor = .white
        return cell
       
    }
    func ShowComments(){
        self.txtComment.text = ""
        self.commentModel.removeAll()
        let user_details = UserModel.sharedInstance
        RappleActivityIndicatorView.startAnimating()
        let parameterDict =  [
            "user_id":  user_details.user_id ?? "",
            "shipmentId": shipmentId ?? "",
            
        ]
        DashboardManager.API_show_comments(information: parameterDict) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            if error==nil{
                if(json["status"]==true){
                    for (_, subJson) in json["data"] {
                        let modelList = CommentModel.init(json: subJson)
                        self.commentModel.append(modelList)
                    }
                    self.tblMain.reloadData()
                } else {
                    //      self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: json["message"].stringValue)
                }
            }
        }
    }
    
    func AddComment(){
        let user_details = UserModel.sharedInstance
        RappleActivityIndicatorView.startAnimating()
        let parameterDict =  [
            "user_id":  user_details.user_id ?? "",
            "shipmentId": self.shipmentId ?? "",
            "comment": self.txtComment.text ?? "",
            ]
        DashboardManager.API_add_comment(information: parameterDict) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            if error==nil{
                if(json["status"]==true){
                    self.ShowComments()
                }else{
                   //self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: json["message"].stringValue)
                    
                    
                }
            }
        }
    }
    
}

extension CommentVC : UITextViewDelegate {
    func textViewShouldBeginEditing(aTextView: UITextView) -> Bool {
        if aTextView == txtComment && aTextView.text == PLACEHOLDER_TEXT {
            txtComment.text = ""
            txtComment.textColor = .black
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newLength = textView.text.utf16.count + text.utf16.count - range.length
        if newLength > 0 {
            if textView == txtComment && textView.text == PLACEHOLDER_TEXT {
                if text.utf16.count == 0 {
                    return false // ignore it
                }
                txtComment.text = ""
            }
            return true
        } else {
            txtComment.text = PLACEHOLDER_TEXT
            txtComment.textColor = .darkGray
            return false
        }
    }
}
