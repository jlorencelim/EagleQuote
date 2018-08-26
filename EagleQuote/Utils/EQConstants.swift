//
//  EQConstants.swift
//  EagleQuote
//
//  Created by Lorence Lim on 26/08/2018.
//  Copyright © 2018 Lorence Lim. All rights reserved.
//

import UIKit

// MARK: - Constants

struct APIConstants {
    static let URL = "https://staging.blackfin.technology/mobile"
    
    struct ContentType {
        static let JSON = "application/json"
    }
    
    struct Header {
        static let Accept = "Accept"
        static let Authorization = "Authorization"
        static let ContentType = "Content-Type"
    }
}

struct UserDefaultsConstants {
    static let AuthInstance = "AuthInstanceUserDefaultsKey"
    static let DeviceToken = "DeviceTokenUserDefaultsKey"
}
