//
//  PlayerView.swift
//  DouYin
//
//  Created by Niu Changming on 7/9/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import KSYMediaPlayer

class PlayerView: ReusableViewFromXib {

    var video: Video!{
        didSet{
            updateValue()
        }
    }
    
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
    }
    
    
    @IBAction func shareBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func likeBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func favoriteBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func commentBtnClicked(_ sender: Any) {
        
    }
    
    @IBAction func followBtnClicked(_ sender: Any) {
    
    }
    
    @IBAction func dismissBtnClicked(_ sender: Any) {
        let vc: VideoDetailVC = Utils.viewController(responder: self) as! VideoDetailVC
        vc.dismiss(sender: sender as! UIButton)
    }
    
}
