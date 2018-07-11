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
    var upperPlayer, middlePlayer, downPlayer: KSYMoviePlayerController?
    var upperLive, middleLive, downLive: Work?
    var currentIndex: NSInteger = 0
    var previousIndex: NSInteger = 0
    var lives: [Work] = []
    
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
        
        self.addSubview(upperImageView!)
        self.addSubview(middleImageView!)
        self.addSubview(downImageView!)
        
        upperPlayer = KSYMoviePlayerController()
        upperPlayer?.view.backgroundColor = UIColor.clear
        upperPlayer?.view.tag = 10001
        upperPlayer?.bufferSizeMax = 1
        upperPlayer?.view.autoresizesSubviews = true
        upperPlayer?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        upperPlayer?.shouldAutoplay = true
        upperPlayer?.shouldLoop = true
        upperPlayer?.scalingMode = .aspectFill
        upperPlayer?.view.frame = CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT * 0, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
        
        middlePlayer = KSYMoviePlayerController()
        middlePlayer?.view.backgroundColor = UIColor.clear
        middlePlayer?.view.tag = 10002
        middlePlayer?.bufferSizeMax = 1
        middlePlayer?.view.autoresizesSubviews = true
        middlePlayer?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        middlePlayer?.shouldAutoplay = true
        middlePlayer?.shouldLoop = true
        middlePlayer?.scalingMode = .aspectFill
        middlePlayer?.view.frame = CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT * 1, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
        
        downPlayer = KSYMoviePlayerController()
        downPlayer?.view.backgroundColor = UIColor.clear
        downPlayer?.view.tag = 10003
        downPlayer?.bufferSizeMax = 1
        downPlayer?.view.autoresizesSubviews = true
        downPlayer?.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        downPlayer?.shouldAutoplay = true
        downPlayer?.shouldLoop = true
        downPlayer?.scalingMode = .aspectFill
        downPlayer?.view.frame = CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT * 2, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
        self.autoresizesSubviews = true;
        
        self.addSubview((upperPlayer?.view!)!)
        self.addSubview((middlePlayer?.view!)!)
        self.addSubview((downPlayer?.view!)!)
    }
    
    func updateForLives(livesArray: [Work], index: NSInteger) -> () {
        if (livesArray.count > 0) {
            lives.removeAll()
            lives = livesArray
            currentIndex = index
            previousIndex = index
            
            var upperLive: Work = Work()
            let middleLive: Work = lives[index]
            var downLive: Work = Work()

            if(currentIndex == 0){
                upperLive = lives.last!
            }else{
                upperLive = lives[currentIndex - 1]
            }
            
            if(currentIndex == 0){
                downLive = lives.first!
            }else{
                downLive = lives[currentIndex + 1]
            }
            
            prepareForImageView(imageView: upperImageView!, work: upperLive)
            prepareForImageView(imageView: middleImageView!, work: middleLive)
            prepareForImageView(imageView: downImageView!, work: downLive)
            
            prepareForVideo(player: upperPlayer!, work: upperLive)
            prepareForVideo(player: middlePlayer!, work: middleLive)
            prepareForVideo(player: downPlayer!, work: downLive)
        }
    }
    
    func prepareForImageView(imageView: UIImageView, work: Work) {
        imageView.sd_setImage(with: URL(string: work.coverImage), placeholderImage: UIImage(named: "placeholder.png"))
    }
    
    func prepareForVideo(player: KSYMoviePlayerController, work: Work) {
        player.reset(false)
        player.setUrl(URL(string: work.workLink))
        player.shouldAutoplay = false
        player.bufferSizeMax = 1
        player.shouldLoop = true
        player.view.backgroundColor = UIColor.clear
        player.prepareToPlay()
    }
    
    func switchPlayer(scrollView: UIScrollView) {
        let offset: CGFloat = scrollView.contentOffset.y;
        
        if(lives.count > 0){
            if(offset >= 2 * self.frame.size.height){
                scrollView.contentOffset = CGPoint(x: 0, y: self.frame.size.height)
                self.currentIndex = self.currentIndex + 1
                
                upperImageView?.image = middleImageView?.image
                middleImageView?.image = downImageView?.image
                
                if(upperPlayer?.view.frame.origin.y == 0){
                    upperPlayer?.view.frame = CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT * 2, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }else{
                    upperPlayer?.view.frame = CGRect(x: 0, y: (upperPlayer?.view.frame.origin.y)! - Constants.Dimension.SCREEN_HEIGHT, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }
                
                if(middlePlayer?.view.frame.origin.y == 0){
                    middlePlayer?.view.frame = CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT * 2, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }else{
                    middlePlayer?.view.frame = CGRect(x: 0, y: (middlePlayer?.view.frame.origin.y)! - Constants.Dimension.SCREEN_HEIGHT, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }
                
                if(self.currentIndex == self.lives.count - 1){
                    self.downLive = self.lives.first
                }else if(self.currentIndex == self.lives.count){
                    self.downLive = self.lives[1]
                    self.currentIndex = 0;
                }else{
                    self.downLive = self.lives[currentIndex + 1]
                }
                prepareForImageView(imageView: downImageView!, work: downLive!)
                
                if(self.downPlayer?.view.frame.origin.y == 0){
                    self.downPlayer?.view.frame = CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT * 2, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }else{
                    self.downPlayer?.view.frame = CGRect(x: 0, y: (self.downPlayer?.view.frame.origin.y)! - Constants.Dimension.SCREEN_HEIGHT, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }
                
                if(self.upperPlayer?.view.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT * 2){
                    prepareForVideo(player: self.upperPlayer!, work: self.downLive!)
                }
                if(middlePlayer?.view.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT * 2){
                    prepareForVideo(player: self.middlePlayer!, work: self.downLive!)
                }
                if(downPlayer?.view.frame.origin.y == Constants.Dimension.SCREEN_HEIGHT * 2){
                    prepareForVideo(player: self.downPlayer!, work: self.downLive!)
                }

                
                if(self.previousIndex == self.currentIndex){
                    return
                }

                self.playerDelegate?.playerScrollView(playerScrollView: self, index: currentIndex)
                previousIndex = currentIndex
            }else if(offset <= 0){
                scrollView.contentOffset = CGPoint(x: 0, y: self.frame.size.height)
                self.currentIndex = self.currentIndex - 1
                self.downImageView?.image = self.middleImageView?.image
                
                if(self.downPlayer?.view.frame.origin.y == 2 * Constants.Dimension.SCREEN_HEIGHT){
                    self.downPlayer?.view.frame = CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT * 0, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }else{
                    self.downPlayer?.view.frame = CGRect(x: 0, y: (self.downPlayer?.view.frame.origin.y)! + Constants.Dimension.SCREEN_HEIGHT, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }
                
                self.middleImageView?.image = self.upperImageView?.image
                
                if(self.middlePlayer?.view.frame.origin.y == 2 * Constants.Dimension.SCREEN_HEIGHT){
                    self.middlePlayer?.view.frame = CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT * 0, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }else{
                    self.middlePlayer?.view.frame = CGRect(x: 0, y: (self.middlePlayer?.view.frame.origin.y)! + Constants.Dimension.SCREEN_HEIGHT, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }
                
                if(self.currentIndex == 0){
                    self.upperLive = self.lives.last
                }else if(currentIndex == -1){
                    self.upperLive = self.lives[lives.count - 2]
                    self.currentIndex = self.lives.count - 1
                }else{
                    self.upperLive = self.lives[self.currentIndex - 1]
                }
                prepareForImageView(imageView: self.upperImageView!, work: self.upperLive!)
                
                if(self.upperPlayer?.view.frame.origin.y == 2 * Constants.Dimension.SCREEN_HEIGHT){
                    self.upperPlayer?.view.frame = CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT * 0, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }else{
                    self.upperPlayer?.view.frame = CGRect(x: 0, y: (self.upperPlayer?.view.frame.origin.y)! + Constants.Dimension.SCREEN_HEIGHT, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT)
                }
                
                if(self.upperPlayer?.view.frame.origin.y == 0){
                    prepareForVideo(player: self.upperPlayer!, work: self.upperLive!)
                }
                
                if(self.middlePlayer?.view.frame.origin.y == 0){
                    prepareForVideo(player: self.middlePlayer!, work: self.upperLive!)
                }
                
                if(downPlayer?.view.frame.origin.y == 0){
                    prepareForVideo(player: self.downPlayer!, work: self.upperLive!)
                }
                
                if(self.previousIndex == self.currentIndex){
                    return
                }
                
                self.playerDelegate?.playerScrollView(playerScrollView: self, index: currentIndex)
                self.previousIndex = self.currentIndex
            }
        }
    }
    
}

extension PlayScrollView{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        switchPlayer(scrollView: scrollView)
    }
    
}
