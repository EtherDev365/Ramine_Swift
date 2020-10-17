//
//  Constants.swift
//  Tivovi
//
//  Created by Suhas Arvind Patil on 31/07/19.
//  Copyright © 2019 DevelopersGroup. All rights reserved.
//

import Foundation
import UIKit

struct NOTIFICATIONS {
    
    static let USER_NOTIFICATION_BADGE = "USER_NOTIFICATION_BADGE"
}

let appdelegate = UIApplication.shared.delegate as! AppDelegate

var GOOGLE_API_KEY = "AIzaSyDqiqeR7YzaZT2xRrZGIl2ZK8HGk0NENow"
var GOOGLE_CLIENT_ID = "801051059082-6ihkfo344u9vfqnkse7035c5k1s23ur2.apps.googleusercontent.com"
var GOOGLE_REVERSE_CLIENT_ID = "com.googleusercontent.apps.801051059082-7rpbkv9e5jp1jntr3p15m9mm2mo4spee"
var local_Id = "123"


// NOTIFICATION
var pendingNotifications = [PackageModel]()

