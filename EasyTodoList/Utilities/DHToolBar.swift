//
//  DHToolBar.swift
//  EasyTodoList
//
//  Created by DJ on 14/12/2016.
//  Copyright © 2016 DJ. All rights reserved.
//

import UIKit

class DHToolBar: UIToolbar {
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    class func initWithTarget(target: AnyObject, tag: Int) -> DHToolBar {
    
        let toolbar = UINib.init(nibName: "DHToolBar", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! DHToolBar
        toolbar.doneButton.target = target
        toolbar.doneButton.tag = tag
            
        toolbar.cancelButton.target = target
        toolbar.cancelButton.tag = tag

        return toolbar
    }
    

    
}

