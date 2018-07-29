//
//  WorkDetailVC.swift
//  DouYin
//
//  Created by Niu Changming on 22/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import KSYMediaPlayer

class WorkDetailVC: UIViewController, PlayerScrollViewDelegate{
    
    var works:[Work] = [Work]()
    var playScrollView: PlayScrollView!
    var userInfoView: UIView!
    var index: NSInteger = 0
    var avatarIV: UIImageView!
    var usernameLbl: UILabel!
    var followBtn: UIButton!
    var likeBtn: UIButton!
    var commentBtn: UIButton!
    var shareBtn: UIButton!
    var dismissBtn: UIButton!
    var titleLbl: UILabel!
    var descriLbl: UILabel!
    var cateLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initPlayer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelStatusBar
        playScrollView?.middlePlayer?.play()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelNormal
    }
    
    func initUI() {
        let rect: CGRect = CGRect(x: 0, y: 0, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
        self.view.frame = rect
        
        playScrollView = PlayScrollView(frame: self.view.frame)
        playScrollView?.playerDelegate = self
        playScrollView?.index = self.index;
        playScrollView?.updateForLives(livesArray: works, index: self.index)
        
        self.view.addSubview(playScrollView!)
        
        userInfoView = UIView(frame: CGRect(x: Constants.Dimension.MARGIN_NOR, y: Constants.Dimension.TOP_SPACE +  Constants.Dimension.MARGIN_NOR, width: 200 * Constants.Dimension.W_RATIO, height: 36 * Constants.Dimension.H_RATIO))
        userInfoView?.alpha = 0.5
        userInfoView?.layer.cornerRadius = (userInfoView?.bounds.size.height)! / 2.0
        userInfoView?.clipsToBounds = true
        userInfoView?.backgroundColor = UIColor(hexString: Constants.ColorScheme.blackColor)
        self.view.addSubview(userInfoView!)
        
        avatarIV = UIImageView(frame: CGRect(x: Constants.Dimension.MARGIN_NOR, y: Constants.Dimension.TOP_SPACE + Constants.Dimension.MARGIN_NOR, width: (userInfoView?.frame.size.height)!, height: (userInfoView?.frame.size.height)!))
        avatarIV.layer.cornerRadius = avatarIV.bounds.size.height / 2.0
        avatarIV.clipsToBounds = true
        avatarIV.sd_setImage(with: URL(string: "https://image.pearvideo.com/node/2672-10944129-logo.png"), placeholderImage: UIImage(named: "placeholder.png"))
        self.view?.addSubview(avatarIV)
        
        followBtn = UIButton(type: .custom)
        followBtn.autoresizingMask = [.flexibleRightMargin, .flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin]
        followBtn.frame = CGRect(x: (userInfoView?.frame.origin.x)! + (userInfoView?.frame.size.width)! - 50 * Constants.Dimension.W_RATIO - 4*Constants.Dimension.H_RATIO,
                              y: Constants.Dimension.TOP_SPACE + Constants.Dimension.MARGIN_NOR + 4*Constants.Dimension.H_RATIO,
                              width: 50 * Constants.Dimension.W_RATIO,
                              height: 28*Constants.Dimension.H_RATIO)
        followBtn.setTitle("关注", for: UIControlState.normal)
        followBtn.subviews.first?.contentMode = .scaleAspectFit
        
        let gradientLayer : CAGradientLayer = Utils.makeGradientColor(for: self.followBtn, startColor: UIColor(hexString: Constants.ColorScheme.redColor), endColor: UIColor(hexString: Constants.ColorScheme.orangeColor))
        gradientLayer.cornerRadius = followBtn.frame.size.height / 2
        followBtn.layer.insertSublayer(gradientLayer, below: followBtn.imageView?.layer)
        self.view?.addSubview(followBtn)
        
        usernameLbl = UILabel(frame: CGRect(x: Constants.Dimension.MARGIN_NOR + avatarIV.frame.size.width + Constants.Dimension.MARGIN_SMALL,
                                            y: Constants.Dimension.TOP_SPACE + Constants.Dimension.MARGIN_NOR,
                                            width: (userInfoView?.frame.origin.x)! + (userInfoView?.frame.size.width)! - 50 * Constants.Dimension.W_RATIO - 4*Constants.Dimension.H_RATIO - Constants.Dimension.MARGIN_SMALL,
                                            height: 36 * Constants.Dimension.H_RATIO))
        usernameLbl.textColor = UIColor.white
        usernameLbl.font = UIFont.systemFont(ofSize: Constants.Dimension.TEXT_SIZE_NOR)
        usernameLbl.text = "张三～小白鼠"
        self.view.addSubview(usernameLbl)
        
        
        cateLbl = UILabel(frame: CGRect(x: Constants.Dimension.MARGIN_LARGE,
                                        y: self.view.frame.size.height - 102*Constants.Dimension.H_RATIO - 3*Constants.Dimension.MARGIN_MIDDLE,
                                        width: 50 * Constants.Dimension.W_RATIO,
                                        height: 24 * Constants.Dimension.H_RATIO))
        cateLbl.font = UIFont.systemFont(ofSize: Constants.Dimension.TEXT_SIZE_NOR)
        cateLbl.textColor = UIColor.white
        cateLbl.text = "热门"
        cateLbl?.layer.cornerRadius = 8.0
        cateLbl.textAlignment = .center
        cateLbl?.clipsToBounds = true
        cateLbl.font = UIFont.boldSystemFont(ofSize: Constants.Dimension.TEXT_SIZE_NOR)
        cateLbl.backgroundColor = UIColor(hexString: Constants.ColorScheme.redColor)
        self.view.addSubview(cateLbl)
        
        titleLbl = UILabel()
        titleLbl.font = UIFont.systemFont(ofSize: Constants.Dimension.TEXT_SIZE_NOR)
        titleLbl.textColor = UIColor.white
        titleLbl.text = "  @にっぽんご/にほん  "
        titleLbl.backgroundColor = UIColor(hexString: Constants.ColorScheme.blackColor).withAlphaComponent(0.5)
        titleLbl?.layer.cornerRadius = 8.0
        titleLbl?.clipsToBounds = true
        titleLbl.numberOfLines = 0;
        titleLbl.frame = CGRect(x: Constants.Dimension.MARGIN_LARGE,
                                y: self.view.frame.size.height - 78*Constants.Dimension.H_RATIO - 2*Constants.Dimension.MARGIN_MIDDLE,
                                width: 200 * Constants.Dimension.W_RATIO,
                                height: 24 * Constants.Dimension.H_RATIO)
        titleLbl.font = UIFont.systemFont(ofSize: Constants.Dimension.TEXT_SIZE_NOR)
        titleLbl.sizeToFit()
        self.view.addSubview(titleLbl)
        
        descriLbl = UILabel()
        descriLbl.font = UIFont.systemFont(ofSize: Constants.Dimension.TEXT_SIZE_NOR)
        descriLbl.textColor = UIColor.white
        descriLbl.text = "  にっぽんご/にほんにっぽんご/にほん  にっぽんご/にほん  "
        descriLbl?.layer.cornerRadius = 8.0
        descriLbl?.clipsToBounds = true
        descriLbl.numberOfLines = 0;
        descriLbl.frame = CGRect(x: Constants.Dimension.MARGIN_LARGE,
                                y: self.view.frame.size.height - 54*Constants.Dimension.H_RATIO - 2*Constants.Dimension.MARGIN_MIDDLE,
                                width: 200 * Constants.Dimension.W_RATIO,
                                height: 40 * Constants.Dimension.H_RATIO)
        self.view.addSubview(descriLbl)
        
        likeBtn = UIButton(type: .custom)
        likeBtn.frame = CGRect(x: Constants.Dimension.SCREEN_WIDTH - 40*Constants.Dimension.H_RATIO - Constants.Dimension.MARGIN_LARGE,
                                 y: Constants.Dimension.SCREEN_HEIGHT - 180*Constants.Dimension.H_RATIO - 3*Constants.Dimension.MARGIN_LARGE,
                                 width: 40*Constants.Dimension.H_RATIO,
                                 height: 40*Constants.Dimension.H_RATIO + 15*Constants.Dimension.H_RATIO)
        likeBtn.subviews.first?.contentMode = .scaleAspectFit
        likeBtn.setImage(UIImage(named: "heart"), for: UIControlState.normal)
        likeBtn.setImage(UIImage(named: "heart_red"), for: UIControlState.highlighted)
        likeBtn.setTitle("212", for: UIControlState.normal)
        likeBtn.setTitleColor(.white, for: UIControlState.normal)
        likeBtn.setTitleColor(UIColor(hexString: Constants.ColorScheme.redColor), for: UIControlState.highlighted)
        likeBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 15*Constants.Dimension.H_RATIO, right: 0)
        likeBtn.titleEdgeInsets = UIEdgeInsets(top: 40*Constants.Dimension.H_RATIO, left: -80*Constants.Dimension.H_RATIO, bottom: 0, right: 0)
        self.view.addSubview(likeBtn)
        
        commentBtn = UIButton(type: .custom)
        commentBtn.frame = CGRect(x: Constants.Dimension.SCREEN_WIDTH - 40*Constants.Dimension.H_RATIO - Constants.Dimension.MARGIN_LARGE,
                               y: likeBtn.frame.origin.y + likeBtn.frame.size.height + Constants.Dimension.MARGIN_LARGE,
                               width: 40*Constants.Dimension.H_RATIO,
                               height: 40*Constants.Dimension.H_RATIO + 15*Constants.Dimension.H_RATIO)
        commentBtn.subviews.first?.contentMode = .scaleAspectFit
        commentBtn.setImage(UIImage(named: "cicle_comment"), for: UIControlState.normal)
        commentBtn.setImage(UIImage(named: "cicle_comment_sel"), for: UIControlState.highlighted)
        commentBtn.setTitle("1231", for: UIControlState.normal)
        commentBtn.setTitleColor(.white, for: UIControlState.normal)
        commentBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 15*Constants.Dimension.H_RATIO, right: 0)
        commentBtn.titleEdgeInsets = UIEdgeInsets(top: 40*Constants.Dimension.H_RATIO, left: -80*Constants.Dimension.H_RATIO, bottom: 0, right: 0)
        self.view.addSubview(commentBtn)
        
        shareBtn = UIButton(type: .custom)
        shareBtn.frame = CGRect(x: Constants.Dimension.SCREEN_WIDTH - 40*Constants.Dimension.H_RATIO - Constants.Dimension.MARGIN_LARGE,
                                  y: commentBtn.frame.origin.y + commentBtn.frame.size.height + Constants.Dimension.MARGIN_LARGE,
                                  width: 40*Constants.Dimension.H_RATIO,
                                  height: 40*Constants.Dimension.H_RATIO)
        shareBtn.subviews.first?.contentMode = .scaleAspectFit
        shareBtn.setImage(UIImage(named: "share"), for: UIControlState.normal)
        shareBtn.setImage(UIImage(named: "share_sel"), for: UIControlState.highlighted)
        self.view.addSubview(shareBtn)
        
        dismissBtn = UIButton(type: .custom)
        dismissBtn.frame = CGRect(x: Constants.Dimension.SCREEN_WIDTH - 40*Constants.Dimension.H_RATIO - Constants.Dimension.MARGIN_LARGE,
                                y: Constants.Dimension.TOP_SPACE +  Constants.Dimension.MARGIN_NOR,
                                width: 40*Constants.Dimension.H_RATIO,
                                height: 40*Constants.Dimension.H_RATIO)
        dismissBtn.subviews.first?.contentMode = .scaleAspectFit
        dismissBtn.setImage(UIImage(named: "cross"), for: UIControlState.normal)
        dismissBtn.setImage(UIImage(named: "cross_sel"), for: UIControlState.highlighted)
        dismissBtn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        self.view.addSubview(dismissBtn)
    }
    
    @objc func dismiss(sender: UIButton!){
        self.playScrollView.middlePlayer?.pause();
        self.playScrollView.middlePlayer?.stop();
        
        self.playScrollView.upperPlayer?.pause();
        self.playScrollView.upperPlayer?.stop();
        
        self.playScrollView.downPlayer?.pause();
        self.playScrollView.downPlayer?.stop();
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func initPlayer(){
        NotificationCenter.default.addObserver(self, selector: #selector(handlePlayerNotify(notify:)), name: NSNotification.Name.MPMoviePlayerFirstVideoFrameRendered, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePlayerPreparedToPlayNotify(notify:)), name: NSNotification.Name.MPMediaPlaybackIsPreparedToPlayDidChange, object: nil)
    }
    
    @objc func handlePlayerPreparedToPlayNotify(notify: NSNotification){
        
        let cor: KSYMoviePlayerController = notify.object as! KSYMoviePlayerController
        
        switch cor.view.tag {
        case 10001:
            if(playScrollView?.upperPlayer?.view.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
                playScrollView?.upperPlayer?.play()
            }
            break
        case 10002:
            if(playScrollView?.middlePlayer?.view.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
                playScrollView?.middlePlayer?.play()
            }
            break
        case 10003:
            if(playScrollView?.downPlayer?.view.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
                playScrollView?.downPlayer?.play()
            }
            break
        default:
            break
        }
    }
    
    @objc func handlePlayerNotify(notify: NSNotification){
        
        let cor: KSYMoviePlayerController = notify.object as! KSYMoviePlayerController
        
        switch cor.view.tag {
        case 10001:
            if(playScrollView?.upperPlayer?.view.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
                playScrollView?.upperPlayer?.view.isHidden = false
            }
            break
        case 10002:
            if(playScrollView?.middlePlayer?.view.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
                playScrollView?.middlePlayer?.view.isHidden = false
            }
            break
        case 10003:
            if(playScrollView?.downPlayer?.view.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
                playScrollView?.downPlayer?.view.isHidden = false
            }
            break
        default:
            break
        }
    }

}

extension WorkDetailVC{
    func playerScrollView(playerScrollView: PlayScrollView, index: NSInteger) {
        
        if(self.index==index){
            return
        }
        
        if(playerScrollView.upperPlayer?.view.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
            playerScrollView.upperPlayer?.view.isHidden = true
            if(playerScrollView.upperPlayer?.isPreparedToPlay)!{
                if(Double((playerScrollView.upperPlayer?.currentPlaybackTime)!) > 0.1){
                    playerScrollView.upperPlayer?.view.isHidden = false
                }
                playerScrollView.upperPlayer?.play()
            }

            playerScrollView.middlePlayer?.pause()
            playerScrollView.downPlayer?.pause()
            playerScrollView.middlePlayer?.view.isHidden = true
            playerScrollView.downPlayer?.view.isHidden = true
        }
        
        
        if(playerScrollView.middlePlayer?.view.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
            playerScrollView.middlePlayer?.view.isHidden = true
            
            if(playerScrollView.middlePlayer?.isPreparedToPlay)!{
                if(Double((playerScrollView.middlePlayer?.currentPlaybackTime)!) > 0.1){
                    playerScrollView.middlePlayer?.view.isHidden = false
                }
                playerScrollView.middlePlayer?.play()
            }
            
            playerScrollView.upperPlayer?.pause()
            playerScrollView.downPlayer?.pause()
            playerScrollView.upperPlayer?.view.isHidden = true
            playerScrollView.downPlayer?.view.isHidden = true
        }
        
        if(playerScrollView.downPlayer?.view.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
            playerScrollView.downPlayer?.view.isHidden = true
            
            if(playerScrollView.downPlayer?.isPreparedToPlay)!{
                if(Double((playerScrollView.downPlayer?.currentPlaybackTime)!) > 0.1){
                    playerScrollView.downPlayer?.view.isHidden = false
                }
                playerScrollView.downPlayer?.play()
            }
            
            playerScrollView.upperPlayer?.pause()
            playerScrollView.middlePlayer?.pause()
            playerScrollView.upperPlayer?.view.isHidden = true
            playerScrollView.middlePlayer?.view.isHidden = true
        }
        self.index = index
    }
}
