//
//  WSResponse.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import Foundation

class WSResponse {
    
    var code: String
    var message: String
    init(code : String, message: String) {
        self.code = code
        self.message = message
    }
}

