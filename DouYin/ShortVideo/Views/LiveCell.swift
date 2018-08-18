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
            if(Utils.isNotNil(obj: fillCell.coverImage?.medium)){
                coverImageIV.setURLImageWithURL(url: URL.init(string: (fillCell.coverImage?.origin)!)!, placeHoldImage: UIImage.init(named: "placeholder")!, isCircle: false)
            }else{
                coverImageIV.image = UIImage.init(named: "placeholder")
            }
            viewAmountLbl.text = String(fillCell.audienceCount)
            nameLbl.text = fillCell.nickname

            LocationManager.share.getAdress(lat: fillCell.lat, lon: fillCell.lon) { (address, error) in
                if error == nil {
                    self.locLbl.text = address!["City"] as? String
                    self.liveLbl.text = "Live"
                }
            }
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















