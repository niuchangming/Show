//
//  GiftCollectionViewCell.swift
//  DouYin
//
//  Created by Niu Changming on 15/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

class GiftCollectionViewCell: UICollectionViewCell {
    public var gift: Gift = Gift(){
        didSet{
            updateGift()
        }
    }

    fileprivate var bgView = UIView()
    fileprivate var giftImageView = UIImageView()
    fileprivate var giftNameLabel = UILabel()
    fileprivate var moneyLabel = UILabel()
    fileprivate var moneyImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    func initUI()  {
        self.bgView.frame = self.bounds
        self.bgView.backgroundColor = UIColor.clear
        self.contentView.addSubview(self.bgView)
        
        self.giftImageView.frame = CGRect(x: (self.bounds.size.width-70)*0.5, y: 11, width: 70, height: 55)
        self.giftImageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(self.giftImageView)
        
        self.giftNameLabel.frame = CGRect(x: 0, y: self.giftImageView.frame.maxY, width: self.bounds.size.width, height: 16)
        self.giftNameLabel.text = "礼物名"
        self.giftNameLabel.textColor = UIColor.white
        self.giftNameLabel.textAlignment = .center
        self.giftNameLabel.font = UIFont.systemFont(ofSize: Constants.Dimension.TEXT_SIZE_EXTRA_SMALL)
        self.addSubview(self.giftNameLabel)
        
        self.moneyLabel.frame = CGRect(x: 0, y: self.giftNameLabel.frame.maxY, width: 30, height: 16)
        self.moneyLabel.textAlignment = .center
        self.moneyLabel.textColor = UIColor.white
        self.moneyLabel.font = UIFont.systemFont(ofSize: Constants.Dimension.TEXT_SIZE_EXTRA_SMALL)
        self.contentView.addSubview(self.moneyLabel)
        
        self.moneyImageView.frame = CGRect(x: self.moneyLabel.frame.minX-4, y: self.moneyLabel.frame.minY+4, width: 10, height: 10)
        self.contentView.addSubview(self.moneyImageView)
    }
    
    func updateGift() {
        self.giftImageView.sd_setImage(with: URL(string: gift.image), placeholderImage: UIImage(named: "placeholder"))
        self.giftNameLabel.text = gift.name
        self.bgView.backgroundColor = gift.isSelected ? UIColor(hexString: Constants.ColorScheme.orangeColor) : .clear
        
//        let isCb = Bool(exactly: gift.costType as NSNumber)!
        let moneyImage: UIImage = UIImage(named: "live_cb")!
        self.moneyImageView.image = moneyImage
        
        let moneyValue: String = String(format: "%i", gift.price)
        self.moneyLabel.text = moneyValue
        
        let size: CGSize = moneyValue.size(withAttributes: [NSAttributedStringKey.font: self.moneyLabel.font])
        let w: CGFloat = size.width + 1
        let labelX = (self.contentView.bounds.size.width - w + 4 + 10) * 0.5
        self.moneyLabel.frame = CGRect(x: labelX, y: self.giftNameLabel.frame.maxY, width: w, height: 16)
 
        let imageX: CGFloat = self.moneyLabel.frame.minX - 4 - 10
        self.moneyImageView.frame = CGRect(x: imageX, y: self.moneyLabel.frame.minY + 4, width: 10, height: 10)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
















