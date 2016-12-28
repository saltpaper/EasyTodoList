//
//  TODO_Constant.swift
//  EasyTodoList
//
//  Created by DJ on 27/12/2016.
//  Copyright © 2016 DJ. All rights reserved.
//

import UIKit

class TODO_Constant: NSObject {
    static let fetchDataURL = "https://sheetsu.com/apis/v1.0/33c1d7e47888"
    
    static let dateWholeFormatter = "yyyMMddHHmmssSSSSSS"
    static let dateWeekFormatter = "EEE, MMM d yyyy"
    static let dateSystemFormatter = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    
    static let colorTagWidth: CGFloat = 60
    static let changeColorControllerHeight: CGFloat = 160
    
    static let kBgGreen = "#CEF4ED"
    static let kBgBlue = "#CDEFF7"
    static let kBgRed = "#D5562A"
    static let kBgOrage = "#EF8B45"
//    static let kBgPurple = "#D5562A"
    static let kBgYellow = "#FBFF9A"
    static let kBgGray = "#231f20"
    static let kBgBrown = "#E5E0CA"
    static let kBgWhite = "#CEC8CE"

    static let colorArray = [kBgGreen,kBgBlue,kBgRed,kBgOrage,kBgYellow,kBgGray,kBgBrown,kBgWhite]
    
}
