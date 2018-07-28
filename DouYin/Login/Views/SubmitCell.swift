//
//  SubmitCell.swift
//  DouYin
//
//  Created by Niu Changming on 26/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class SubmitCell: UITableViewCell {
    var clickHandler: (() -> Void)!
    @IBOutlet weak var submitBtn: UIButton! {
        didSet{
            submitBtn.clipsToBounds = true
            submitBtn.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        }
    }
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    static func cellReuseIdentifier() -> String {
        return String(describing: self)
    }
    
    @IBAction func submitBtnClicked(_ sender: UIButton) {
        clickHandler()
    }
    
}
