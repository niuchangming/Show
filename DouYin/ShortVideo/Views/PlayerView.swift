//
//  PlayerView.swift
//  DouYin
//
//  Created by Niu Changming on 7/9/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import KSYMediaPlayer
import CoreData

class PlayerView: ReusableViewFromXib {

    var video: Video!{
        didSet{
            updateValue()
        }
    }
    
    @IBOutlet weak var followLoadingBar: UIActivityIndicatorView!
    
    
    lazy var videoPlayer: KSYMoviePlayerController = {
        let videoPlayer = KSYMoviePlayerController()
        videoPlayer.view.backgroundColor = UIColor.clear
        videoPlayer.bufferSizeMax = 1
        videoPlayer.view.autoresizesSubviews = true
        videoPlayer.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        videoPlayer.shouldAutoplay = true
        videoPlayer.shouldLoop = true
        videoPlayer.scalingMode = .aspectFill
        self.customView?.insertSubview(videoPlayer.view, at: 0)
        return videoPlayer
    }()
    
    @IBOutlet weak var creatorInfoContainer: UIView!{
        didSet{
            creatorInfoContainer.layer.cornerRadius = creatorInfoContainer.bounds.size.height / 2.0
            creatorInfoContainer.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var categoryLbl: UILabel!{
        didSet{
            categoryLbl.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
            categoryLbl.clipsToBounds = true
            categoryLbl.backgroundColor = UIColor(hexString: Constants.ColorScheme.redColor)
        }
    }
    @IBOutlet weak var creatorAvatarIv: UIImageView!{
        didSet{
            creatorAvatarIv.layer.cornerRadius = creatorAvatarIv.bounds.size.height / 2.0
            creatorAvatarIv.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var headeView: UIView!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var creatorNameLbl: UILabel!
    @IBOutlet weak var shareAmountLbl: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var favoriteAmountLbl: UILabel!
    @IBOutlet weak var likeAmountLbl: UILabel!
    @IBOutlet weak var commentAmountLbl: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var likeBtn: UIButton!
    @IBOutlet weak var commentBtn: UIButton!
    @IBOutlet weak var followBtn: UIButton!{
        didSet{
            let gradientLayer : CAGradientLayer = Utils.makeGradientColor(for: self.followBtn, startColor: UIColor(hexString: Constants.ColorScheme.redColor), endColor: UIColor(hexString: Constants.ColorScheme.orangeColor))
            gradientLayer.cornerRadius = followBtn.frame.size.height / 2
            followBtn.layer.insertSublayer(gradientLayer, below: followBtn.imageView?.layer)
        }
    }
    override init(frame: CGRect) {
        super.init(frame:frame)

    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }

    func updateValue(){
        if let avatar = video.creator?.avatar {
            creatorAvatarIv.sd_setImage(with: URL(string: avatar.origin), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            creatorAvatarIv.image = UIImage(named: "placeholder.png")
        }
        
        creatorNameLbl.text = video.creator?.name
        likeAmountLbl.text = String(video.likeCount)
        favoriteAmountLbl.text = String(video.favouriteCount)
        commentAmountLbl.text = String(video.commentCount)
        descLbl.text = video.description
        descLbl.sizeToFit()
        
        if DBUtils.share.fetchLike(resourceId: video.resourceId) > 0 {
            self.likeBtn.tag = 1
            self.likeBtn.setImage(UIImage(named: "heart"), for: .normal)
            configBtnColor(hex: Constants.ColorScheme.redColor, button: self.likeBtn)
        }else{
            self.likeBtn.tag = 0
            self.likeBtn.setImage(UIImage(named: "heart_line"), for: .normal)
            configBtnColor(hex: Constants.ColorScheme.whiteColor, button: self.likeBtn)
        }
        
        if DBUtils.share.fetchFavorite(resourceId: video.resourceId) > 0 {
            self.favoriteBtn.tag = 1
            self.favoriteBtn.setImage(UIImage(named: "star_fill"), for: .normal)
            configBtnColor(hex: Constants.ColorScheme.redColor, button: self.favoriteBtn)
        }else{
            self.favoriteBtn.tag = 0
            self.favoriteBtn.setImage(UIImage(named: "star"), for: .normal)
            configBtnColor(hex: Constants.ColorScheme.whiteColor, button: self.favoriteBtn)
        }
    }
    
    
    @IBAction func shareBtnClicked(_ sender: UIButton) {
        
    }
    
    @IBAction func likeBtnClicked(_ sender: UIButton) {
        self.likeBtn.isEnabled = false
        if self.likeBtn.tag == 1 {
            DBUtils.share.unlike(resourceId: video.resourceId) { (status) in
                if (status == .success) {
                    self.video.likeCount = self.video.likeCount - 1
                    self.likeAmountLbl.text = String(self.video.likeCount)
                    self.likeBtn.setImage(UIImage(named: "heart_line"), for: .normal)
                    self.likeBtn.tag = 0
                    self.configBtnColor(hex: Constants.ColorScheme.whiteColor, button: self.likeBtn)
                }
                self.likeBtn.isEnabled = true
            }
        }else{
            DBUtils.share.like(resourceId: video.resourceId) { (status) in
                if (status == .success) {
                    self.video.likeCount = self.video.likeCount + 1
                    self.likeAmountLbl.text = String(self.video.likeCount)
                    self.likeBtn.setImage(UIImage(named: "heart"), for: .normal)
                    self.likeBtn.tag = 1
                    self.configBtnColor(hex: Constants.ColorScheme.redColor, button: self.likeBtn)
                }
                self.likeBtn.isEnabled = true
            }
        }
    }
    
    @IBAction func favoriteBtnClicked(_ sender: UIButton) {
        self.favoriteBtn.isEnabled = false
        if self.favoriteBtn.tag == 1 {
            DBUtils.share.unFavorite(resourceId: video.resourceId) { (status) in
                if (status == .success) {
                    self.video.favouriteCount = self.video.favouriteCount - 1
                    self.favoriteAmountLbl.text = String(self.video.favouriteCount)
                    self.favoriteBtn.setImage(UIImage(named: "star"), for: .normal)
                    self.favoriteBtn.tag = 0
                    self.configBtnColor(hex: Constants.ColorScheme.whiteColor, button: self.favoriteBtn)
                }
                self.favoriteBtn.isEnabled = true
            }
        }else{
            DBUtils.share.favorite(resourceId: video.resourceId) { (status) in
                if (status == .success) {
                    self.video.favouriteCount = self.video.favouriteCount + 1
                    self.favoriteAmountLbl.text = String(self.video.favouriteCount)
                    self.favoriteBtn.setImage(UIImage(named: "star_fill"), for: .normal)
                    self.favoriteBtn.tag = 1
                    self.configBtnColor(hex: Constants.ColorScheme.redColor, button: self.favoriteBtn)
                }
                self.favoriteBtn.isEnabled = true
            }
        }
    }
    
    @IBAction func commentBtnClicked(_ sender: UIButton) {
        let videoDetailVC: VideoDetailVC = Utils.viewController(responder: self) as! VideoDetailVC
        if AuthUtils.share.validate() == .LOGGED && Utils.isNotNil(obj: AuthUtils.share.apiToken()) {
            videoDetailVC.tmpVideo = video
            videoDetailVC.chatInputBar.messageInputTv.becomeFirstResponder()
        }else{
            let loginVC = LoginVC()
            videoDetailVC.present(loginVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func followBtnClicked(_ sender: UIButton) {
        if(AuthUtils.share.validate() == .UNAUTH || Utils.isNotNil(obj: AuthUtils.share.apiToken())){
            let apiFunc: String = sender.titleLabel?.text == "关注" ? "follows/add" : "follows/cancel"
            
            self.followLoadingBar.startAnimating()
            self.followBtn.isHidden = true
            ConnectionManager.shareManager.request(method: .post, url: String(format: "%@%@", Constants.HOST, apiFunc), parames: ["userCode": video.creator?.userCode as AnyObject, "token": AuthUtils.share.apiToken() as AnyObject], succeed: { (responseJson) in
                
                let response = responseJson as! NSDictionary
                let errorCode = response["errorCode"] as! Int
                let message = response["message"] as! String
                if errorCode == 1 {
                    apiFunc == "follows/add" ? (self.followBtn.titleLabel?.text = "取消") : (self.followBtn.titleLabel?.text = "关注")
                }else{
                    let vc: VideoDetailVC = Utils.viewController(responder: self) as! VideoDetailVC
                    Utils.popAlert(title: "Failed", message: message, controller: vc)
                }
                self.followLoadingBar.stopAnimating()
                self.followBtn.isHidden = false
            }) { (error) in
                self.followLoadingBar.stopAnimating()
                self.followBtn.isHidden = false
                print("Follow user error: \(String(describing: error?.localizedDescription))")
            }
        }else {
            let vc: VideoDetailVC = Utils.viewController(responder: self) as! VideoDetailVC
            vc.present(LoginVC(), animated: true, completion: nil)
        }
    }
    
    func configBtnColor(hex: String, button: UIButton){
        button.setImage(button.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = UIColor(hexString: hex)
    }
    
    @IBAction func dismissBtnClicked(_ sender: Any) {
        let vc: VideoDetailVC = Utils.viewController(responder: self) as! VideoDetailVC
        vc.dismiss(sender: sender as! UIButton)
    }
    
}
