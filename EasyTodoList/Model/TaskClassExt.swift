//
//  TaskClassExt.swift
//  EasyTodoList
//
//  Created by DJ on 15/12/2016.
//  Copyright © 2016 DJ. All rights reserved.
//

import UIKit

extension Task {
    
    func transformToDic() -> [String: Any] {
        var dic = [String: Any]()
        dic["taskId"] = self.taskId
        dic["taskTitle"] = self.taskTitle
        dic["taskDate"] = (self.taskDate as! Date).displayDate(dateFormat: dateSystemFormatter)
        dic["isFinish"] = self.isFinish
        dic["createTime"] = (self.createTime as! Date).displayDate(dateFormat: dateSystemFormatter)
        dic["taskRemark"] = self.taskRemark
        dic["tagColor"] = self.tagColor

        return dic
    }
    
    func dicTransformToTask(dic:[String:Any]) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateSystemFormatter
        dateFormatter.timeZone = TimeZone.ReferenceType.local

        if let title = dic["taskTitle"] as? String {
            self.taskTitle = title
        }
        
        if let tDateString = dic["taskDate"] as? String, let tDate = dateFormatter.date(from: tDateString) {
            self.taskDate = tDate as NSDate?
        }else {
            self.createTime = NSDate()
        }
        
        if let id = dic["taskId"] as? String {
            self.taskId = id
        }
        
        if let remark = dic["taskRemark"] as? String {
            self.taskRemark = remark
        }

        if let cTimeString = dic["createTime"] as? String, let cTime = dateFormatter.date(from: cTimeString) {
            self.createTime = cTime as NSDate?
        }else {
            self.createTime = NSDate()
        }
        
        if let isfin = dic["isFinish"] as? Bool {
            self.isFinish = isfin
        }else {
            self.isFinish = false
        }

        if let color = dic["tagColor"] as? Int16 {
            self.tagColor = color
        }else {
            self.tagColor = 0
        }
        
    }
    
    
}
