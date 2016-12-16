//
//  TodoTableViewCell.swift
//  EasyTodoList
//
//  Created by DJ on 13/12/2016.
//  Copyright © 2016 DJ. All rights reserved.
//

import UIKit

final class TodoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var isFinishBoxButton: UIButton!
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        taskTitleLabel.textColor = UIColor.textGreyColor()
        taskTitleLabel.font = UIFont.init(name: "Avenir-Roman", size: 14.0)
        
        isFinishBoxButton.titleLabel?.font = UIFont.fontAwesome(ofSize: 17.0)
        isFinishBoxButton.setTitle(String.fontAwesomeIcon(code: "fa-square-o"), for: .normal)
        isFinishBoxButton.setTitle(String.fontAwesomeIcon(code: "fa-check-square-o"), for: .selected)
        isFinishBoxButton.setTitleColor(UIColor.extraDarkGreyColor(), for: .normal)
        isFinishBoxButton.setTitleColor(UIColor.extraDarkGreyColor(), for: .selected)

        taskDateLabel.textColor = UIColor.extraDarkGreyColor()
        taskTitleLabel.font = UIFont.init(name: "Avenir-Light", size: 12.0)

    }
    
    
}
