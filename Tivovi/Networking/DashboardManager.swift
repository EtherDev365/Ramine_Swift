//
//  DashboardManager.swift
//  Tivovi
//
//  Created by TEAM PESTO by Mike, Dennis and Henrik on 26/08/18.
//  Copyright © 2018 tivovi.com - All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class DashboardManager: NSObject {
    
    static func showProfile(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.account.API_showprofile)
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
    
    static func updateProfile(information: [String: String], profileImg: Data, completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        Alamofire.upload(multipartFormData: { multipartFormData in
            //if(profileImg != nil){
            multipartFormData.append(profileImg, withName: "image",fileName: "file.jpg", mimeType: "image/jpg")
            //}
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.account.API_updateprofile)
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
    
    //for get all company
    static func getAllCompany(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        Alamofire.upload(multipartFormData: { multipartFormData in
            
        },to:NetworkingConstants.baseURL+NetworkingConstants.company.API_getAllCompany)
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
    
    //for get all package by user id
    static func API_getPackageByUserId(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        
        //print("API_getPackageByUserId params: \(parameters)")
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.company.API_getPackageByUserId)
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
    
    //for get all images by package id
    static func API_getPackageGallery(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to: NetworkingConstants.baseURL+NetworkingConstants.addImage.API_addImage) { (result) in
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
    //for post new image by package id
    static func API_addImage(information: [String: String],packageImg:Data?,imageName:String?, completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        Alamofire.upload(multipartFormData: { multipartFormData in
            if(packageImg != nil) {
                multipartFormData.append(packageImg!, withName: "image",fileName: imageName!, mimeType: "image/jpg")
            }
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.addImage.API_addImage)
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
    
    static func API_getPendingNotificationByUserId(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void) {
        
        let parameters = information
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.company.API_getPendingNotificationUserId)
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
    //
    static func API_deletePackage(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.company.API_deletePackageOrShared)
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
    
    static func API_RejectPackage(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.company.API_RejectPackage)
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
    
    static func API_AcceptPackage(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.company.API_AcceptPackage)
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
    
    //function for changed package logo
    static func API_updatePackageCompanyLogo(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.company.API_updatePackageCompanyLogo)
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
    
    //function for changed package logo
    static func API_shipment_action(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.account.API_shipment_action)
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
    
    //function for changed package logo
    static func API_show_comments(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.account.API_show_comments)
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
    //function for changed package logo
    static func API_add_comment(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.account.API_add_comment)
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
    //
    static func API_ajaxdatauser(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        Alamofire.upload(multipartFormData: { multipartFormData in
            //            for (key, value) in parameters {
            //                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            //            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.account.API_ajaxdatauser)
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    let json = JSON(response.result.value ?? "nil")
                    var wsResponse: WSResponse
                    if json["status"] == true{
                        wsResponse = WSResponse(code: "true", message: json.stringValue)
                    } else
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
    
    static func getAllCompanyOne(information: [String: String],
                                 completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        Alamofire.request(NetworkingConstants.baseURL+NetworkingConstants.account.API_ajaxdatauser).responseData { (resData) -> Void in
            let json = JSON(resData.result.value!)
            var wsResponse: WSResponse
            if json["status"] == true{
                wsResponse = WSResponse(code: "true", message: json.stringValue)
            }else {
                wsResponse = WSResponse(code: json["status"].stringValue, message: json["message"].stringValue)
            }
            completion(json,wsResponse,nil)
        }
    }
    
    static func API_share_userdata(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.company.API_share_userdata)
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
    
    static func API_getRandomScreens(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.swipePage.API_getRandomScreens)
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
    
    static func API_screensLikeUnlike(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.swipePage.API_screensLikeUnlike)
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
    
    static func API_screensUndo(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.swipePage.API_screensUndo)
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
    
    static func API_getAllMyLikedScreens(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void){
        let parameters = information
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        },to:NetworkingConstants.baseURL+NetworkingConstants.swipePage.API_getAllMyLikedScreens)
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
    
    static func analyzeResult(result: SessionManager.MultipartFormDataEncodingResult, completion:@escaping (JSON, WSResponse, NSError?) -> Void) {
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
    
    static func API_updatePackage(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void) {
        let parameters = information
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: NetworkingConstants.baseURL + NetworkingConstants.company.API_updatePackage) { (result) in
            analyzeResult(result: result, completion: completion)
        }
    }
    
    static func API_shipment_action2(information: [String: String], completion:@escaping (JSON,WSResponse,NSError?) -> Void) {
        let parameters = information
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to: NetworkingConstants.baseURL + NetworkingConstants.account.API_shipment_action2) { (result) in
            analyzeResult(result: result, completion: completion)
        }
    }
}
