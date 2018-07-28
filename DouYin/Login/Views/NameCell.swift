//
//  NameCell.swift
//  DouYin
//
//  Created by Niu Changming on 25/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class NameCell: UITableViewCell {
    
    @IBOutlet weak var nameTf: UITextField!
    

    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    static func cellReuseIdentifier() -> String {
        return String(describing: self)
    }
    
}
