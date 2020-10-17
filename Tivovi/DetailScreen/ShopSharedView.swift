//
//  ShopSharedView.swift
//  Tivovi
//
//  Created by Raminde on 17/07/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit

class ShopSharedView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var singlePackageDetail : PackageModel!

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SharedArrayS.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FCell1
        
 var imagestring = "c_image"
 var fname = "c_first_name"
        var lname = "c_last_name"
        var fromto = ""
        if (self.singlePackageDetail.sharedbyuser == "Shared"){
            imagestring = "c_image"
            fname = "c_first_name"
            lname = "c_last_name"
            fromto = "From"
                                                   }
        if (self.singlePackageDetail.sharedbyuser == "Yes"){
            imagestring = "b_image"
            fname = "b_first_name"
            lname = "b_last_name"
            fromto = "Share with"

                                                               }
        
        let sharedshopdetail : NSDictionary = SharedArrayS[indexPath.row] as! NSDictionary;
        
        cell.id = sharedshopdetail.object(forKey: "id") as! Int

        let b_image = sharedshopdetail.object(forKey: imagestring)
        var f_name = sharedshopdetail.object(forKey: fname)
        var l_name = sharedshopdetail.object(forKey: lname)
              print(b_image)
        cell.UserPhoto1.sd_setImage(with: URL(string: b_image! as! String), completed: nil)
        l_name = l_name as! String
        f_name = f_name as! String
        cell.NameLabel1.text = f_name as! String
        cell.LastNameLabel1.text = (l_name as? String ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        //as! String + " " + l_name as! String
        cell.FromToLabel.text = fromto
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 110
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Back(_ sender: Any) {
        pr1 = false
               pr2 = false
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

}
