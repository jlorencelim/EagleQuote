//
//  EQAPIQuote.swift
//  EagleQuote
//
//  Created by Lorence Lim on 27/08/2018.
//  Copyright © 2018 Lorence Lim. All rights reserved.
//

import UIKit

class EQAPIQuote: NSObject {

    class func getQuote(page: Int, search: String?, completion: @escaping ([String: Any]?) -> Void) {
        let url = APIConstants.URL + "/quote/"
        let params: [String: Any] = [
            "page": page,
            "perPage": 20,
            "search": search != nil ? search! : ""
        ]
        
        EQAPIAuthentication.refreshToken { (response) in
            let status = response!["status"] as! String
            
            if status == "Success" {
                EQAPIClient().getRequest(for: url, queryParams: params, authenticated: true, apiVersion: "2.0") { (data) in
                    if let response = data!["response"] as? [String: Any] {
                        let status = response["status"] as! String
                        
                        if status == "Success" {
                            completion(data!)
                        } else {
                            let error: [String: Any] = ["error": response["message"] as! String]
                            completion(error)
                        }
                    }
                }
            } else {
                let error: [String: Any] = ["error": response!["message"] as! String]
                completion(error)
            }
        }
    }
    
    class func sendEmail(quoteId: Int,
                         to: [String],
                         cc: [String],
                         subject: String,
                         body: String,
                         completion: @escaping ([String: Any]?) -> Void) {
        let url = APIConstants.URL + "/sendemail/"
        var recipients: [[String: String]] = []
        for email in to {
            recipients.append([
                "email": email,
                "type": "to"
            ])
        }
        for email in cc {
            recipients.append([
                "email": email,
                "type": "to"
            ])
        }
        
        let params: [String: Any] = [
            "quoteId": quoteId,
            "recipients": recipients,
            "subject": subject,
            "body": body,
        ]
        
        EQAPIAuthentication.refreshToken { (response) in
            let status = response!["status"] as! String
            
            if status == "Success" {
                EQAPIClient().postRequest(for: url, bodyParams: params, authenticated: true, apiVersion: "1.0") { (data) in
                    if let response = data!["response"] as? [String: Any] {
                        let status = response["status"] as! String
                        
                        if status == "Success" {
                            completion(response)
                        } else {
                            let error: [String: Any] = ["error": response["message"] as! String]
                            completion(error)
                        }
                    }
                }
            } else {
                let error: [String: Any] = ["error": response!["message"] as! String]
                completion(error)
            }
        }
    }
    
}
