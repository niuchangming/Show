//
//  LiveCollectionViewCell.swift
//  DouYin
//
//  Created by Niu Changming on 29/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import KSYMediaPlayer
import SendBirdSDK

class LiveCollectionViewCell: UICollectionViewCell, BambuserPlayerDelegate, ChatInputBarDelegate, SBDChannelDelegate, GiftViewDelegate{
    fileprivate var placeHolderView = UIImageView()
    fileprivate var liveLink : String = ""
    fileprivate var openChannel: SBDOpenChannel?
    let giftData: GiftData =  GiftData()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        initUI()
        
        SBDMain.add(self as SBDChannelDelegate, identifier: self.description)
    }
    
    func initUI() {
        self.contentView.addSubview(placeHolderView)
        
        placeHolderView.frame = self.contentView.frame
        placeHolderView.contentMode = .scaleAspectFill
        let bottomViewHeight: CGFloat = 44
        let bottomViewY = self.contentView.frame.size.height - bottomViewHeight - Constants.Dimension.HOME_INDICATOR_HEIGHT - Constants.Dimension.MARGIN_MIDDLE
        
        self.moviePlayer.frame = self.contentView.bounds
        self.bottomView.frame = CGRect(x: 0, y: bottomViewY, width: self.contentView.frame.size.width, height: 44)
        self.headerView.frame = CGRect(x: Constants.Dimension.MARGIN_NOR, y: Constants.Dimension.STATUS_BAR_HEIGHT + Constants.Dimension.MARGIN_LARGE, width: 200 * Constants.Dimension.W_RATIO, height: 60 * Constants.Dimension.H_RATIO)
    }

    override func layoutSubviews() {
        let chatViewWidth = 2 * self.contentView.frame.size.width / 3
        let chatViewHeight = 2 * chatViewWidth / 3
        let chatViewY = self.bottomView.frame.minY - chatViewHeight
        self.chatView.frame = CGRect.init(x: 0, y: chatViewY, width: chatViewWidth, height: chatViewHeight)
        
        self.headerView.userInfoContainer.clipsToBounds = true
        self.headerView.userInfoContainer.layer.cornerRadius = self.headerView.userInfoContainer.frame.size.height / 2
    }
    
    func enterOpenChannel(channelUrl: String){
        SBDOpenChannel.getWithUrl(channelUrl) { (channel, error) in
            if error != nil {
                NSLog("Get Open Channel Error: %@", error!)
                return
            }
            
            self.openChannel = channel
            self.chatView.configureChattingView(channel: self.openChannel)
            channel?.enter(completionHandler: { (error) in
                if error != nil {
                    NSLog("Enter Open Channel Error: %@", error!)
                    return
                }
            })
        }
    }
    
    //开始直播
    fileprivate func playWithLive(liveLink:String, placeHolderUrl:URL) {
        self.liveLink = liveLink
        self.contentView.insertSubview(self.placeHolderView, aboveSubview: self.moviePlayer)
        self.placeHolderView.setImageViewBlur(url: placeHolderUrl, float: 0.7)
        self.contentView.insertSubview(self.moviePlayer, at: 0)
    
        moviePlayer.playVideo(liveLink)
        setupBottomView()
    }

    fileprivate func setupBottomView() {
        self.bottomView.bottomViewBtnClickBlock = {
            [unowned self] (LivingBottomViewBtnClickType) -> Void in
            switch LivingBottomViewBtnClickType {
            case .hotMessageType:
                self.chatInputBar.messageInputTv.becomeFirstResponder()
                break
            case .hot_e_mailClickType:
                
                break
            case .hot_giftClickType:
                if Utils.isNotNil(obj: self.giftView.giftArray) && self.giftView.giftArray.count > 0{
                    self.giftView.show()
                    self.giftView.collectionView.reloadData()
                }else{
                    self.giftData.getData { [unowned self] (message) in
                        if message == "Success" {
                            self.giftView.show()
                             self.giftView.giftArray = self.giftData.data
                            self.giftView.collectionView.reloadData()
                        }
                    }
                }
                break
            case .hot_shareClickType:

                break
            case .hot_gobackClickType:
                let handledVC: UIViewController = Utils.viewController(responder: self)!
                handledVC.dismiss(animated: true, completion: nil)
                self.playStop()
                break
            }
        }
    }
    
    public func playStop() {
        self.moviePlayer.pauseVideo()
        self.moviePlayer.stopVideo()
        self.emitterLayer.removeFromSuperlayer()
        self.removeFromSuperview()
    }
    
    public var liveData = Live() {
        didSet {
            self.playWithLive(liveLink: liveData.resourceUri, placeHolderUrl: URL.init(string: (liveData.avatar?.medium)!)!)
            self.headerView.live = liveData
        }
    }

    lazy var moviePlayer: BambuserPlayer = {
        let bambuserPlayer: BambuserPlayer = BambuserPlayer()
        bambuserPlayer.applicationId = Constants.BAMBUSER_APP_ID
        bambuserPlayer.videoScaleMode = VideoScaleAspectFill
        bambuserPlayer.delegate = self
        bambuserPlayer.isUserInteractionEnabled = true
        return bambuserPlayer
    }()

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
    
    lazy var chatView: ChatView = {
        let chatView = ChatView()
        chatView.backgroundColor = .clear
        chatView.chattingTableView.backgroundColor = .clear
        self.contentView.addSubview(chatView)
        return chatView
    }()
    
    lazy var chatInputBar: ChatInputBar = {
        let chatInputBar = ChatInputBar(frame: CGRect(x: 0, y: self.contentView.frame.size.height, width: self.contentView.frame.size.width, height: 48))
        chatInputBar.delegate = self
        self.contentView.addSubview(chatInputBar)
        return chatInputBar
    }()
    
    lazy var bottomView: LiveCollectionCellBottom = {
        let bottomView = LiveCollectionCellBottom.instanceFromNib()
        bottomView.backgroundColor = UIColor.clear
        self.contentView.addSubview(bottomView)
        return bottomView
    }()

    lazy var headerView: LiveCollectionCellHeader = {
        let headerView = LiveCollectionCellHeader(frame: CGRect.zero)
        headerView.customView?.backgroundColor = .clear
        headerView.backgroundColor = .clear
        self.contentView.addSubview(headerView)
        return headerView
    }()
    
    lazy var giftView: GiftView = {
        let giftView = GiftView(frame: CGRect(x: 0, y: Constants.Dimension.SCREEN_HEIGHT, width: Constants.Dimension.SCREEN_WIDTH, height: Constants.Dimension.SCREEN_HEIGHT))
        giftView.delegate = self
        return giftView
    }()
    
    lazy var gifImageView: FLAnimatedImageView = {
        let gifImageView = FLAnimatedImageView(frame: CGRect(x: 7.5, y: 0, width: 360, height: 225))
        gifImageView.contentMode = .scaleAspectFill
        gifImageView.isHidden = true
        return gifImageView
    }()

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
    
    func sendMessage() {
        self.chatInputBar.sendMessage(channel: self.openChannel) { (userMessage, error) in
            if error != nil {
                self.chatView.resendableMessages[userMessage.requestId!] = userMessage
                DispatchQueue.main.async {
                    self.chatView.scrollToBottom(force: true)
                }
                return
            }
            
            self.chatView.messages.append(userMessage)
            DispatchQueue.main.async {
                self.chatView.chattingTableView.reloadData()
                DispatchQueue.main.async {
                    self.chatView.scrollToBottom(force: true)
                }
            }
        }
    }
    
    func giftViewSendGiftInView(giftView: GiftView, gift: Gift?) {
        let liveVC: LiveVC = Utils.viewController(responder: self) as! LiveVC
        if(gift == nil){
            let alertController = UIAlertController(title: "发送失败", message: "抱歉，您还没有哦选择礼物！", preferredStyle: .alert)
            let actionKnown = UIAlertAction(title: "知道了", style: .cancel) { (action:UIAlertAction) in}
            alertController.addAction(actionKnown)
            liveVC.present(alertController, animated: true, completion: {
                self.giftView.hide()
            })
        }else{
            let giftSend: GiftSend = GiftSend()
            giftSend.icon = (gift?.image)!
            giftSend.name = (gift?.name)!
            giftSend.icon_gif = (gift?.animImage)!
            giftSend.id = (gift?.id)!;
            giftSend.defaultCount = 0;
            giftSend.sendCount = 1;
            
            GiftShowManager.shared().sendGiftMessage(channel: self.openChannel, giftSend: giftSend) { (userMessage, error) in
                if error != nil{
                    print("Send gift error: \(String(describing: error?.localizedDescription))")
                    return
                }
                self.showGiftView(giftSend: giftSend)
            }
            
        }
    }
    
    func showGiftView(giftSend: GiftSend){
        let liveVC: LiveVC = Utils.viewController(responder: self) as! LiveVC
        GiftShowManager.shared().showGiftViewWithBackView(backView: liveVC.view, giftSend: giftSend, completeBlock: { (finished: Bool) in
            
        }, showGifImageBlock: { (giftSend: GiftSend) in
            DispatchQueue.main.async {
                let window: UIWindow = UIApplication.shared.keyWindow!
                window.addSubview(self.gifImageView)
                
                do{
                    let gifData = try Data.init(contentsOf: URL(string: (giftSend.icon_gif))!)
                    let gifImage: FLAnimatedImage = FLAnimatedImage(animatedGIFData: gifData)
                    self.gifImageView.animatedImage = gifImage
                    self.gifImageView.isHidden = false
                }catch {
                    print("Donwload Gif Image failed")
                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2), execute: { () in
                    self.gifImageView.isHidden = true
                    self.gifImageView.removeFromSuperview()
                })
            }
        })
    }
    
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        if sender == self.openChannel {
            if message.isKind(of: SBDUserMessage.self) {
                let userMessage = message as! SBDUserMessage
                if userMessage.customType == ChatType.gift.rawValue{
                    if Utils.isNotNil(obj: self.giftData.data) && self.giftData.data.count > 0{
                        for gift in self.giftData.data {
                            if gift.id == userMessage.data {
                                self.showGiftView(gift: gift)
                                break;
                            }
                        }
                    }else{
                        giftData.getData { [unowned self] (message) in
                            if message == "Success" {
                                for gift in self.giftData.data {
                                    if gift.id == sender.data {
                                        self.showGiftView(gift: gift)
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        UIView.setAnimationsEnabled(false)
                        self.chatView.messages.append(message)
                        self.chatView.chattingTableView.reloadData()
                        UIView.setAnimationsEnabled(true)
                        DispatchQueue.main.async {
                            self.chatView.scrollToBottom(force: self.chatView.isScrollToBottom())
                        }
                    }
                }
            }
            
        }
    }
    
    func showGiftView(gift: Gift){
        let giftSend: GiftSend = GiftSend()
        giftSend.icon = gift.image
        giftSend.name = gift.name
        giftSend.icon_gif = gift.animImage
        giftSend.id = gift.id
        giftSend.defaultCount = 0
        giftSend.sendCount = 1
        
        let liveVC: LiveVC = Utils.viewController(responder: self) as! LiveVC
        GiftShowManager.shared().showGiftViewWithBackView(backView: liveVC.view, giftSend: giftSend, completeBlock: { (finished: Bool) in
            
        }, showGifImageBlock: { (giftSend: GiftSend) in
            DispatchQueue.main.async {
                let window: UIWindow = UIApplication.shared.keyWindow!
                window.addSubview(self.gifImageView)
                
                do{
                    let gifData = try Data.init(contentsOf: URL(string: (giftSend.icon_gif))!)
                    let gifImage: FLAnimatedImage = FLAnimatedImage(animatedGIFData: gifData)
                    self.gifImageView.animatedImage = gifImage
                    self.gifImageView.isHidden = false
                }catch {
                    print("Donwload Gif Image failed")
                }
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(2), execute: { () in
                    self.gifImageView.isHidden = true
                    self.gifImageView.removeFromSuperview()
                })
            }
        })
    }
}
