//
//  EQUtils.swift
//  EagleQuote
//
//  Created by Lorence Lim on 26/08/2018.
//  Copyright © 2018 Lorence Lim. All rights reserved.
//

import UIKit

class EQUtils: NSObject {
    // MARK: - NSUserDefaults helper methods
    
    class func setUserDefaultsCustomObject(_ object: AnyObject?, key: String) -> Void {
        let archivedObject = NSKeyedArchiver.archivedData(withRootObject: object!)
        
        UserDefaults.standard.set(archivedObject, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func setUserDefaultsObject(_ object: AnyObject?, key: String) -> Void {
        UserDefaults.standard.set(object, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func setUserDefaultsValue(_ value: Any?, key: String) -> Void {
        UserDefaults.standard.set(value, forKey: key)
        UserDefaults.standard.synchronize()
    }
    
    class func userDefaultsCustomObject(with key: String) -> AnyObject? {
        let encodedObject = UserDefaults.standard.object(forKey: key) as? Data
        
        if encodedObject == nil {
            return nil
        }
        
        let object = NSKeyedUnarchiver.unarchiveObject(with: encodedObject!) as AnyObject
        
        return object
    }
    
    class func userDefaultsObject(with key: String) -> AnyObject? {
        return UserDefaults.standard.object(forKey: key) as AnyObject
    }
    
    class func userDefaultsValue(with key: String) -> Any? {
        return UserDefaults.standard.value(forKey: key)
    }
    
    // MARK: - App-wide helper methods
    
    class func dictionary(from filename: String) -> [String: Any]? {
        if let url = Bundle.main.url(forResource: filename, withExtension: "json") {
            return dictionary(from: url)
        }
        
        return nil
    }
    
    class func dictionary(from url: URL?) -> [String: Any]? {
        do {
            if let file = url {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let object = json as? [String: Any] {
                    return object
                } else if let object = json as? [Any] {
                    return ["data": object]
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }

}
