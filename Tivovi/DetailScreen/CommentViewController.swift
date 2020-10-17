//
//  CommentViewController.swift
//  Tivovi
//
//  Created by Pranav on 13/05/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit

class CommentViewController: UIViewController {

    
    @IBOutlet weak var tblComments: UITableView!

    @IBOutlet weak var txtComments: UITextField!
    @IBOutlet weak var btnSend: UIButton!
    
    var commentModel: [CommentModel] = []
    var commentDateModel: [String] = []
    var datesModel = [String]()
    @IBOutlet weak var imgBack: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    var singlePackageDetail : PackageModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.reloadTableView()
        self.showComments()
        self.title = "Comments"
        imgBack.tintColor = UIColor.red
        
        // Do any additional setup after loading the view.
    }
    @IBAction func onClickBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func action_addComment(_ sender: Any)
    {
        addComments();
    }
    
    func addComments()
    {
            let user_details = UserModel.sharedInstance
//            RappleActivityIndicatorView.startAnimating()
            let parameterDict =  [
                "user_id": user_details.user_id ?? "",
                "shipmentId": singlePackageDetail.id ?? "",
                "comment": txtComments.text ?? ""
                ] as [String : String]
        
            DashboardManager.API_add_comment(information: parameterDict) { (json, wsResponse, error) in
//                RappleActivityIndicatorView.stopAnimation()
                if error==nil{
                    if(json["status"]==true){
                        self.txtComments.text = ""
                        self.showComments()
                    } else {
                        self.showAlertController(title: "", message: json["message"].stringValue)
                    }
                }
            }
    }
    
    func showComments( )
    {
            self.commentModel.removeAll()
            self.commentDateModel.removeAll()

            let user_details = UserModel.sharedInstance

            let parameterDict =  [
                "user_id":  user_details.user_id ?? "",
                "shipmentId": singlePackageDetail.id ?? ""
            ]
            DashboardManager.API_show_comments(information: parameterDict) { (json, wsResponse, error) in

                let successStatus = json["status"]
                if error==nil, successStatus.boolValue == true {
                    for (_, subJson) in json["data"]
                    {
                        let modelList = CommentModel.init(json: subJson)
                        if let createddate = modelList.created_at, !(self.commentDateModel.contains(createddate))
                        {
                            self.commentDateModel.append(createddate)
                        }
                        self.commentModel.append(modelList)
                    }
                    self.tblComments.reloadData()
                    return
                } else {
                    self.showAlertController(title: "", message: json["message"].stringValue)
                    return
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


extension CommentViewController: UITableViewDelegate, UITableViewDataSource {
    
   
    
    func reloadTableView() {
        self.tblComments.dataSource = self
        self.tblComments.delegate = self
        self.tblComments.estimatedRowHeight = 51
        self.tblComments.rowHeight = UITableView.automaticDimension
        

        self.tblComments.reloadData()
        DispatchQueue.main.async {
            if self.tblComments.contentSize.height > (self.tblComments.frame.size.height + 30) {
               self.tblComments.setContentOffset(CGPoint(x: self.tblComments.frame.origin.y, y: self.tblComments.contentSize.height+10), animated: true)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.commentDateModel.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let aryFilter = self.commentModel.filter({ $0.created_at == self.commentDateModel[section] })

        return aryFilter.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let strCreatedDate = self.commentDateModel[section]
        if let headerView = self.tblComments.dequeueReusableCell(withIdentifier: String(describing: DateHeaderTableViewCell.self)) as? DateHeaderTableViewCell {
            headerView.lblCommentDate.text = strCreatedDate
            return headerView.contentView
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aryFilter = self.commentModel.filter({ $0.created_at == self.commentDateModel[indexPath.section] })
        
        let model_data = aryFilter[indexPath.row]
        
        let user_details = UserModel.sharedInstance
        if user_details.user_id == model_data.userid {
            guard let cellReceiver = tableView.dequeueReusableCell(withIdentifier: String(describing: RecieverTableViewCell.self), for: indexPath) as? RecieverTableViewCell else {  return RecieverTableViewCell() }
            cellReceiver.configureReceiverCell(model: model_data, indexPath: indexPath)
            return cellReceiver
        } else {
            guard let cellSender = tableView.dequeueReusableCell(withIdentifier: String(describing: SenderTableViewCell.self), for: indexPath) as? SenderTableViewCell else { return SenderTableViewCell() }
            cellSender.configureSenderCell(model: model_data, indexPath: indexPath)
            return cellSender
        }
    }
}


