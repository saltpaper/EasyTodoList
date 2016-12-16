//
//  DateExt.swift
//  EasyTodoList
//
//  Created by DJ on 14/12/2016.
//  Copyright © 2016 DJ. All rights reserved.
//

import UIKit

extension Date {
    
    
    func displayDate(dateFormat:String = dateWeekFormatter) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.timeZone = NSTimeZone.system
        return dateFormatter.string(from: self)
    }
    
    func compareDateSmallThan(compareDate:Date) -> Bool{
        return !(compare(compareDate) == .orderedDescending)
    }

    
}
