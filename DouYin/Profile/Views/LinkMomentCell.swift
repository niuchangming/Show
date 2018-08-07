//
//  LinkMomentCell.swift
//  DouYin
//
//  Created by Niu Changming on 4/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class LinkMomentCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var linkIV: UIImageView!{
        didSet{
            linkIV.clipsToBounds = true
            linkIV.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        }
    }
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var linkTitleLbl: UILabel!
    
    @IBOutlet weak var linkTitleHeightContraints: NSLayoutConstraint!
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
