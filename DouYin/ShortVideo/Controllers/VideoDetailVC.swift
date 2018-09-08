//
//  WorkDetailVC.swift
//  DouYin
//
//  Created by Niu Changming on 22/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import KSYMediaPlayer
import IQKeyboardManagerSwift

class VideoDetailVC: UIViewController{
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
    var tmpVideo: Video?
    
    lazy var chatInputBar: ChatInputBar = {
        let chatInputBar = ChatInputBar(frame: CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 48))
        chatInputBar.delegate = self
        self.view.addSubview(chatInputBar)
        return chatInputBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelStatusBar
        NotificationCenter.default.addObserver(self, selector: #selector(VideoDetailVC.handlePlayerNotify(notify:)), name: NSNotification.Name.MPMoviePlayerFirstVideoFrameRendered, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(VideoDetailVC.handlePlayerPreparedToPlayNotify(notify:)), name: NSNotification.Name.MPMediaPlaybackIsPreparedToPlayDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(VideoDetailVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(VideoDetailVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        IQKeyboardManager.shared.enable = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DBUtils.share.saveContext()
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
    
    @objc func handlePlayerPreparedToPlayNotify(notify: NSNotification){
        let cor: KSYMoviePlayerController = notify.object as! KSYMoviePlayerController
        
        switch cor.view.tag {
        case 10001:
            if(playScrollView.upperPlayer.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
                playScrollView.upperPlayer.videoPlayer.play()
                playScrollView.currentPlayerView = playScrollView.upperPlayer
            }
            break
        case 10002:
            if(playScrollView.middlePlayer.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
                playScrollView.middlePlayer.videoPlayer.play()
                playScrollView.currentPlayerView = playScrollView.middlePlayer
            }
            break
        case 10003:
            if(playScrollView.downPlayer.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT){
                playScrollView.downPlayer.videoPlayer.play()
                playScrollView.currentPlayerView = playScrollView.downPlayer
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
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        guard let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight: CGFloat = keyboardFrame.cgRectValue.height
        let animationTime: TimeInterval = userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as! TimeInterval
        
        
        UIView.animate(withDuration: animationTime, animations: { () -> Void in
            self.chatInputBar.transform = CGAffineTransform(translationX: 0, y: -self.chatInputBar.frame.size.height-keyboardHeight)
        })
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let animationTime: TimeInterval = userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as! TimeInterval
        
        UIView.animate(withDuration: animationTime, animations: { () -> Void in
            self.chatInputBar.transform = CGAffineTransform.identity
        })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared.enable = true
        UIApplication.shared.keyWindow?.windowLevel = UIWindowLevelNormal
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

}

extension VideoDetailVC: PlayerScrollViewDelegate{
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
                playerScrollView.currentPlayerView = playerScrollView.upperPlayer
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
                playerScrollView.currentPlayerView = playerScrollView.middlePlayer
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
                playerScrollView.currentPlayerView = playerScrollView.downPlayer
            }
            
            playerScrollView.upperPlayer.videoPlayer.pause()
            playerScrollView.middlePlayer.videoPlayer.pause()
            playerScrollView.upperPlayer.isHidden = true
            playerScrollView.middlePlayer.isHidden = true
        }
        self.currentIndex = index
    }
}

extension VideoDetailVC: ChatInputBarDelegate{
    func send() {
        guard let video = self.tmpVideo else { return }
        
        self.chatInputBar.commentResource(resource: video) { (video, error) in
            guard let v = video, let playView = self.playScrollView.currentPlayerView  else { return }

            DispatchQueue.main.async {
                playView.commentAmountLbl.text = String((v as! Video).commentCount)
            }
            
            self.chatInputBar.messageInputTv.resignFirstResponder()
        }
        
    }
}
