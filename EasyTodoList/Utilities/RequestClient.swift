//
//  RequestClient.swift
//  EasyTodoList
//
//  Created by DJ on 15/12/2016.
//  Copyright © 2016 DJ. All rights reserved.
//

import UIKit
import AFNetworking

enum RequestType {
    case Get
    case Post
    case Delete
    case Patch
}
class RequestClient: AFHTTPSessionManager {
    
    static let shareInstance : RequestClient = {
        let toolInstance = RequestClient()
        toolInstance.responseSerializer.acceptableContentTypes?.insert("text/html")
        return toolInstance
    }()
    
    
    
    func request(requestType : RequestType, url : String, parameters : [String : Any], succeed : @escaping(AnyObject?) -> (), failure : @escaping(Error?) -> ()) {
        
        // success
        let successBlock = { (task: URLSessionDataTask, responseObj: Any?) in
            succeed(responseObj as AnyObject?)
        }
        
        // failure
        let failureBlock = { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        }
        
        // Get request
        if requestType == .Get {
            get(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        }
        
        // Post request
        if requestType == .Post {
            post(url, parameters: parameters, progress: nil, success: successBlock, failure: failureBlock)
        }
        
        // Delete request
        if requestType == .Delete {
            delete(url, parameters: parameters, success: successBlock, failure: failureBlock)
        }
        
        // Patch request
        if requestType == .Patch {
            patch(url, parameters: parameters, success: successBlock, failure: failureBlock)
        }

        
        
    }
}
