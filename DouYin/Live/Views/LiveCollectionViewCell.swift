//
//  LiveCollectionViewCell.swift
//  DouYin
//
//  Created by Niu Changming on 29/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import KSYMediaPlayer

class LiveCollectionViewCell: UICollectionViewCell {
    
    var controller = UIViewController()
    
    fileprivate var placeHolderView = UIImageView()
    fileprivate var liveLink : String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
    }
    
    override func layoutSubviews() {
        placeHolderView.frame = self.contentView.frame
        placeHolderView.contentMode = .scaleAspectFill
        self.contentView.addSubview(placeHolderView)
        
        self.moviePlayer.view.frame = self.contentView.bounds
        self.bottomView.frame = CGRect.init(x: 0, y: self.contentView.frame.size.height-54, width: self.contentView.frame.size.width, height: 44)
//        self.headerView.frame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: 110)
    }
    
    //显示数据
    public var liveData = Live() {
        didSet {
            self.playWithLive(liveLink: (liveData.info?.stream_addr)!, placeHolderUrl: URL.init(string: (liveData.info?.creator?.portrait)!)!)
//            self.headerView.setLivess = setlivHotData
        }
    }
    
    //开始直播
    fileprivate func playWithLive(liveLink:String, placeHolderUrl:URL) {
        self.liveLink = liveLink
        self.contentView.insertSubview(self.placeHolderView, aboveSubview: self.moviePlayer.view)
        self.removeMovieNotificationObservers()
        
        //占位图片
        self.placeHolderView.setImageViewBlur(url: placeHolderUrl, float: 0.7)
        
        self.contentView.insertSubview(self.moviePlayer.view, at: 0)
        
        addObserveForMoviePlayer() //添加监听
        
        setupBottomView() //底部视图方法监听
    }
    
    //底部视图按钮的点击block
    fileprivate func setupBottomView() {
        
        self.bottomView.bottomViewBtnClickBlock = {
            [unowned self] (LivingBottomViewBtnClickType) -> Void in
            switch LivingBottomViewBtnClickType {
            case .hotMessageType:

                break
            case .hot_e_mailClickType:

                break
            case .hot_giftClickType:

                break
            case .hot_shareClickType:

                break
            case .hot_gobackClickType:
                self.controller.dismiss(animated: true, completion: nil)
                self.playStop()
                break
            }
        }
    }
    
    //MARK: 四个通知方法
    @objc fileprivate func loadStateDidChange(notification:Notification) {
    
        if  (UInt8(MPMovieLoadState.playthroughOK.rawValue) & UInt8(self.moviePlayer.loadState.rawValue) != 0){
            if !self.moviePlayer.isPlaying() {
                self.moviePlayer.play()
                //粒子动画开始
                self.emitterLayer.isHidden = false
                
                let delay = DispatchTime.now() + .seconds(1)
                DispatchQueue.main.asyncAfter(deadline: delay, execute: {
                    self.placeHolderView.removeFromSuperview()
                })
            }
        }
    }
    
    @objc fileprivate func moviePlayBackFinish(notification:Notification) {
        //播放结束时,或者是用户退出时会触发
    }
    
    @objc fileprivate func mediaIsPreparedToPlayDidChange(notification:Notification) {
        print("mediaIsPrepareToPlayDidChange")
    }
    
    @objc fileprivate func moviePlayBackStateDidChange(notification:Notification) {
        
        switch self.moviePlayer.playbackState {
            
        case MPMoviePlaybackState.stopped:
            print("stopped--:\n\(self.moviePlayer.playbackState)")
            break
        case MPMoviePlaybackState.playing:
            print("playing--:\n\(self.moviePlayer.playbackState)")
            break
        case MPMoviePlaybackState.paused:
            print("paused--:\n\(self.moviePlayer.playbackState)")
            break
        case MPMoviePlaybackState.interrupted:
            print("interrupted--:\n\(self.moviePlayer.playbackState)")
            break
        case MPMoviePlaybackState.seekingForward:
            print("seekingForward--:\n\(self.moviePlayer.playbackState)")
            break
        case MPMoviePlaybackState.seekingBackward:
            print("seekingBackward--:\n\(self.moviePlayer.playbackState)")
            break
            
        }
    }
    
    //页面离开后删除所有通知和方法
    public func playStop() {
        self.moviePlayer.pause()
        self.moviePlayer.stop()
        self.emitterLayer.removeFromSuperlayer()
        self.removeFromSuperview()
        
        removeMovieNotificationObservers()
        NotificationCenter.default.removeObserver(self)
    }
    
    /** 添加全部通知 */
    fileprivate func addObserveForMoviePlayer() {
        DispatchQueue(label: "com.nsnotifica", qos: .userInitiated, attributes: .concurrent, autoreleaseFrequency: .workItem, target: nil).async {
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.loadStateDidChange(notification:)), name: NSNotification.Name.MPMoviePlayerLoadStateDidChange, object: self.moviePlayer)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.moviePlayBackFinish(notification:)), name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: self.moviePlayer)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.mediaIsPreparedToPlayDidChange(notification:)), name: NSNotification.Name.MPMediaPlaybackIsPreparedToPlayDidChange, object: self.moviePlayer)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.moviePlayBackStateDidChange(notification:)), name: NSNotification.Name.MPMoviePlayerPlaybackStateDidChange, object: self.moviePlayer)
        
        }
    }
    
    /** 释放全部通知 */
    fileprivate func removeMovieNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.MPMoviePlayerLoadStateDidChange, object: moviePlayer)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.MPMoviePlayerPlaybackDidFinish, object: moviePlayer)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.MPMediaPlaybackIsPreparedToPlayDidChange, object: moviePlayer)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.MPMoviePlayerPlaybackStateDidChange, object: moviePlayer)
    }
    
    //MARK: 懒加载各种载体
    /** 直播播放器*/
    fileprivate lazy var moviePlayer: KSYMoviePlayerController = {
        let movie = KSYMoviePlayerController.init(contentURL: URL.init(string: self.liveLink))
        movie?.scalingMode = MPMovieScalingMode.aspectFill
        movie?.shouldAutoplay = false
        movie?.prepareToPlay()
        return movie!
    }()

    /** 粒子动画*/
    fileprivate lazy var emitterLayer: CAEmitterLayer = {
        let emitter = CAEmitterLayer.init()
        //发射器在xy平面的中心位置
        emitter.emitterPosition = CGPoint.init(x: self.moviePlayer.view.frame.size.width - 50, y: self.moviePlayer.view.frame.size.height - 50)
        //发射器尺寸
        emitter.emitterSize = CGSize.init(width: 20, height: 20)
        //渲染模式
        emitter.renderMode = kCAEmitterLayerUnordered;
        
        var emitterCellArr = [CAEmitterCell]()
        //创建粒子
        for i in 1 ..< 10 {
            let cell = CAEmitterCell.init() //发射单元
            cell.birthRate = 1 //粒子速率 默认1/s
            cell.lifetime = Float(arc4random_uniform(4) + 1) //粒子存活时间
            cell.lifetimeRange = 1.5 //粒子生存时间容差
            let image = UIImage.init(named: String.init(format: "good%d_30x30_", i)) //粒子显示内容
            cell.contents = image?.cgImage
            cell.velocity = CGFloat(arc4random_uniform(100) + 100)//粒子运动速度
            cell.velocityRange = 80 //粒子运动速度容差
            //粒子在xy平面的发射角度
            cell.emissionLongitude = 4.6
            cell.emissionRange = 0.3 //发射角度容差
            cell.scale = 0.3 //缩放比例
            emitterCellArr.append(cell)
        }
        emitter.emitterCells = emitterCellArr
        self.moviePlayer.view.layer.addSublayer(emitter)
        
        return emitter
    }()
    
    lazy var bottomView: LiveCollectionCellBottom = {
        let bView = LiveCollectionCellBottom.instanceFromNib()
        bView.backgroundColor = UIColor.clear
        self.contentView.addSubview(bView)
        return bView
    }()

//    lazy var headerView: NDHotCellHeaderView = {
//        let HView = NDHotCellHeaderView.instanceFromNib()
//        HView.backgroundColor = UIColor.clear
//        self.contentView.addSubview(HView)
//        return HView
//    }()

    deinit {
        print("dealloc方法被调用")
        self.playStop()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
