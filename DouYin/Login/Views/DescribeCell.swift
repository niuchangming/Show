//
//  DescribeCell.swift
//  DouYin
//
//  Created by Niu Changming on 31/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class DescribeCell: UITableViewCell {
    @IBOutlet weak var descTv: UITextView!
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    static func cellReuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
