//
//  LiveCollectionCellHeader.swift
//  DouYin
//
//  Created by Niu Changming on 28/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class LiveCollectionCellHeader: ReusableViewFromXib {
    @IBOutlet weak var userInfoContainer: UIView!
    @IBOutlet weak var avatarIV: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var viewerAmountLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    @IBOutlet weak var followerContainer: UIScrollView!
    @IBOutlet weak var coinContainer: UIView!
    @IBOutlet weak var coinAmountLbl: UILabel!
    
    public var live = Live() {
        didSet{
            self.avatarIV.setURLImageWithURL(url: URL(string: "http://store.happytifyaged.com/uploads/2/1A/21A7465979.jpeg")!, placeHoldImage: UIImage.init(named: "placeholder")!, isCircle: true)
            self.nameLbl.text = "笔墨写春秋"
            self.viewerAmountLbl.text = "23281"
        
            let gradientLayer : CAGradientLayer = Utils.makeGradientColor(for: self.followBtn, startColor: UIColor(hexString: Constants.ColorScheme.redColor), endColor: UIColor(hexString: Constants.ColorScheme.orangeColor))
            gradientLayer.cornerRadius = self.followBtn.frame.size.height / 2
            self.followBtn.layer.insertSublayer(gradientLayer, below: followBtn.imageView?.layer)
            
            self.coinContainer.clipsToBounds = true
            self.coinContainer.layer.cornerRadius = self.coinContainer.frame.size.height / 2
            
            self.coinAmountLbl.text = "213123"
        }
    }
    
    @IBAction func followBtnClicked(_ sender: UIButton) {
        
    }
   
}










