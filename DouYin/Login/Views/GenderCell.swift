//
//  GenderCell.swift
//  DouYin
//
//  Created by Niu Changming on 25/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import RoundedSwitch

class GenderCell: UITableViewCell {

    lazy var genderSwitch: Switch = {
        let genderSwitch = Switch()
        genderSwitch.leftText = "Male"
        genderSwitch.rightText = "Female"
        genderSwitch.rightSelected = true
        genderSwitch.tintColor = UIColor(hexString: Constants.ColorScheme.blackColor)
        genderSwitch.disabledColor = genderSwitch.tintColor.withAlphaComponent(0.4)
        genderSwitch.backColor = genderSwitch.tintColor.withAlphaComponent(0.05)
        genderSwitch.sizeToFit()
        self.contentView.addSubview(genderSwitch)
        return genderSwitch
    }()
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    static func cellReuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        genderSwitch.frame =  CGRect(x: self.contentView.frame.size.width - 160 - 15, y: 9, width: 160, height: 32)
    }
    
    
}
