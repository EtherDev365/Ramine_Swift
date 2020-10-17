//
//  ContactScreen.swift
//  Tivovi
//
//  Created by Raminde on 30/07/20.
//  Copyright © 2020 DevelopersGroup. All rights reserved.
//

import UIKit

class ContactScreen: UIViewController,UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    @IBAction func GoBack(_ sender: Any) {
           pr2 = false
           pr1 = false
           self.navigationController?.popViewController(animated: true)
       
       }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    var cell2 = tableView.dequeueReusableCell(withIdentifier: "ContactViewCell", for: indexPath) as! ContactViewCell
        cell2.Name.text = contacts[indexPath.row].givenName + " " + contacts[indexPath.row].familyName
        cell2.Number.text = contacts[indexPath.row].number
        return cell2
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
