//
//  EQAPIAuthentication.swift
//  EagleQuote
//
//  Created by Lorence Lim on 26/08/2018.
//  Copyright © 2018 Lorence Lim. All rights reserved.
//

import UIKit


class EQAPIAuthentication: NSObject {
    
    class func login(email: String, password: String, completion: @escaping ([String: Any]?) -> Void) {
        let url = APIConstants.URL + "/LogIn/"
        let params = [
            "email": email,
            "password": password
        ]
        
        EQAPIClient().postRequest(for: url, bodyParams: params, authenticated: false) { (data) in
            if let response = data!["response"] as? [String: Any] {
                let status = response["status"] as! String
                
                if status == "Success" {
                    let authorization = data!["authorization"] as! [String: Any]
                    EQUtils.setUserDefaultsValue(authorization["token"] as! String, key: UserDefaultsConstants.AuthInstance)
                    
                    let user = data!["user"] as! [String: Any]
                    completion(user)
                } else {
                    let error: [String: Any] = ["error": response["message"] as! String]
                    completion(error)
                }
            }
            
            
        }
    }
    
}
