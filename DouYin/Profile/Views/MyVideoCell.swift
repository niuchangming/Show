//
//  MyVideoCell.swift
//  DouYin
//
//  Created by Niu Changming on 4/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class MyVideoCell: UICollectionViewCell {

    @IBOutlet weak var coverIV: UIImageView!
    
    @IBOutlet weak var publishDataLbl: UILabel!
    
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
