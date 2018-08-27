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
        var params: [String: Any] = [
            "page": page,
        ]
        
        if let searchString = search {
            params["search"] = searchString
        }
        
        EQAPIClient().getRequest(for: url, queryParams: params, authenticated: true) { (data) in
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
    }
}
