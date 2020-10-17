//
//  UserModel.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import SwiftyJSON
class UserModel: NSObject {
    
    var user_id:String?
    var user_name:String?
    var first_name:String?
    var image:String?
    var deviceToken:String?
    static let sharedInstance = UserModel()
    
    override init(){
        
    }
    init(json: JSON) {
        self.user_id = json["id"].stringValue
        self.user_name = json["user_name"].stringValue
        self.first_name = json["first_name"].stringValue
        self.image = json["image"].stringValue
        self.deviceToken = json["device_token"].stringValue
    }
    func setUserInformation(json :JSON) {
        let prefs = UserDefaults.standard
        
        user_id = json["data"]["user_id"].stringValue
        prefs.set(user_id, forKey: "user_id")
        
        user_name = json["data"]["user_name"].stringValue
        prefs.set(user_name, forKey: "user_name")
        
        first_name = json["data"]["first_name"].stringValue
        prefs.set(first_name, forKey: "first_name")
        
        image = json["data"]["image"].stringValue
        prefs.set(image, forKey: "image")
        
        prefs.set("1", forKey: "loginKey")
        //prefs.removeObject(forKey: "loginKey")
        prefs.synchronize()
        
    }
    
    func setUserInformationNew(json :JSON) {
        let prefs = UserDefaults.standard
        
        user_id = json["data"]["id"].stringValue
        prefs.set(user_id, forKey: "user_id")
        
        user_name = json["data"]["user_name"].stringValue
        prefs.set(user_name, forKey: "user_name")
        
        first_name = json["data"]["first_name"].stringValue
        prefs.set(first_name, forKey: "first_name")
        
        image = json["data"]["image"].stringValue
        prefs.set(image, forKey: "image")
        
        
        prefs.set("1", forKey: "loginKey")
        //prefs.removeObject(forKey: "loginKey")
        prefs.synchronize()
        
    }
    
    func setUserDefaultsValues() {
        let prefs = UserDefaults.standard
        user_id = prefs.object(forKey: "user_id") as! String?
        user_name = prefs.object(forKey: "user_name") as! String?
        first_name = prefs.object(forKey: "first_name") as! String?
        image = prefs.object(forKey: "image") as! String?
        
        
    }
}
