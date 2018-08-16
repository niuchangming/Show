//
//  CircleCell.swift
//  DouYin
//
//  Created by Niu Changming on 12/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class CircleCell: UICollectionViewCell {

    @IBOutlet weak var iconIv: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    
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
