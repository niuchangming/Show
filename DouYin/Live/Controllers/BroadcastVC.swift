//
//  BroadcastVC.swift
//  DouYin
//
//  Created by Niu Changming on 5/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import SendBirdSDK
import IQKeyboardManagerSwift

class BroadcastVC: UIViewController, SBDChannelDelegate, ChatInputBarDelegate{
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var bottomViewBottomContraint: NSLayoutConstraint!
    @IBOutlet weak var playBtn: UIButton!
    @IBOutlet weak var chatView: ChatView!
    fileprivate var openChannel: SBDOpenChannel!
    let giftData = GiftData()
    
    var channelTryCount: Int = 0

    lazy var bambuserView: BambuserView = {
        let bambuserView = BambuserView(preparePreset: kSessionPresetAuto)
        bambuserView?.view.backgroundColor = .black
        bambuserView?.customData = AuthUtils.share.userCode()
        bambuserView?.sendPosition = true
        bambuserView?.applicationId = Constants.BAMBUSER_APP_ID
        return bambuserView!
    }()
    
    fileprivate lazy var emitterLayer: CAEmitterLayer = {
        let emitter = CAEmitterLayer.init()
        emitter.emitterPosition = CGPoint.init(x: self.bambuserView.view.frame.size.width - 50, y: self.bambuserView.view.frame.size.height - 50)
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
        self.bambuserView.view.layer.addSublayer(emitter)
        return emitter
    }()
    
    lazy var chatInputBar: ChatInputBar = {
        let chatInputBar = ChatInputBar(frame: CGRect(x: 0, y: self.contentView.frame.size.height, width: self.contentView.frame.size.width, height: 48))
        chatInputBar.delegate = self
        self.contentView.addSubview(chatInputBar)
        return chatInputBar
    }()
    
    lazy var gifImageView: FLAnimatedImageView = {
        let gifImageView = FLAnimatedImageView(frame: CGRect(x: 7.5, y: 0, width: 360, height: 225))
        gifImageView.contentMode = .scaleAspectFill
        gifImageView.isHidden = true
        return gifImageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bambuserView.orientation = UIApplication.shared.statusBarOrientation
        self.bambuserView.delegate = self
        self.view.addSubview(self.bambuserView.view)

        self.view.bringSubview(toFront: contentView)

        SBDMain.add(self as SBDChannelDelegate, identifier: self.description)
        bambuserView.startCapture()

        if Utils.isNotNil(obj: AuthUtils.share.channelId()) {
            enterOpenChannel(channelUrl: AuthUtils.share.channelId()!)
        }else{
            createOpenChannel()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared.enable = false
        NotificationCenter.default.addObserver(self, selector: #selector(BroadcastVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(BroadcastVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.bambuserView.previewFrame = CGRect(x: 0.0, y: 0.0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
        self.bottomViewBottomContraint.constant = Constants.Dimension.HOME_INDICATOR_HEIGHT
        
        self.chatView.backgroundColor = UIColor.clear
        self.chatView.chattingTableView.backgroundColor = UIColor.clear
    }
    
    func createOpenChannel() {
        SBDOpenChannel.createChannel(withName:"demo_open_channel" , coverUrl: nil, data: nil, operatorUsers: nil) { (channel, error) in
            if error != nil {
                if self.channelTryCount <= 3 {
                    self.createOpenChannel()
                }
                self.channelTryCount = self.channelTryCount + 1
            }else{
                self.enterOpenChannel(channelUrl: (channel?.channelUrl)!)
                AuthUtils.share.saveChannelId(channelId: (channel?.channelUrl)!)
                self.uploadChannelId(channelId: (channel?.channelUrl)!)
                
            }
        }
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
    
    func uploadChannelId(channelId: String){
        ConnectionManager.shareManager.request(method: .post, url: String(format: "%@broadcast/uploadChannelId", Constants.HOST), parames: ["token": AuthUtils.share.apiToken() as AnyObject, "channelId": channelId as AnyObject], succeed: { (responseJson) in
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            let message = response["message"] as! String
            if errorCode != 1 {
                NSLog("Upload ChannelID Error: %@", message)
            }
        }) { (error) in
            print("Upload ChannelID Error: \(String(describing: error?.localizedDescription))")
        }
    }
    
    @IBAction func chatBtnClicked(_ sender: Any) {
        self.chatInputBar.messageInputTv.becomeFirstResponder()
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
    @IBOutlet weak var bottomBar: UIView!
    
    @IBAction func swithCameraBtnClicked(_ sender: Any) {
        self.bambuserView.swapCamera()
    }
    
    @IBAction func playBtnClicked(_ sender: Any) {
        playBtn.setTitle("Connecting", for: UIControlState.normal)
        playBtn.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        playBtn.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControlEvents.touchUpInside)
        bambuserView.startBroadcasting()
    }
    
    @IBAction func dismissBtnClicked(_ sender: Any) {
        self.bambuserView.stopBroadcasting()
        if(self.openChannel != nil){
            self.openChannel.exitChannel(completionHandler: nil)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        guard let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight: CGFloat = keyboardFrame.cgRectValue.height
        let animationTime: TimeInterval = userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as! TimeInterval
        
        self.chatInputBar.messageInputTv.contentSize = CGSize(width: self.chatInputBar.messageInputTv.frame.size.width, height: self.chatInputBar.messageInputTv.frame.size.height)
        
        UIView.animate(withDuration: animationTime, animations: { () -> Void in
            self.bottomBar.transform = CGAffineTransform(translationX: 0, y: -Constants.Dimension.HOME_INDICATOR_HEIGHT)
            self.chatInputBar.transform = CGAffineTransform(translationX: 0, y: -self.chatInputBar.frame.size.height)
            self.contentView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
        })
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let animationTime: TimeInterval = userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as! TimeInterval
    
        UIView.animate(withDuration: animationTime, animations: { () -> Void in
            self.bottomBar.transform = CGAffineTransform.identity
            self.chatInputBar.transform = CGAffineTransform.identity
            self.contentView.transform = CGAffineTransform.identity
        })
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = true
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

extension BroadcastVC: BambuserViewDelegate{
    
    func broadcastStarted() {
        playBtn.setImage(UIImage.init(named: "mg_room_btn_stop_n"), for: .normal)
        playBtn.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        playBtn.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControlEvents.touchUpInside)
        self.emitterLayer.isHidden = false
    }
    
    func broadcastStopped() {
        playBtn.setImage(UIImage.init(named: "mg_room_btn_go_n"), for: .normal)
        playBtn.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        playBtn.addTarget(self, action: #selector(BroadcastVC.playBtnClicked(_:)), for: UIControlEvents.touchUpInside)
        self.emitterLayer.isHidden = true
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
        
        GiftShowManager.shared().showGiftViewWithBackView(backView: self.view, giftSend: giftSend, completeBlock: { (finished: Bool) in
            
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
