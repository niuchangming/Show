//
//  LiveCell.swift
//  DouYin
//
//  Created by Niu Changming on 26/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class LiveCell: UITableViewCell {
    
    @IBOutlet weak var coverImageIV: UIImageView!
    @IBOutlet weak var liveBgView: UIView!
    @IBOutlet weak var locLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var viewAmountLbl: UILabel!
    @IBOutlet weak var liveLbl: UILabel!

    public var fillCell = Live() {
        didSet {
            coverImageIV.setURLImageWithURL(url: URL.init(string: (fillCell.info?.creator?.portrait)!)!, placeHoldImage: UIImage.init(named: "placeholder")!, isCircle: false)
            viewAmountLbl.text = String.init(format: "%d", arc4random_uniform(200)+arc4random_uniform(500))
            nameLbl.text = fillCell.info?.creator?.nick
            locLbl.text = "大连"
            liveLbl.text = "Live"
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        liveBgView.clipsToBounds = true
        liveBgView.layer.cornerRadius = 4
        coverImageIV?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        coverImageIV?.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
