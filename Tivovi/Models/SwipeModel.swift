//
//  SwipeModel.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import SwiftyJSON

class SwipeModel {
    
    var id:String?
    var name:String?
    var weburl:String?
    var image:String?
    var likeCount:String?
    
    init() {
        self.id = ""
        self.name = ""
        self.weburl = ""
        self.image = ""
        self.likeCount = ""
    }
    init(json:JSON) {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.weburl = json["weburl"].stringValue
        self.image = json["image"].stringValue ?? ""
        self.likeCount = json["likeCount"].stringValue
    }
}
