//
//  APIManager.swift
//  Spintly
//
//  Created by Suhas Patil on 27/03/19.
//  Copyright © 2019 SwarajyaIT India. All rights reserved.
//

import Foundation
import Alamofire
import RappleProgressHUD

typealias APICompletion = (APIResponse) -> Void

struct APIResponse {
    var status = false
    var errorMessage : String?
    var object : [String: Any]?
}

class APIManager {
    
    static var manager : APIManager?
    class func shared() -> APIManager {
        if manager == nil {
            manager = APIManager()
        }
        return manager!
    }
    
    //MARK:- POST
    func requestWith(_ endPoint : String, method requestMethod : HTTPMethod, andParameters parameters : Parameters?, withCompletion completion: @escaping APICompletion) {
       
        let postParameters = parameters! as [String: Any]
        let postString = postParameters.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        
        let postData = NSMutableData(data: postString.data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: endPoint)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50.0)
        
        request.httpMethod = requestMethod.rawValue
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            DispatchQueue.main.async {
                
                RappleActivityIndicatorView.stopAnimating()

                if (error != nil) {
                    ////print(error!)
                    completion(APIResponse(status: false, errorMessage: error?.localizedDescription, object: nil))
                    
                } else {
                    
                    let responseString = String(data: data!, encoding: .utf8)
                    let responseDict = NSDictionary.convertStringToDictionary(text: responseString!)
                    
                    if responseDict == nil
                    {
                        completion(APIResponse(status: false, errorMessage: "", object: nil))
                        return
                    }
                    
                    if responseDict?["error"] as? Bool != nil {
                        
                        if responseDict?["error"] as? Bool == true {
                            
                            completion(APIResponse(status: false, errorMessage: responseDict!["status"] as? String ?? "Error.", object: responseDict))
                            return
                        }
                    }
                    
//                    if responseDict?["status"] as? String != nil || responseDict?["status"] as? String != "" {
//
//                        completion(APIResponse(status: false, errorMessage: responseDict!["status"] as? String ?? "", object: responseDict))
//                        return
//                    }
                    
                    completion(APIResponse(status: true, errorMessage: "", object: responseDict))
                }
            }
        })
        dataTask.resume()
    }
    
    
    
    func requestWithResposneArray(_ endPoint : String, method requestMethod : HTTPMethod, andParameters parameters : Parameters?, withCompletion completion: @escaping APICompletion) {
        
        let postParameters = parameters! as [String: Any]
        let postString = postParameters.compactMap({ (key, value) -> String in
            return "\(key)=\(value)"
        }).joined(separator: "&")
        
        let postData = NSMutableData(data: postString.data(using: String.Encoding.utf8)!)
        
        let request = NSMutableURLRequest(url: NSURL(string: endPoint)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50.0)
        
        request.httpMethod = requestMethod.rawValue
        request.httpBody = postData as Data
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            DispatchQueue.main.async {
                
                RappleActivityIndicatorView.stopAnimating()
                
                if (error != nil) {
                    ////print(error!)
                    completion(APIResponse(status: false, errorMessage: error?.localizedDescription, object: nil))
                    
                } else {
                    
                    let responseString = String(data: data!, encoding: .utf8)
                    let data = responseString!.data(using: .utf8)!
                    do {
                        if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
                        {
                            //print(jsonArray) // use the json here
                            
                            let responseDict = [
                                "images" : jsonArray
                            ]
                            
                            if jsonArray == nil
                            {
                            }
                            
                            completion(APIResponse(status: true, errorMessage: "", object: responseDict))
                            
                        } else {
                            //print("bad json")
                            completion(APIResponse(status: false, errorMessage: "Bad JSON", object: nil))
                            return
                            
                        }
                    } catch let error as NSError {
                        //print(error)
                        completion(APIResponse(status: false, errorMessage: error.localizedDescription, object: nil))
                        return
                        
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    
    func requestWithJson(_ endPoint : String, method requestMethod : HTTPMethod, andParameters parameters : Parameters?, withCompletion completion: @escaping APICompletion) {
        
        
        let headers = [
            "content-type": "application/json",
            "cache-control": "no-cache"
        ]
        
        let postParameters = parameters! as [String: Any]
        let postData = try? JSONSerialization.data(withJSONObject: postParameters, options: .prettyPrinted)
        
        let request = NSMutableURLRequest(url: NSURL(string: endPoint)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50.0)
        
        request.allHTTPHeaderFields = headers as? [String : String]
        request.httpShouldHandleCookies = true
        request.httpMethod = requestMethod.rawValue
        request.httpBody = (postData as! Data)
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            DispatchQueue.main.async {
                if (error != nil) {
                    ////print(error!)
                    completion(APIResponse(status: false, errorMessage: error?.localizedDescription, object: nil))
                    
                } else {
                    
                    let responseString = String(data: data!, encoding: .utf8)
                    var responseDict = NSDictionary.convertStringToDictionary(text: responseString!)
                    
                    if responseDict == nil
                    {
                        completion(APIResponse(status: false, errorMessage: "", object: nil))
                        return
                    }
                    
                    if responseDict!["status"] as! Bool != true {
                        completion(APIResponse(status: false, errorMessage: (responseDict!["message"] as! String), object: responseDict))
                        return
                    }
                    
                    completion(APIResponse(status: true, errorMessage: "", object: responseDict))
                }
            }
        })
        dataTask.resume()
    }

    
    //MARK:- GET METHODS
    func getRequestWithUrl(_ endPoint : String, method requestMethod : HTTPMethod, andParameters parameters : Parameters?, withCompletion completion: @escaping APICompletion) {
        
        let request = NSMutableURLRequest(url: NSURL(string: endPoint)! as URL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 50.0)
        
        request.httpMethod = requestMethod.rawValue
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            DispatchQueue.main.async {
                if (error != nil) {
                    ////print(error!)
                    completion(APIResponse(status: false, errorMessage: error?.localizedDescription, object: nil))
                    
                } else {
                    
                    let responseString = String(data: data!, encoding: .utf8)
                    var responseDict = NSDictionary.convertStringToDictionary(text: responseString!)
                    
                    if responseDict == nil
                    {
                        completion(APIResponse(status: false, errorMessage: "", object: nil))
                        return
                    }
                    
                    if responseDict!["status"] as! Bool != true {
                        completion(APIResponse(status: false, errorMessage: (responseDict!["message"] as! String), object: responseDict))
                        return
                    }
                    if responseDict!["status"] as! Bool != true {
                        completion(APIResponse(status: false, errorMessage: (responseDict!["message"] as? String ?? "Failed."), object: responseDict))
                        return
                    }
                    
                    completion(APIResponse(status: true, errorMessage: "", object: responseDict))
                    
                }
            }
        })
        dataTask.resume()
    }
}


