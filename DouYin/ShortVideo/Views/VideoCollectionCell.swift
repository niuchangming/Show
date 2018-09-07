//
//  WorkCollectionCellCollectionViewCell.swift
//  DouYin
//
//  Created by Niu Changming on 14/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class VideoCollectionCell: UICollectionViewCell {

    @IBOutlet weak var coverIV: UIImageView!
    @IBOutlet weak var userPhotoIV: UIImageView!
    @IBOutlet weak var distanceLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.userPhotoIV.layer.cornerRadius = self.userPhotoIV.frame.size.width / 2
        self.userPhotoIV.clipsToBounds = true
    }

}
