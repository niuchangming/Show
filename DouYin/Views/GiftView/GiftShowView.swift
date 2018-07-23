//
//  GiftShowView.swift
//  DouYin
//
//  Created by Niu Changming on 16/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

typealias completeShowViewBlock = (_ finished: Bool, _ giftKey: String) -> Void
typealias completeShowViewKeyBlock = (_ giftSend: GiftSend) -> Void

let animationTime: Int = 5;

class GiftShowView: UIView {
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var userIconView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var giftNameLabel: UILabel!
    @IBOutlet weak var giftImageView: UIImageView!
    @IBOutlet weak var countLabel: GiftCountLabel!
    
    var showViewFinishBlock: completeShowViewBlock?
    var showViewKeyBlock: completeShowViewKeyBlock?
    var finishGift: GiftSend?
    var currentGiftCount: Int = 0
    public var giftCount: Int = 0 {
        didSet{
            self.currentGiftCount += giftCount;
            self.countLabel.text = String(format: "x %zd", self.currentGiftCount)
            if self.currentGiftCount > 1 {
                giftAnimation(view: self.countLabel)
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hideGiftShowView), object: nil)
            }
            self.perform(#selector(hideGiftShowView), with: nil, afterDelay: TimeInterval(animationTime))
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    
    func initUI(){
        let giftViewWidth: CGFloat = 9 * Constants.Dimension.SCREEN_WIDTH / 16
        let giftViewHeight: CGFloat = 48
        let gfitViewX: CGFloat = -giftViewWidth
        let gfitViewY: CGFloat = (Constants.Dimension.SCREEN_HEIGHT - giftViewHeight) / 2 - giftViewHeight - Constants.Dimension.MARGIN_NOR
        self.frame = CGRect(x: gfitViewX, y: gfitViewY, width: giftViewWidth, height: giftViewHeight)
    }
    
    override func layoutSubviews() {
        self.bgView.layer.cornerRadius = self.bgView.frame.size.height / 2
        self.userIconView.layer.cornerRadius = self.userIconView.frame.width / 2
        self.userIconView.layer.masksToBounds = true
    }

    func showGiftShowViewWithGift(giftSend: GiftSend, completeBlock: @escaping completeShowViewBlock) {
        self.finishGift = giftSend
        self.userIconView.sd_setImage(with: URL(string: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRlFXHwvOtop39K-5ZGryXy_gLl-UPnNK5dLGgeqRaPTx5RU1Iq-g"), placeholderImage: UIImage(named: "placeholder"))
        self.userNameLabel.text = giftSend.username
        self.giftNameLabel.text = String(format: "送 %@", giftSend.name)
        self.giftImageView.sd_setImage(with: URL(string: giftSend.icon), placeholderImage: UIImage(named: "placeholder"))
        self.isHidden = false
        self.showViewFinishBlock = completeBlock
        
        if(self.currentGiftCount == 0){
            self.showViewKeyBlock?(giftSend)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.frame = CGRect(x: 0, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }, completion: { (finished: Bool) in
            self.currentGiftCount = 0
            self.giftCount = giftSend.defaultCount
        })
        
    }
    
    @objc func hideGiftShowView() {
        UIView.animate(withDuration: 0.3, animations: { () in
            self.frame = CGRect(x: -self.frame.size.width, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }, completion: { (finished: Bool) in
            self.showViewFinishBlock?(true, (self.finishGift?.id)!)
            self.finishGift = nil
            
            self.frame = CGRect(x: -self.frame.size.width, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
            self.isHidden = true
            self.currentGiftCount = 0
            self.countLabel.text = ""
        })
    }
    
    func giftAnimation(view: UIView) {
        let pulse: CABasicAnimation = CABasicAnimation.init(keyPath: "transform.scale")
        pulse.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulse.duration = 0.08
        pulse.repeatCount = 1
        pulse.autoreverses = true
        pulse.fromValue = 1.0
        pulse.toValue = 1.5
        view.layer.add(pulse, forKey: nil)
    }
    
}



























