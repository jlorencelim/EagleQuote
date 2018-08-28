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
        
        EQAPIClient().postRequest(for: url, bodyParams: params, authenticated: false, apiVersion: "2.0") { (data) in
            if let response = data!["response"] as? [String: Any] {
                let status = response["status"] as! String
                
                if status == "Success" {
                    let authorization = data!["authorization"] as! [String: Any]
                    let sessionToken = authorization["sessionToken"] as! [String: Any]
                    let refreshToken = authorization["refreshToken"] as! [String: Any]
                    let user = data!["user"] as! [String: Any]
                    
                    EQUtils.setUserDefaultsValue(sessionToken["token"] as! String, key: UserDefaultsConstants.AuthToken)
                    EQUtils.setUserDefaultsValue(refreshToken["token"] as! String, key: UserDefaultsConstants.RefreshToken)
                    EQUtils.setUserDefaultsObject(user as AnyObject, key: UserDefaultsConstants.User)
                    
                    completion(user)
                } else {
                    let error: [String: Any] = ["error": response["message"] as! String]
                    completion(error)
                }
            }
        }
    }
    
    class func logout(completion: @escaping ([String: Any]?) -> Void) {
        let url = APIConstants.URL + "/Logout/"
        let user = EQUtils.userDefaultsObject(with: UserDefaultsConstants.User) as! [String: Any]
        let token = EQUtils.userDefaultsValue(with: UserDefaultsConstants.RefreshToken) as! String
        let params = [
            "email": user["email"] as! String,
            "token": token,
        ]
        
        EQAPIClient().postRequest(for: url, bodyParams: params, authenticated: false, apiVersion: "2.0") { (data) in
            let status = data!["status"] as! String
            
            if status == "Success" {
                EQUtils.removeUserDefaultValue(with: UserDefaultsConstants.AuthToken)
                EQUtils.removeUserDefaultValue(with: UserDefaultsConstants.RefreshToken)
                EQUtils.removeUserDefaultValue(with: UserDefaultsConstants.User)
                
                completion(user)
            } else {
                let error: [String: Any] = ["error": data!["message"] as! String]
                completion(error)
            }
        }
    }
}
