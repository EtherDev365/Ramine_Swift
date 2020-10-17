//
//  CompanyModel.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import SwiftyJSON
class CompanyModel {
    
    var id:String?
    var image:String?
    var url:String?
    var email:String?
    var phone_no:String?
    var password:String?
    var created_at:String?
    var updated_at:String?
    var token:String?
    var token_generate:String?
    var token_count:String?
    var token_day:String?
    var description:String?
    var images:String?
    var user_image:String?
    var terms:String?
    
    init() {
        self.id = ""
        self.image = ""
        self.url = ""
        self.email = ""
        self.phone_no = ""
        self.password = ""
        self.created_at = ""
        self.updated_at = ""
        self.token = ""
        self.token_generate = ""
        self.token_count = ""
        self.token_day = ""
        self.description = ""
        self.images = ""
        self.user_image = ""
        self.terms = ""
    }
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.image = json["image"].stringValue
        self.url = json["url"].stringValue
        self.email = json["email"].stringValue
        self.phone_no = json["phone_no"].stringValue
        self.password = json["password"].stringValue
        self.created_at = json["created_at"].stringValue
        self.updated_at = json["updated_at"].stringValue
        self.token = json["token"].stringValue
        self.token_generate = json["token_generate"].stringValue
        self.token_count = json["token_count"].stringValue
        self.token_day = json["token_day"].stringValue
        self.description = json["description"].stringValue
        self.images = json["images"].stringValue
        self.user_image = json["user_image"].stringValue
        self.terms = json["terms"].stringValue
    }
}
