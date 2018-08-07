//
//  FavouriteVideoCell.swift
//  DouYin
//
//  Created by Niu Changming on 4/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class FavouriteVideoCell: UICollectionViewCell {
    
    @IBOutlet weak var videoTypeIV: UIImageView!
    @IBOutlet weak var videoTypeContainer: UIView!{
        didSet{
            videoTypeContainer.clipsToBounds = true
            videoTypeContainer.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        }
    }
    
    @IBOutlet weak var videoTypeLbl: UILabel!
    @IBOutlet weak var coverIV: UIImageView!
    
    @IBOutlet weak var avatarIV: UIImageView!{
        didSet{
            avatarIV.clipsToBounds = true
            avatarIV.layer.cornerRadius = avatarIV.frame.width / 2
        }
    }
    
    @IBOutlet weak var nameLbl: UILabel!
    
    
    @IBOutlet weak var likeCount: UILabel!
    
    @IBOutlet weak var heartLeading: NSLayoutConstraint!
    @IBOutlet weak var heartTrailing: NSLayoutConstraint!
    
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
