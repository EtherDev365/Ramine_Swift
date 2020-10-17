//
//  AuthManager.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

typealias ErrorHandler = (_ error : NSError) -> Void
typealias AddCompletionHandler = (_ response:NSDictionary) -> Void

class AuthManager {

    //function for register user
    static func signUp(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void) {
        
        let parameters = information
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.account.API_register)
        { (result) in
            
            switch result {
            case .success(let upload, _, _):
                
                upload.responseJSON { response in
                    let json = JSON(response.result.value ?? "nil")
                    
                    var wsResponse: WSResponse
                    if json["status"] == true {
                        let model = UserModel.sharedInstance
                        model.setUserInformation(json:json)
                        wsResponse = WSResponse(code: "true", message: json.stringValue)
                    }else
                    {
                        wsResponse = WSResponse(code: json["status"].stringValue, message: json["message"].stringValue)
                    }
                    completion(json,wsResponse,nil)
                }
            case .failure(let error):
                let wsResponse = WSResponse(code: "1009", message: error.localizedDescription)
                completion(JSON.null,wsResponse,error as NSError?)
            }
        }
    }
    //function for login user
    static func login(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        
        let parameters = information
        
//        Alamofire.request(NetworkingConstants.baseURL+NetworkingConstants.account.API_login, method: .post, parameters: parameters, encoding: JSONEncoding.default)
//            .responseString { response in
//                let json = JSON(response.result.value ?? "nil")
//
//                var wsResponse: WSResponse
//                if json["status"] == true {
//                    let model = UserModel.sharedInstance
//                    model.setUserInformation(json:json)
//                    wsResponse = WSResponse(code: "true", message: json.stringValue)
//                }else {
//                    wsResponse = WSResponse(code: json["status"].stringValue, message: json["message"].stringValue)
//                }
//                completion(json,wsResponse,nil)
//        }
        
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.account.API_login)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    
                    let json = JSON(response.result.value ?? "nil")

                    var wsResponse: WSResponse
                    if json["status"] == true {
                        let model = UserModel.sharedInstance
                        model.setUserInformation(json:json)
                        wsResponse = WSResponse(code: "true", message: json.stringValue)
                    }else {
                        wsResponse = WSResponse(code: json["status"].stringValue, message: json["message"].stringValue)
                    }
                    completion(json,wsResponse,nil)
                }
            case .failure(let error):
                let wsResponse = WSResponse(code: "1009", message: error.localizedDescription)
                completion(JSON.null,wsResponse,error as NSError?)
            }
        }
    }
    //function for forgot password
    static func forgotPassword(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void) {
        let parameters = information
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.account.API_forgotAction)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let json = JSON(response.result.value ?? "nil")
                    
                    var wsResponse: WSResponse
                    if json["status"] == true{
                        wsResponse = WSResponse(code: "true", message: json.stringValue)
                    }else
                    {
                        wsResponse = WSResponse(code: json["status"].stringValue, message: json["message"].stringValue)
                    }
                    completion(json,wsResponse,nil)
                }
            case .failure(let error):
                let wsResponse = WSResponse(code: "1009", message: error.localizedDescription)
                completion(JSON.null,wsResponse,error as NSError?)
            }
        }
    }
    //function for check token code
    static func API_resetAction(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.account.API_resetAction)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let json = JSON(response.result.value ?? "nil")
                    
                    var wsResponse: WSResponse
                    if json["status"] == true{
                        wsResponse = WSResponse(code: "true", message: json.stringValue)
                    }else
                    {
                        wsResponse = WSResponse(code: json["status"].stringValue, message: json["message"].stringValue)
                    }
                    completion(json,wsResponse,nil)
                }
            case .failure(let error):
                let wsResponse = WSResponse(code: "1009", message: error.localizedDescription)
                completion(JSON.null,wsResponse,error as NSError?)
            }
        }
    }
    //function for reset password
    static func API_resetPassword(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.account.API_resetPassword)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let json = JSON(response.result.value ?? "nil")
                    
                    var wsResponse: WSResponse
                    if json["status"] == true{
                        wsResponse = WSResponse(code: "true", message: json.stringValue)
                    }else
                    {
                        wsResponse = WSResponse(code: json["status"].stringValue, message: json["message"].stringValue)
                    }
                    completion(json,wsResponse,nil)
                }
            case .failure(let error):
                let wsResponse = WSResponse(code: "1009", message: error.localizedDescription)
                completion(JSON.null,wsResponse,error as NSError?)
            }
        }
    }
    static func API_company_signup(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.account.API_company_signup)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let json = JSON(response.result.value ?? "nil")
                    
                    var wsResponse: WSResponse
                    if json["status"] == true{
                        wsResponse = WSResponse(code: "true", message: json.stringValue)
                    }else
                    {
                        wsResponse = WSResponse(code: json["status"].stringValue, message: json["message"].stringValue)
                    }
                    completion(json,wsResponse,nil)
                }
            case .failure(let error):
                let wsResponse = WSResponse(code: "1009", message: error.localizedDescription)
                completion(JSON.null,wsResponse,error as NSError?)
            }
        }
    }
    static func API_company_login(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.account.API_company_login)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let json = JSON(response.result.value ?? "nil")
                    
                    var wsResponse: WSResponse
                    if json["status"] == true{
                        wsResponse = WSResponse(code: "true", message: json.stringValue)
                    }else
                    {
                        wsResponse = WSResponse(code: json["status"].stringValue, message: json["message"].stringValue)
                    }
                    completion(json,wsResponse,nil)
                }
            case .failure(let error):
                let wsResponse = WSResponse(code: "1009", message: error.localizedDescription)
                completion(JSON.null,wsResponse,error as NSError?)
            }
        }
    }
    
    static func social_login(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.account.API_social_login)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let json = JSON(response.result.value ?? "nil")
                    
                    var wsResponse: WSResponse
                    if json["status"] == true{
                        let model = UserModel.sharedInstance
                        
                        model.setUserInformationNew(json:json)
                        wsResponse = WSResponse(code: "true", message: json.stringValue)
                    }else
                    {
                        wsResponse = WSResponse(code: json["status"].stringValue, message: json["message"].stringValue)
                    }
                    completion(json,wsResponse,nil)
                }
            case .failure(let error):
                let wsResponse = WSResponse(code: "1009", message: error.localizedDescription)
                completion(JSON.null,wsResponse,error as NSError?)
            }
        }
    }
    
    //function for invite user
    static func inviteUser(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void) {
        
        let parameters = information
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL + NetworkingConstants.account.API_invite)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let json = JSON(response.result.value ?? "nil")
                    
                    var wsResponse: WSResponse
                    if json["status"] == true{
                        wsResponse = WSResponse(code: "true", message: json.stringValue)
                    }else
                    {
                        wsResponse = WSResponse(code: json["status"].stringValue, message: json["message"].stringValue)
                    }
                    completion(json,wsResponse,nil)
                }
            case .failure(let error):
                let wsResponse = WSResponse(code: "1009", message: error.localizedDescription)
                completion(JSON.null,wsResponse,error as NSError?)
            }
        }
    }
    
    //Search Logo
    static func searchLogo(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void) {
        
        let parameters = information
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL + NetworkingConstants.company.API_searchLogo)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let json = JSON(response.result.value ?? "nil")
                    
                    var wsResponse: WSResponse
                    if json["status"] == true{
                        wsResponse = WSResponse(code: "true", message: json.stringValue)
                    }else
                    {
                        wsResponse = WSResponse(code: json["status"].stringValue, message: json["message"].stringValue)
                    }
                    completion(json,wsResponse,nil)
                }
            case .failure(let error):
                let wsResponse = WSResponse(code: "1009", message: error.localizedDescription)
                completion(JSON.null,wsResponse,error as NSError?)
            }
        }
    }
    
    
    //Apply Logo
    static func applyLogo(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void) {
        
        let parameters = information
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL + NetworkingConstants.company.API_applyLogo)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let json = JSON(response.result.value ?? "nil")
                    
                    var wsResponse: WSResponse
                    if json["status"] == true{
                        wsResponse = WSResponse(code: "true", message: json.stringValue)
                    }else
                    {
                        wsResponse = WSResponse(code: json["status"].stringValue, message: json["message"].stringValue)
                    }
                    completion(json,wsResponse,nil)
                }
            case .failure(let error):
                let wsResponse = WSResponse(code: "1009", message: error.localizedDescription)
                completion(JSON.null,wsResponse,error as NSError?)
            }
        }
    }
    
}


func ApiCalling(ServicesUrl : String, parameters : [String : Any], handler:@escaping AddCompletionHandler,errorhandler : @escaping ErrorHandler) {
    
    //MARK:  Alamofire Calling
    Alamofire.request(ServicesUrl, method: .post, parameters: parameters)
        .responseJSON { response in
                        
            switch response.result
            {
            //MARK:  Response Success
            case.success( _):
                
                if let responsedata:NSDictionary = response.result.value as? NSDictionary
                {
                    //MARK:  Handler Response Managed
                    handler(responsedata)
                }
            //MARK:  Response Failure
            case.failure(let error):
                //print("Faield ",error.localizedDescription)
                errorhandler(error as NSError)
            }
    }
    
}

