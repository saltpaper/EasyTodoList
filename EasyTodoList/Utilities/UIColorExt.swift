//
//  UIColorExt.swift
//  EasyTodoList
//
//  Created by DJ on 14/12/2016.
//  Copyright © 2016 DJ. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(rgba: String) {
        var red:   CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue:  CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        if rgba.hasPrefix("#") {
            let index   = rgba.index(rgba.startIndex, offsetBy: 1)
            let hex     = rgba.substring(from: index) //substringFromIndex(index)
            let scanner = Scanner(string: hex)
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexInt64(&hexValue) {
                switch (hex.characters.count) {
                case 3:
                    red   = CGFloat((hexValue & 0xF00) >> 8)       / 15.0
                    green = CGFloat((hexValue & 0x0F0) >> 4)       / 15.0
                    blue  = CGFloat(hexValue & 0x00F)              / 15.0
                case 4:
                    red   = CGFloat((hexValue & 0xF000) >> 12)     / 15.0
                    green = CGFloat((hexValue & 0x0F00) >> 8)      / 15.0
                    blue  = CGFloat((hexValue & 0x00F0) >> 4)      / 15.0
                    alpha = CGFloat(hexValue & 0x000F)             / 15.0
                case 6:
                    red   = CGFloat((hexValue & 0xFF0000) >> 16)   / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)    / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF)           / 255.0
                case 8:
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                default:
                    print("Invalid RGB string, number of characters after '#' should be either 3, 4, 6 or 8", terminator: "")
                }
            } else {
                print("Scan hex error")
            }
        } else {
            print("Invalid RGB string, missing '#' as prefix", terminator: "")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    
    class func textGreyColor(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 61.0 / 255.0, green: 69.0 / 255.0, blue: 76.0 / 255.0, alpha: alpha)
    }
    
    class func lightGreyColor(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 194.0 / 255.0, green: 199.0 / 255.0, blue: 204.0 / 255.0, alpha: alpha)
    }

    class func extraDarkGreyColor(alpha: CGFloat = 1.0) -> UIColor {
        return UIColor(red: 102 / 255.0, green: 108 / 255.0, blue: 113 / 255.0, alpha: alpha)
    }
    
    class func checkGreenColor() -> UIColor {
        return UIColor(red: 34 / 255, green: 178 / 255, blue: 80 / 255, alpha: 1)
    }


    
    
}
