//
//  ImageMomentCell.swift
//  DouYin
//
//  Created by Niu Changming on 4/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class ImageMomentCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var messageLblHeightConstraints: NSLayoutConstraint!
    @IBOutlet weak var messageLbl: UILabel!{
        didSet{
            messageLbl.numberOfLines = 0
            messageLbl.sizeToFit()
        }
    }

    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    static func cellReuseIdentifier() -> String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
