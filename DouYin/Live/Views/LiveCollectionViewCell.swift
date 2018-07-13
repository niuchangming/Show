//
//  LiveCollectionViewCell.swift
//  DouYin
//
//  Created by Niu Changming on 29/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import KSYMediaPlayer

class LiveCollectionViewCell: UICollectionViewCell, BambuserPlayerDelegate {
    
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
        
        self.moviePlayer.frame = self.contentView.bounds
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
        self.contentView.insertSubview(self.placeHolderView, aboveSubview: self.moviePlayer)
        self.placeHolderView.setImageViewBlur(url: placeHolderUrl, float: 0.7)
        self.contentView.insertSubview(self.moviePlayer, at: 0)
        
        moviePlayer.playVideo("https://cdn.bambuser.net/broadcasts/6fdd41af-396e-47af-832c-bff55c2f2edc?da_signature_method=HMAC-SHA256&da_id=9e1b1e83-657d-7c83-b8e7-0b782ac9543a&da_timestamp=1531458221&da_static=1&da_ttl=0&da_signature=1856209bec9af2fcf8dd8b40915b265579c8d7a49ff6fbc1781e9723646a9fc9")
        setupBottomView()
    }

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
    
    //页面离开后删除所有通知和方法
    public func playStop() {
        self.moviePlayer.pauseVideo()
        self.moviePlayer.stopVideo()
        self.emitterLayer.removeFromSuperlayer()
        self.removeFromSuperview()
    }
    
    //MARK: 懒加载各种载体
    /** 直播播放器*/
    fileprivate lazy var moviePlayer: BambuserPlayer = {
        let bambuserPlayer: BambuserPlayer = BambuserPlayer()
        bambuserPlayer.applicationId = Constants.BAMBUSER_APP_ID
        bambuserPlayer.videoScaleMode = VideoScaleAspectFill
        bambuserPlayer.delegate = self
        return bambuserPlayer
    }()

    /** 粒子动画*/
    fileprivate lazy var emitterLayer: CAEmitterLayer = {
        let emitter = CAEmitterLayer.init()
        emitter.emitterPosition = CGPoint.init(x: self.moviePlayer.frame.size.width - 50, y: self.moviePlayer.frame.size.height - 50)
        emitter.emitterSize = CGSize.init(width: 20, height: 20)
        emitter.renderMode = kCAEmitterLayerUnordered;
        
        var emitterCellArr = [CAEmitterCell]()
        for i in 1 ..< 10 {
            let cell = CAEmitterCell.init() //发射单元
            cell.birthRate = 1 //粒子速率 默认1/s
            cell.lifetime = Float(arc4random_uniform(4) + 1) //粒子存活时间
            cell.lifetimeRange = 1.5 //粒子生存时间容差
            let image = UIImage.init(named: String.init(format: "good%d_30x30_", i)) //粒子显示内容
            cell.contents = image?.cgImage
            cell.velocity = CGFloat(arc4random_uniform(100) + 100)//粒子运动速度
            cell.velocityRange = 80 //粒子运动速度容差
            cell.emissionLongitude = 4.6 //粒子在xy平面的发射角度
            cell.emissionRange = 0.3 //发射角度容差
            cell.scale = 0.3 //缩放比例
            emitterCellArr.append(cell)
        }
        emitter.emitterCells = emitterCellArr
        self.moviePlayer.layer.addSublayer(emitter)
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
        self.playStop()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LiveCollectionViewCell{
    func playbackStarted() {
        self.emitterLayer.isHidden = false
        let delay = DispatchTime.now() + .seconds(1)
        DispatchQueue.main.asyncAfter(deadline: delay, execute: {
            self.placeHolderView.removeFromSuperview()
        })
    }
    
    func playbackPaused() {
        NSLog("Video Paused")
    }
    
    func playbackStopped() {
        NSLog("Video Stopped")
    }
    
    func videoLoadFail() {
        NSLog("Failed to load video for %@", moviePlayer.resourceUri);
    }
}
