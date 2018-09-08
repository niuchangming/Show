//
//  PlayScrollView.swift
//  DouYin
//
//  Created by Niu Changming on 22/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import KSYMediaPlayer

protocol PlayerScrollViewDelegate {
    func playerScrollView(playerScrollView: PlayScrollView, index: NSInteger)
}

class PlayScrollView: UIScrollView, UIScrollViewDelegate {

    var playerDelegate: PlayerScrollViewDelegate?
    var index: NSInteger?
    var upperImageView, middleImageView, downImageView: UIImageView?
    var upperPlayer, middlePlayer, downPlayer: PlayerView!
    var upperLive, middleLive, downLive: Video!
    var currentIndex: NSInteger = 0
    var previousIndex: NSInteger = 0
    var lives: [Video] = []
    var currentPlayerView: PlayerView?
    
    override init(frame: CGRect) {
       super.init(frame:frame)
        initPlayerView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initPlayerView()
    }
    
    func initPlayerView(){
        contentSize = CGSize(width: 0, height: frame.size.height * 3)
        contentOffset = CGPoint(x: 0, y: frame.size.height)
        isPagingEnabled = true;
        isOpaque = true;
        backgroundColor = UIColor.clear;
        autoresizesSubviews = true;
        showsHorizontalScrollIndicator = false;
        showsVerticalScrollIndicator = false;
        if #available(iOS 11.0, *) {
            contentInsetAdjustmentBehavior = .never;
        }
        delegate = self;
    
        upperImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        upperImageView?.contentMode = .scaleAspectFill
        middleImageView = UIImageView(frame: CGRect(x: 0, y: frame.size.height, width: frame.size.width, height: frame.size.height))
        middleImageView?.contentMode = .scaleAspectFill
        downImageView = UIImageView(frame: CGRect(x: 0, y: frame.size.height*2, width: frame.size.width, height: frame.size.height))
        downImageView?.contentMode = .scaleAspectFill

        self.insertSubview(upperImageView!, at: 0)
        self.insertSubview(middleImageView!, at: 0)
        self.insertSubview(downImageView!, at: 0)
        
        upperPlayer = PlayerView(frame: CGRect(x: 0, y: 0, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT))
        upperPlayer.videoPlayer.view.tag = 10001;
        
        middlePlayer = PlayerView(frame: CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT))
        middlePlayer.videoPlayer.view.tag = 10002;
        
        downPlayer = PlayerView(frame: CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT*2, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT))
        downPlayer.videoPlayer.view.tag = 10003;
        
        self.addSubview(upperPlayer!)
        self.addSubview(middlePlayer!)
        self.addSubview(downPlayer!)
    }
    
    func setVideos(livesArray: [Video], index: NSInteger) -> () {
        if (livesArray.count > 0) {
            lives.removeAll()
            lives = livesArray
            currentIndex = index
            previousIndex = index
            
            upperLive = Video()
            middleLive = lives[currentIndex]
            downLive = Video()
            
            if (currentIndex == 0) {
                upperLive = lives.last
            } else {
                upperLive = lives[currentIndex - 1]
            }
            
            if (currentIndex == lives.count - 1) {
                downLive = lives.first
            } else {
                downLive = lives[currentIndex + 1];
            }
            
            
            prepareForImageView(imageView: upperImageView!, video: upperLive)
            prepareForImageView(imageView: middleImageView!, video: middleLive)
            prepareForImageView(imageView: downImageView!, video: downLive)
            
            prepareForVideo(playerView: upperPlayer, video: upperLive)
            prepareForVideo(playerView: middlePlayer, video: middleLive)
            prepareForVideo(playerView: downPlayer, video: downLive)
        }
    }
    
    func prepareForImageView(imageView: UIImageView, video: Video) {
        if let preview = video.preview{
            imageView.sd_setImage(with: URL(string: preview.origin), placeholderImage: UIImage(named: "placeholder.png"))
        }else{
            imageView.image = UIImage(named: "placeholder.png")
        }
    }
    
    func prepareForVideo(playerView: PlayerView, video: Video) {
        playerView.video = video
        playerView.videoPlayer.reset(false)
        playerView.videoPlayer.setUrl(URL(string: video.resourceUri))
        playerView.videoPlayer.shouldAutoplay = false
        playerView.videoPlayer.bufferSizeMax = 1
        playerView.videoPlayer.shouldLoop = true
        playerView.videoPlayer.view.backgroundColor = UIColor.clear
        playerView.videoPlayer.prepareToPlay()
    }
    
    func switchPlayer(scrollView: UIScrollView) {
        let offset: CGFloat = scrollView.contentOffset.y;
        
        if(lives.count > 0){ // 下一个
            if(offset >= 2 * self.frame.size.height){
                scrollView.contentOffset = CGPoint(x: 0, y: self.frame.size.height)
                currentIndex = currentIndex + 1
            
                upperImageView?.image = middleImageView?.image
                middleImageView?.image = downImageView?.image
                
                
                if(upperPlayer.frame.origin.y == 0){
                    upperPlayer.frame = CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT * 2, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }else{
                    upperPlayer.frame = CGRect(x: 0, y: upperPlayer.frame.origin.y - Constants.Dimension.SCREEN_HEIGHT, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }
                
                if(middlePlayer.frame.origin.y == 0){
                    middlePlayer.frame = CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT * 2, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }else{
                    middlePlayer.frame = CGRect(x: 0, y: middlePlayer.frame.origin.y - Constants.Dimension.SCREEN_HEIGHT, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }
                
                if(self.currentIndex == self.lives.count - 1){
                    self.downLive = self.lives.first
                }else if(self.currentIndex == self.lives.count){
                    self.downLive = self.lives[1]
                    self.currentIndex = 0;
                }else{
                    self.downLive = self.lives[currentIndex + 1]
                }
                
                prepareForImageView(imageView: downImageView!, video: downLive!)
                
                if(self.downPlayer.frame.origin.y == 0){
                    self.downPlayer.frame = CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT * 2, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }else{
                    self.downPlayer.frame = CGRect(x: 0, y: self.downPlayer.frame.origin.y - Constants.Dimension.SCREEN_HEIGHT, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }
                
                if(self.upperPlayer.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT * 2){
                    prepareForVideo(playerView: self.upperPlayer, video: self.downLive!)
                }
                if(middlePlayer.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT * 2){
                    prepareForVideo(playerView: self.middlePlayer, video: self.downLive!)
                }
                if(downPlayer.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT * 2){
                    prepareForVideo(playerView: self.downPlayer, video: self.downLive!)
                }

                if(self.previousIndex == self.currentIndex){
                    return
                }

                guard let delegate = self.playerDelegate else { return }
                delegate.playerScrollView(playerScrollView: self, index: currentIndex)
                previousIndex = currentIndex
            }else if(offset <= 0){  // 上一个
                scrollView.contentOffset = CGPoint(x: 0, y: self.frame.size.height)
                currentIndex = currentIndex - 1
                
                self.downImageView?.image = self.middleImageView?.image
                
                if(self.downPlayer.frame.origin.y == 2 * Constants.Dimension.SCREEN_HEIGHT){
                    self.downPlayer.frame = CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT * 0, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }else{
                    self.downPlayer.frame = CGRect(x: 0, y: self.downPlayer.frame.origin.y + Constants.Dimension.SCREEN_HEIGHT, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }
                
                self.middleImageView?.image = self.upperImageView?.image
                
                if(self.middlePlayer.frame.origin.y == 2 * Constants.Dimension.SCREEN_HEIGHT){
                    self.middlePlayer.frame = CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT * 0, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }else{
                    self.middlePlayer.frame = CGRect(x: 0, y: self.middlePlayer.frame.origin.y + Constants.Dimension.SCREEN_HEIGHT, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }
                
                if(self.currentIndex == 0){
                    self.upperLive = self.lives.last
                }else if(currentIndex == -1){
                    self.upperLive = self.lives[lives.count - 2]
                    self.currentIndex = self.lives.count - 1
                }else{
                    self.upperLive = self.lives[self.currentIndex - 1]
                }
                
                prepareForImageView(imageView: self.upperImageView!, video: self.upperLive!)
                
                if(self.upperPlayer.frame.origin.y == 2 * Constants.Dimension.SCREEN_HEIGHT){
                    self.upperPlayer.frame = CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT * 0, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }else{
                    self.upperPlayer.frame = CGRect(x: 0, y: self.upperPlayer.frame.origin.y + Constants.Dimension.SCREEN_HEIGHT, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }
                
                if(self.upperPlayer.frame.origin.y == 0){
                    prepareForVideo(playerView: self.upperPlayer, video: self.upperLive!)
                }
                
                if(self.middlePlayer.frame.origin.y == 0){
                    prepareForVideo(playerView: self.middlePlayer, video: self.upperLive!)
                }
                
                if(downPlayer.frame.origin.y == 0){
                    prepareForVideo(playerView: self.downPlayer, video: self.upperLive!)
                }
                
                if(self.previousIndex == self.currentIndex){
                    return
                }
                
                guard let delegate = self.playerDelegate else { return }
                delegate.playerScrollView(playerScrollView: self, index: currentIndex)
                previousIndex = currentIndex
            }
        }
    }
}

extension PlayScrollView{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switchPlayer(scrollView: scrollView)
    }
    
}
