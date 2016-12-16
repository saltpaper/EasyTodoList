//
//  UIBarButtonItemExt.swift
//  EasyTodoList
//
//  Created by DJ on 16/12/2016.
//  Copyright © 2016 DJ. All rights reserved.
//

import UIKit

extension UIBarButtonItem {
    
    class func fontAwesomeBarButtonItem(fontIconString:String,target:Any,selector:Selector) -> UIBarButtonItem {
        
        let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize:17),NSForegroundColorAttributeName: UIColor.textGreyColor()]
        let addButton = UIBarButtonItem.init()
        addButton.setTitleTextAttributes(attributes, for: .normal)
        addButton.title = String.fontAwesomeIcon(code: fontIconString)
        addButton.style = .plain
        addButton.target = target as AnyObject?
        addButton.action = selector

        return addButton
    }
    
    
    
    
}
