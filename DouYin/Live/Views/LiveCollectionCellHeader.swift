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
    
    @IBOutlet weak var coinAmountWidthConst: NSLayoutConstraint!
    public var live = Live() {
        didSet{
            self.avatarIV.setURLImageWithURL(url: URL(string: (live.avatar?.origin)!)!, placeHoldImage: UIImage.init(named: "placeholder")!, isCircle: true)
            self.nameLbl.text = live.nickname
            self.nameLbl.sizeToFit()
            self.viewerAmountLbl.text = String(describing: live.audienceCount)
            self.viewerAmountLbl.sizeToFit()
        
            let gradientLayer : CAGradientLayer = Utils.makeGradientColor(for: self.followBtn, startColor: UIColor(hexString: Constants.ColorScheme.redColor), endColor: UIColor(hexString: Constants.ColorScheme.orangeColor))
            gradientLayer.cornerRadius = self.followBtn.frame.size.height / 2
            self.followBtn.layer.insertSublayer(gradientLayer, below: followBtn.imageView?.layer)
            
            self.coinContainer.clipsToBounds = true
            self.coinContainer.layer.cornerRadius = self.coinContainer.frame.size.height / 2
            
            self.coinAmountLbl.text = String(live.coinAmount)
            self.coinAmountLbl.sizeToFit()
            self.coinAmountWidthConst.constant = self.coinAmountLbl.frame.size.width + Constants.Dimension.MARGIN_SMALL
        }
    }
    
    @IBAction func followBtnClicked(_ sender: UIButton) {
        if(Utils.isNotNil(obj: AuthUtils.share.apiToken())){
            let apiFunc: String = sender.titleLabel?.text == "关注" ? "follows/follow" : "follows/unfollow"
            
            ConnectionManager.shareManager.request(method: .post, url: String(format: "%@%@", Constants.HOST, apiFunc), parames: ["broadcastId": live.id as AnyObject, "token": AuthUtils.share.apiToken() as AnyObject], succeed: { (responseJson) in
                
                let response = responseJson as! NSDictionary
                let errorCode = response["errorCode"] as! Int
                if errorCode == 1 {
                    self.followBtn.titleLabel?.text = "取消"
                }else{
                    self.popupAlert(title: "Failed", message: response["message"] as! String)
                }
            }) { (error) in
                print("Follow user error: \(String(describing: error?.localizedDescription))")
            }
        }
    }
    
    func popupAlert(title: String, message: String){
        let handedVC = Utils.viewController(responder: self)
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        handedVC?.present(alert, animated: true, completion: nil)
    }
   
}










