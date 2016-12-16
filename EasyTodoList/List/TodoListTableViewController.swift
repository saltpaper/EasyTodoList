//
//  TodoListTableViewController.swift
//  EasyTodoList
//
//  Created by DJ on 13/12/2016.
//  Copyright © 2016 DJ. All rights reserved.
//

import UIKit
import SwiftyJSON
import AFNetworking

final class TodoListTableViewController: UITableViewController {
    
    var taskList : [Task] = []
    
    var sortByCreate = true // default is by create time, false is by task date.
    
    override func viewDidLoad() {
        
        self.title = "All Tasks"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.fontAwesomeBarButtonItem(fontIconString:"fa-plus",target: self, selector: #selector(self.didClickAddButton(sender:)))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.fontAwesomeBarButtonItem(fontIconString:"fa-sort-amount-desc",target: self, selector: #selector(self.didClickSortButton(sender:)))

        self.tableView.tableFooterView = UIView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityDidChange(notification:)),  name: NSNotification.Name.AFNetworkingReachabilityDidChange, object: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 1. use local data
        self.taskList = self.fetchLocalTasksDate()
        self.sortBy()
        self.tableView.reloadData()

        // 2. check network, if has network, update data from server
        AFNetworkReachabilityManager.shared().setReachabilityStatusChange{ [unowned self](status:AFNetworkReachabilityStatus) -> Void in
        
            if status == .reachableViaWiFi || status == .reachableViaWWAN {
                //call server
                self.fetchServerData()
            }
            self.sortBy()
            self.tableView.reloadData()
        }
    }
    
    func fetchLocalTasksDate() -> [Task] {
        let context = AppDelegate.sharedDelegate().persistentContainer.viewContext
        do {
            return  try context.fetch(Task.fetchRequest())
        }catch {
            print("fetch failed")
        }
        return [Task]()
    }

    func fetchServerData() {
        //get server data and store to local db
        TodoListRetriever.getTaskList(success: {(allList) in
            let json = JSON(allList)
            self.checkDifferentData(serverData: json)
        }){(error) in
        }
        
    }
    //MARK: Handle data
    func checkDifferentData(serverData:JSON) {
        let allLocalData = self.fetchLocalTasksDate()  //get all local date

        //1. add new data from server to local db
          // frist, use server data for loop
        var dataOnlyOnServer = [[String: Any]]() //use to store which tasks not on server
        for serverItem in serverData.arrayObject! {
            var isOnLocal = false
            for localItem in allLocalData {
                if let itemDic = serverItem as? [String: AnyObject], let id = itemDic["taskId"] as? String, id == localItem.taskId {
                    isOnLocal = true
                    break
                }
            }
            if !isOnLocal {
                if let itemDic = serverItem as? [String: Any],let id = itemDic["taskId"] as? String,id != ""{
                   dataOnlyOnServer.append(itemDic)
                }
            }
        }
        
        if  dataOnlyOnServer.count > 0 {
            //store new server data to local db.
            let context = AppDelegate.sharedDelegate().persistentContainer.viewContext

            for item in dataOnlyOnServer {
                let task = Task(context:context)
                task.dicTransformToTask(dic: item)
            }
            AppDelegate.sharedDelegate().saveContext()
            
            // local db had updated, so need get again.
            self.taskList = self.fetchLocalTasksDate()
        }
        
        // 2. find new data on local,then upload to server
           //frist, use local data for loop
        var dataOnlyOnLocal = [Task]() //use to store which tasks not on server
        for localItem in allLocalData {
            var isOnServer = false
            for serverItem in serverData.arrayObject! {
                if let itemDic = serverItem as? [String: AnyObject], let id = itemDic["taskId"] as? String, id == localItem.taskId {
                    isOnServer = true
                    break
                }
            }
            
            if !isOnServer {
                // this local data not on server, then need to upload to server
                dataOnlyOnLocal.append(localItem)
            }
        }
        
        if dataOnlyOnLocal.count > 1 {
            TodoListRetriever.uploadMultipleTasksToServer(taskItems: dataOnlyOnLocal, success: { (success) in
                // success
            }) { (error) in
                // failure -- need to show alertView with message: "sync failure"
            }
        }else if dataOnlyOnLocal.count == 1 {
            TodoListRetriever.uploadATaskToServer(taskItem: dataOnlyOnLocal[0], success: { (success) in
                // success
            }){ (error) in
                // failure -- need to show alertView with message: "sync failure"
            }
        }
    }
    
    
    
    //MARK: UITableViewDelegate & UITableViewDataSource
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "TodoTableViewCell", for: indexPath) as! TodoTableViewCell
        cell.isFinishBoxButton.addTarget(self, action: #selector(self.didClickFinishButtonAction(sender:)), for: .touchUpInside)
        //get every task detail
        let task = taskList[indexPath.row]
        cell.taskTitleLabel.text = task.taskTitle
        cell.taskDateLabel.text = (task.taskDate as! Date).displayDate()
        cell.isFinishBoxButton.isSelected = task.isFinish
        cell.isFinishBoxButton.tag = indexPath.row
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "editTaskSegue", sender: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let context = AppDelegate.sharedDelegate().persistentContainer.viewContext
        if editingStyle == .delete {

            let task = taskList[indexPath.row]
            let id = NSString.init(string: task.taskId!)
            // delete server data
            TodoListRetriever.deleteATaskToServer(taskId: id as String, success: {(success) in
                
            }){(error) in
                //failure -- this item is not on server
            }

            //delete local data
            context.delete(task)
            AppDelegate.sharedDelegate().saveContext()
        }
        
        do {
            taskList = try context.fetch(Task.fetchRequest())
        }catch {
            print("fetch failed☹️")
        }
        self.sortBy()
        tableView.reloadData()
        
    }
    
    //MARK: Button action
    func didClickFinishButtonAction(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let task = taskList[sender.tag]
        let context = AppDelegate.sharedDelegate().persistentContainer.viewContext
        if let _task = context.object(with: task.objectID) as? Task {
            _task.isFinish = sender.isSelected
        }
        AppDelegate.sharedDelegate().saveContext()
    }

    func didClickAddButton(sender:UIBarButtonItem) {
        self.performSegue(withIdentifier: "addNewSegue", sender: nil)
    }
    
    func didClickSortButton(sender:UIBarButtonItem) {
        
        let alertController = UIAlertController(title:"Sort", message:nil,preferredStyle:UIAlertControllerStyle.actionSheet)
        alertController.addAction(UIAlertAction(title: "By Create Date", style: .default, handler: { [unowned self] (action) -> Void in
            self.sortByCreate = true
            self.sortBy()
            self.tableView.reloadData()
        }))
        alertController.addAction(UIAlertAction(title: "By Task Date", style: .default, handler: { [unowned self](action) -> Void in
            self.sortByCreate = false
            self.sortBy()
            self.tableView.reloadData()
        }))

        self.present(alertController, animated: true, completion: nil)
    }
    
    func sortBy(){
        self.taskList = self.taskList.sorted(by: { (Task1, Task2) -> Bool in
            if sortByCreate {
                return (Task2.createTime as! Date).compareDateSmallThan(compareDate: Task1.createTime as! Date)
            }else {
                return (Task1.taskDate as! Date).compareDateSmallThan(compareDate: Task2.taskDate as! Date)
            }
        })
    }
    
    //Mark: not test for check network anytime.
    func reachabilityDidChange(notification:NSNotification) {
        if let userInfo = notification.userInfo,
            let status = userInfo[AFNetworkingReachabilityNotificationStatusItem] as? AFNetworkReachabilityStatus, status == .reachableViaWiFi || status == .reachableViaWWAN {
            
        }
    }
    
    // Returns the reachability state contained in the notification
    func getReachabilityStateFromReachabilityNotification(notification: NSNotification) -> Bool {
        if let userInfo = notification.userInfo,
            let status = userInfo[AFNetworkingReachabilityNotificationStatusItem] as? AFNetworkReachabilityStatus, status == .reachableViaWiFi || status == .reachableViaWWAN {
            return true
        }
        
        return false
    }

    
}
