//
//  CommentModel.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import SwiftyJSON
class CommentModel {
    var id:String?
    var userid:String?
    var shipmentId:String?
    var comment:String?
    var updated_at:String?
    var created_at:String?
    var username:String?
    init() {
        self.id = ""
        self.userid = ""
        self.shipmentId = ""
        self.comment = ""
        self.updated_at = ""
        self.created_at = ""
        self.username = ""
    }
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.userid = json["userid"].stringValue
        self.shipmentId = json["shipmentId"].stringValue
        self.comment = json["comment"].stringValue
        self.updated_at = json["updated_at"].stringValue
        self.created_at = json["created_at"].stringValue
        self.username = json["username"].stringValue
    }
}
