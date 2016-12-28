//
//  ColorCollectionViewCell.swift
//  EasyTodoList
//
//  Created by DJ on 27/12/2016.
//  Copyright © 2016 DJ. All rights reserved.
//

import UIKit

class ColorCollectionViewCell:UICollectionViewCell {
    
    @IBOutlet weak var checkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        checkLabel.font = UIFont.fontAwesome(ofSize: 17.0)
        checkLabel.text = String.fontAwesomeIcon(code: "fa-check")

    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                checkLabel.textColor = UIColor.checkGreenColor()
            } else {
                checkLabel.textColor = UIColor.clear
            }
        }
    }

    
}
