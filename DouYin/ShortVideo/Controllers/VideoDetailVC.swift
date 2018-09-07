//
//  WorkDetailVC.swift
//  DouYin
//
//  Created by Niu Changming on 22/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import KSYMediaPlayer

class VideoDetailVC: UIViewController, PlayerScrollViewDelegate{
    
    var videos:[Video] = [Video]()
    var currentIndex: Int = 0
    var playScrollView: PlayScrollView!
    var userInfoView: UIView!
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
        playScrollView?.index = self.currentIndex
        playScrollView?.setVideos(livesArray: videos, index: self.currentIndex)
        self.view.addSubview(playScrollView!)
    }
    
    @objc func dismiss(sender: UIButton!){
        self.playScrollView.middlePlayer.videoPlayer.pause();
        self.playScrollView.middlePlayer.videoPlayer.stop();
        
        self.playScrollView.upperPlayer.videoPlayer.pause();
        self.playScrollView.upperPlayer.videoPlayer.stop();
        
        self.playScrollView.downPlayer.videoPlayer.pause();
        self.playScrollView.downPlayer.videoPlayer.stop();
        
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
            if(playScrollView.upperPlayer.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
                playScrollView.upperPlayer.videoPlayer.play()
            }
            break
        case 10002:
            if(playScrollView.middlePlayer.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
                playScrollView.middlePlayer.videoPlayer.play()
            }
            break
        case 10003:
            if(playScrollView.downPlayer.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
                playScrollView.downPlayer.videoPlayer.play()
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
            if(playScrollView.upperPlayer.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
                playScrollView.upperPlayer.isHidden = false
            }
            break
        case 10002:
            if(playScrollView.middlePlayer.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
                playScrollView.middlePlayer.isHidden = false
            }
            break
        case 10003:
            if(playScrollView.downPlayer.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
                playScrollView.downPlayer.isHidden = false
            }
            break
        default:
            break
        }
    }

}

extension VideoDetailVC{
    func playerScrollView(playerScrollView: PlayScrollView, index: NSInteger) {

        if(self.currentIndex==index){
            return
        }
        
        if(playerScrollView.upperPlayer.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
            playerScrollView.upperPlayer.isHidden = true
            if playerScrollView.upperPlayer.videoPlayer.isPreparedToPlay {
                if(Double((playerScrollView.upperPlayer.videoPlayer.currentPlaybackTime)) > 0.1){
                    playerScrollView.upperPlayer.isHidden = false
                }
                playerScrollView.upperPlayer.videoPlayer.play()
            }

            playerScrollView.middlePlayer.videoPlayer.pause()
            playerScrollView.downPlayer.videoPlayer.pause()
            playerScrollView.middlePlayer.isHidden = true
            playerScrollView.downPlayer.isHidden = true
        }
        
        if(playerScrollView.middlePlayer.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
            playerScrollView.middlePlayer.isHidden = true
            
            if playerScrollView.middlePlayer.videoPlayer.isPreparedToPlay {
                if(Double((playerScrollView.middlePlayer.videoPlayer.currentPlaybackTime)) > 0.1){
                    playerScrollView.middlePlayer.isHidden = false
                }
                playerScrollView.middlePlayer.videoPlayer.play()
            }
            
            playerScrollView.upperPlayer.videoPlayer.pause()
            playerScrollView.downPlayer.videoPlayer.pause()
            playerScrollView.upperPlayer.isHidden = true
            playerScrollView.downPlayer.isHidden = true
        }
        
        if(playerScrollView.downPlayer.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
            playerScrollView.downPlayer.isHidden = true
            
            if playerScrollView.downPlayer.videoPlayer.isPreparedToPlay {
                if(Double((playerScrollView.downPlayer.videoPlayer.currentPlaybackTime)) > 0.1){
                    playerScrollView.downPlayer.isHidden = false
                }
                playerScrollView.downPlayer.videoPlayer.play()
            }
            
            playerScrollView.upperPlayer.videoPlayer.pause()
            playerScrollView.middlePlayer.videoPlayer.pause()
            playerScrollView.upperPlayer.isHidden = true
            playerScrollView.middlePlayer.isHidden = true
        }
        self.currentIndex = index
    }
}
