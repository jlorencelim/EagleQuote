//
//  EQAPIClient.swift
//  EagleQuote
//
//  Created by Lorence Lim on 26/08/2018.
//  Copyright © 2018 Lorence Lim. All rights reserved.
//

import UIKit

import Alamofire


class EQAPIClient: NSObject {

    // MARK: - Attributes
    
    let authInstance: String?
    
    var currentRequest: DataRequest?
    
    // MARK: - Lifecycle
    
    override init() {
        self.authInstance = EQUtils.userDefaultsValue(with: UserDefaultsConstants.AuthToken) as? String
        self.currentRequest = nil
        
        super.init()
    }
    
    // MARK: - Public Methods
    
    public func cancelCurrentRequest() {
        self.currentRequest?.cancel()
    }
    
    public func cancelTasks() {
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (dataTasks, uploadTasks, downloadTasks) in
            dataTasks.forEach { $0.cancel() }
            uploadTasks.forEach { $0.cancel() }
            downloadTasks.forEach { $0.cancel() }
        }
    }
    
    public func getRequest(for link: String,
                           queryParams: [String: Any]?,
                           authenticated: Bool,
                           apiVersion: String,
                           completion: @escaping ([String: Any]?) -> Void) -> Void {
        let request = self.request(for: link,
                                   method: .get,
                                   queryParams: queryParams,
                                   apiVersion: apiVersion,
                                   authenticated: authenticated)
        
        self.performTask(with: request, completion: completion)
    }
    
    public func postRequest(for link: String,
                            bodyParams: [String: Any],
                            authenticated: Bool,
                            apiVersion: String,
                            completion: @escaping ([String: Any]?) -> Void) -> Void {
        let request = self.request(for: link,
                                   method: .post,
                                   bodyParams: bodyParams,
                                   apiVersion: apiVersion,
                                   authenticated: authenticated)
        
        self.performTask(with: request, completion: completion)
    }
    
    public func putRequest(for link: String,
                           bodyParams: [String: Any],
                           authenticated: Bool,
                           apiVersion: String,
                           completion: @escaping ([String: Any]?) -> Void) -> Void {
        let request = self.request(for: link,
                                   method: .put,
                                   bodyParams: bodyParams,
                                   apiVersion: apiVersion,
                                   authenticated: authenticated)
        
        self.performTask(with: request, completion: completion)
    }
    
    private func request(for endpoint: String,
                         method: HTTPMethod,
                         apiVersion: String,
                         authenticated: Bool) -> DataRequest {
        return request(for: endpoint,
                       method: method,
                       bodyParams: nil,
                       queryParams: nil,
                       apiVersion: apiVersion,
                       authenticated: authenticated)
    }
    
    private func request(for endpoint: String,
                         method: HTTPMethod,
                         bodyParams: [String: Any],
                         apiVersion: String,
                         authenticated: Bool) -> DataRequest {
        return request(for: endpoint,
                       method: method,
                       bodyParams: bodyParams,
                       queryParams: nil,
                       apiVersion: apiVersion,
                       authenticated: authenticated)
    }
    
    private func request(for endpoint: String,
                         method: HTTPMethod,
                         queryParams: [String: Any]?,
                         apiVersion: String,
                         authenticated: Bool) -> DataRequest {
        return request(for: endpoint,
                       method: method,
                       bodyParams: nil,
                       queryParams: queryParams,
                       apiVersion: apiVersion,
                       authenticated: authenticated)
    }
    
    private func request(for endpoint: String,
                         method: HTTPMethod,
                         bodyParams: [String: Any]?,
                         queryParams: [String: Any]?,
                         apiVersion: String,
                         authenticated: Bool) -> DataRequest {
        var params: [String: Any]?
        
        if bodyParams == nil && queryParams == nil {
            params = nil
        } else if bodyParams != nil && queryParams == nil {
            params = bodyParams
        } else {
            params = queryParams
        }
        
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "api-version": apiVersion,
        ]
        if authenticated {
            headers["Authorization"] = "Bearer \(self.authInstance!)"
        }
        
        // Default request is geared towards POST, PUT method encoding
        var request = Alamofire.request(endpoint,
                                        method: method,
                                        parameters: params,
                                        encoding: JSONEncoding(options: []),
                                        headers: headers)
        
        switch method {
        case .get, .delete:
            request = Alamofire.request(endpoint,
                                        method: method,
                                        parameters: params,
                                        encoding: URLEncoding(destination: .methodDependent),
                                        headers: headers)
            
        default:
            break
        }
        
        return request
    }
    
    // MARK: - Private Methods
    
    private func performTask(with request: DataRequest, completion: @escaping ([String: Any]?) -> Void) -> Void {
        self.currentRequest = request
        
        request.validate().responseJSON { (response) in
            switch response.result {
            case .success:
                if let data = response.result.value as? [String : Any] {
                    completion(data["data"] as? [String : Any])
                } else {
                    return
                }
            case .failure:
                if let responseData = response.data {
                    let responseDataString = String(data: responseData, encoding: String.Encoding.utf8)!
                    let data = responseDataString.data(using: String.Encoding.utf8)!
                    
                    do {
                        let errors = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                        
                        if let data = errors!["data"] as? [String : Any] {
                            completion(data)
                        } else {
                            completion(errors)
                        }
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}
