//
//  TodoListRetriever.swift
//  EasyTodoList
//
//  Created by DJ on 15/12/2016.
//  Copyright © 2016 DJ. All rights reserved.
//

import Foundation

class TodoListRetriever: NSObject {
    
    //get task list
    class func getTaskList(success: @escaping (_ tasklList: [[String: AnyObject]]) -> Void, failure: @escaping (_ error: NSError?) -> Void) {

        RequestClient.shareInstance.request(requestType: .Get, url: TODO_Constant.fetchDataURL, parameters: [:], succeed: { (response) in
            guard let dicArray = response as? [[String: Any]] else {
                return
            }
            
            success(dicArray as [[String : AnyObject]])
            
        }) { (error) in
            guard let error = error else {
                return
            }
            failure(error as NSError?)
        }

        
    }
    
    // upload a task item
    class func uploadATaskToServer(taskItem:Task,  success: @escaping (_ isSuccess: Bool) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        
        RequestClient.shareInstance.request(requestType: .Post, url: TODO_Constant.fetchDataURL, parameters: taskItem.transformToDic(), succeed: { (response) in
            guard let dicArray = response as? [[String: Any]] else {
                return
            }
            if dicArray.count > 0 {
                success(true)
            }
            
        }) { (error) in
            guard let error = error else {
                return
            }
            failure(error as NSError?)
        }
    }
    
    //upload more tasks
    class func uploadMultipleTasksToServer(taskItems:[Task],  success: @escaping (_ isSuccess: Bool) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        
        var items =  [[String : AnyObject]]()
        for task in taskItems {
            items.append(task.transformToDic() as [String : AnyObject])
        }
        
        RequestClient.shareInstance.request(requestType: .Post, url: TODO_Constant.fetchDataURL, parameters: ["rows":items], succeed: { (response) in
            guard let dicArray = response as? [[String: Any]] else {
                return
            }
            if dicArray.count > 0 {
                success(true)
            }
            
        }) { (error) in
            guard let error = error else {
                return
            }
            failure(error as NSError?)
        }
    }

    class func deleteATaskToServer(taskId:String,  success: @escaping (_ isSuccess: Bool) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        
        let path = TODO_Constant.fetchDataURL + "/taskId/\(taskId)"
        RequestClient.shareInstance.request(requestType: .Delete, url: path, parameters: [:], succeed: { (response) in
            success(true)
            
        }) { (error) in
            
            guard let error = error else {
                return
            }
            failure(error as NSError?)
        }
    }

    
    class func editTaskToServer(taskId:String,taskItem:[String:Any],  success: @escaping (_ isSuccess: Bool) -> Void, failure: @escaping (_ error: NSError?) -> Void) {
        
        let path = TODO_Constant.fetchDataURL + "/taskId/\(taskId)"
        RequestClient.shareInstance.request(requestType: .Patch, url: path, parameters:  taskItem, succeed: { (response) in
            success(true)
            
        }) { (error) in
            
            guard let error = error else {
                return
            }
            failure(error as NSError?)
        }
    }

    

    
}
