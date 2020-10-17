//
//  DashboardVC.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import RappleProgressHUD
import SwiftyJSON
import JKNotificationPanel
import BubbleTransition
//import JTMaterialTransition
public enum TypeOfAccordianView {
    case Classic
    case Formal
}

class DashboardVC: UIViewController,UIViewControllerTransitioningDelegate,refreshData,UIGestureRecognizerDelegate {
   
    func refresNewData() {
        self.API_getPackageByUserId()
    }

    let transition = BubbleTransition()
    let interactiveTransition = BubbleInteractiveTransition()
    
    @IBOutlet weak var presentControllerButton: UIButton!
    let pannel = JKNotificationPanel()
    var packageModel = [PackageModel]()
    @IBOutlet weak var HeaderView: UIView!
    //var transition: JTMaterialTransition?
    @IBOutlet var txtShipment: UITextField!
    let user_details = UserModel.sharedInstance
    @IBOutlet weak var acView: UIView!
    var typeOfAccordianView = TypeOfAccordianView.Formal
    @IBOutlet weak var btnSearch: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadXib(SView: self.HeaderView, value: self.navigationController!)
         let headerCell = Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)?.first as! HeaderView
        headerCell.translatesAutoresizingMaskIntoConstraints = false
        
        // Set the leading and trailing constraints for horizontal placement
        // headerCell.addConstraint(NSLayoutConstraint(item: headerCell, attribute: .trailing, relatedBy: .equal, toItem: self.HeaderView, attribute: .trailing, multiplier: 1, constant: 0))
        
        //  self.HeaderView.addSubview(headerCell)
       
        self.btnSearch.layer.cornerRadius = 5
        self.tabBarController?.tabBar.selectionIndicatorImage = UIImage().createSelectionIndicator(color: UIColor.black, size: CGSize(width: (self.tabBarController?.tabBar.frame.width)!/CGFloat((self.tabBarController?.tabBar.items!.count)!), height: (self.tabBarController?.tabBar.frame.height)!), lineHeight: 2.0)
        self.API_getPackageByUserId()

        self.navigationController?.navigationBar.isHidden = true

        // self.loadXib(SView: self.HeaderView, value: self.navigationController!)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
     //self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //function for get all package by user id
    func API_getPackageByUserId(){
        self.packageModel.removeAll()
     //   RappleActivityIndicatorView.startAnimating()
        let parameterDict =  ["user_id":  self.user_details.user_id ?? ""]
        DashboardManager.API_getPackageByUserId(information: parameterDict) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            if error==nil{
                for (_, subJson) in json["message"] {
                    let modelList = PackageModel.init(json: subJson)
                    self.packageModel.append(modelList)
                }

                let accordionView = MKAccordionView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height - 54))
                
                accordionView.delegate = self;
                accordionView.dataSource = self;
                accordionView.isCollapsedAllWhenOneIsOpen = true
                
                self.acView.addSubview(accordionView);
            }
        }
    }
    
    func API_shipment_action(){
           RappleActivityIndicatorView.startAnimating()
        let parameterDict =  [
                "user_id":  self.user_details.user_id ?? "",
                "shipmentId": self.txtShipment.text ?? "",
                "status": "0"
            ]
        DashboardManager.API_shipment_action(information: parameterDict) { (json, wsResponse, error) in
            RappleActivityIndicatorView.stopAnimation()
            if error==nil{
                if(json["status"]==true){
                    let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "CustomTabBarController") as! CustomTabBarController
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: json["message"].stringValue)
                    
                }
            }
        }
    }
    
    @IBAction func clickAddPackage(_ sender: Any) {
        if(self.txtShipment.text != ""){
            self.API_shipment_action()
        }else{
            self.pannel.showNotify(withStatus: .failed, belowNavigation: self.navigationController!,title: "Please enter shipment id")
        }
    }
    @objc func abc(){
            //print("hello")
    }
    @IBAction func clickAddNewPackage(_ sender: Any) {
        
//        let storyboard = UIStoryboard.init(name: "Dashboard", bundle: nil)
//        let vc = storyboard.instantiateViewController(withIdentifier: "AddNewPackageVC") as! AddNewPackageVC
//
//        //let controller = AddNewPackageVC()
//
//        vc.modalPresentationStyle = .custom
//        vc.transitioningDelegate = self.transition
//
//        self.present(vc, animated: true, completion: nil)
//
        
       // self.navigationController?.present(vc, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let controller = segue.destination as? AddNewPackageVC {
            controller.transitioningDelegate = self
            controller.delegate = self
            controller.modalPresentationStyle = .custom
//            controller.interactiveTransition = interactiveTransition
            interactiveTransition.attach(to: controller)
        }
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = presentControllerButton.center
        transition.bubbleColor = presentControllerButton.backgroundColor!
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = presentControllerButton.center
        transition.bubbleColor = presentControllerButton.backgroundColor!
        return transition
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveTransition
    }
}
// MARK: - Implemention of MKAccordionViewDelegate method
extension DashboardVC : MKAccordionViewDelegate {
    
    func accordionView(_ accordionView: MKAccordionView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch typeOfAccordianView {
        case .Classic :
            return 50
        case .Formal :
            return 200
        }
    }
    
    func accordionView(_ accordionView: MKAccordionView, heightForHeaderIn section: Int) -> CGFloat {
        switch typeOfAccordianView {
        case .Classic :
            return 50
        case .Formal :
            return 80
        }
    }
    
    func accordionView(_ accordionView: MKAccordionView, heightForFooterIn section: Int) -> CGFloat {
        switch typeOfAccordianView {
        case .Classic :
            return 0
        case .Formal :
            return 1
        }
    }
    
    func accordionView(_ accordionView: MKAccordionView, viewForHeaderIn section: Int, isSectionOpen sectionOpen: Bool) -> UIView? {
        
        return getHeaderViewForAccordianType(typeOfAccordianView, accordionView: accordionView, section: section,  isSectionOpen: sectionOpen);
        
    }
    
    func accordionView(_ accordionView: MKAccordionView, viewForFooterIn section: Int, isSectionOpen sectionOpen: Bool) -> UIView? {
        
        switch typeOfAccordianView {
        case .Classic :
            
            let view  = UIView(frame: CGRect(x: 0, y:0, width: accordionView.bounds.width, height: 0))
            view.backgroundColor = UIColor.clear
            return view
            
        case .Formal :
            let view : UIView! = UIView(frame: CGRect(x: 0, y:0, width: accordionView.bounds.width, height:12))
            view.backgroundColor = UIColor.white
            return view
        }
        
    }
    
    func getHeaderViewForAccordianType(_ type : TypeOfAccordianView, accordionView: MKAccordionView, section: Int, isSectionOpen sectionOpen: Bool) -> UIView {
        switch type {
        case .Classic :
            let view : UIView! = UIView(frame: CGRect(x: 0, y:0, width: accordionView.bounds.width, height: 50))
            
            // Background Image
            let bgImageView : UIImageView = UIImageView(frame: view.bounds)
            bgImageView.image = UIImage(named: ( sectionOpen ? "grayBarSelected" : "grayBar"))!
            view.addSubview(bgImageView)
            
            // Arrow Image
            let arrowImageView : UIImageView = UIImageView(frame: CGRect(x: 15, y:15, width:20, height:20))
            arrowImageView.image = UIImage(named: ( sectionOpen ? "close" : "open"))!
            view.addSubview(arrowImageView)
            
            
            // Title Label
            let titleLabel : UILabel = UILabel(frame: CGRect(x:50, y:0, width: view.bounds.width - 120, height: view.bounds.height ))
            titleLabel.text = "Process no: \(section)"
            titleLabel.textColor = UIColor.white
            view.addSubview(titleLabel)
            
            return view
            
        case .Formal :
            
            let view : UIView! = UIView(frame: CGRect(x:0, y:0, width: accordionView.bounds.width , height: 60))
//            view.backgroundColor = UIColor(red: 220.0/255.0, green: 221.0/255.0, blue: 223.0/255.0, alpha: 1.0)
            
            view.backgroundColor = UIColor.white
            var imgString = "next"
            if(sectionOpen == true){
                imgString = "down"
            }
            
            if(self.packageModel[section].image != nil && self.packageModel[section].image != ""){
                self.loadSection(SView: view, value: self.navigationController!, lblnumber: self.packageModel[section].shipmentId, status: self.packageModel[section].status!,imgArr: imgString,logoImg: self.packageModel[section].image!,tagId: Int(self.packageModel[section].id!)!)
            }else{
                self.loadSection(SView: view, value: self.navigationController!, lblnumber: self.packageModel[section].shipmentId, status: self.packageModel[section].status!,imgArr: imgString,logoImg: "",tagId: Int(self.packageModel[section].id!)!)
            }
           
           
            
            return view
        }
    }
    func accordionView(_ accordionView: MKAccordionView, didDeselectRowAt indexPath: IndexPath) {
        //print(indexPath)
    }
    
}

// MARK: - Implemention of MKAccordionViewDatasource method
extension DashboardVC : MKAccordionViewDatasource {
    
    func numberOfSectionsInAccordionView(_ accordionView: MKAccordionView) -> Int {
        return self.packageModel.count //TODO: count of section array
    }
    
    func accordionView(_ accordionView: MKAccordionView, numberOfRowsIn section: Int) -> Int {
        return 1
    }
    
    func accordionView(_ accordionView: MKAccordionView , cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return getCellForAccordionType(typeOfAccordianView, accordionView: accordionView, cellForRowAt: indexPath)
    }
  
    func accordionView(_ accordionView: MKAccordionView, didSelectRowAt indexPath: IndexPath) {
        
        //print("accordionView(_ accordionView: MKAccordionView, didSelectRowAtIndexPath")
        
    }

    func getCellForAccordionType(_ accordionType: TypeOfAccordianView, accordionView: MKAccordionView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch accordionType {
            
        case .Classic :
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            //cell?.imageView = UIImageView(image: UIImage(named: "lightGrayBarWithBluestripe"))
            
            // Background view
            let bgView : UIView? = UIView(frame: CGRect(x:0, y:0, width: accordionView.bounds.width, height: 50))
            let bgImageView : UIImageView! = UIImageView(image: UIImage(named: "lightGrayBarWithBluestripe"))
            bgImageView.frame = (bgView?.bounds)!
            bgImageView.contentMode = .scaleToFill
            bgView?.addSubview(bgImageView)
            cell.backgroundView = bgView
            
            // You can assign cell.selectedBackgroundView also for selected mode
            
            cell.textLabel?.text = "subProcess no: \(indexPath.row)"
            return cell
            
        case .Formal :
           
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
            let subV = CellView()
            let newView = subV.fillCellVal(frame: self.view.frame, value: self.navigationController!, lblCat: self.packageModel[indexPath.section].title, lblTitle: self.packageModel[indexPath.section].description!, lblStatus: self.packageModel[indexPath.section].status!, lblPlace: "", lblShares: "", lblComments: "", lblLastUpdate: "",lblNumber: self.packageModel[indexPath.section].shipmentId,m_id: self.packageModel[indexPath.section].id!,comment_count: self.packageModel[indexPath.section].commentCount)
          
            let rect = CGRect(origin: .zero, size: CGSize(width: self.view.frame.width-50, height: 10))
            newView.frame =  rect

            cell.addSubview(newView)

            return cell
        }
        
    }
}
