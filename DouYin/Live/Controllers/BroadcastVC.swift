//
//  BroadcastVC.swift
//  DouYin
//
//  Created by Niu Changming on 5/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import SendBirdSDK

class BroadcastVC: UIViewController, SBDChannelDelegate{
    
    @IBOutlet weak var startBtn: UIButton!
    @IBOutlet weak var chatView: ChatView!
    fileprivate var openChannel: SBDOpenChannel!

    lazy var bambuserView: BambuserView = {
        let bambuserView = BambuserView(preparePreset: kSessionPresetAuto)
        bambuserView?.applicationId = Constants.BAMBUSER_APP_ID
        return bambuserView!
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bambuserView.orientation = UIApplication.shared.statusBarOrientation
        self.bambuserView.delegate = self
        self.view.addSubview(self.bambuserView.view)
        self.view.bringSubview(toFront: startBtn)
        
        SBDMain.add(self as SBDChannelDelegate, identifier: self.description)
        bambuserView.startCapture()
        createOpenChannel()
    }
    
    override func viewWillLayoutSubviews() {
        var statusBarOffset : CGFloat = 0.0
        statusBarOffset = CGFloat(self.topLayoutGuide.length)
        self.bambuserView.previewFrame = CGRect(x: 0.0, y: 0.0 + statusBarOffset, width: self.view.bounds.size.width, height: self.view.bounds.size.height - statusBarOffset)
    }
    
    func createOpenChannel() {
        SBDOpenChannel.createChannel(withName:"demo_open_channel" , coverUrl: nil, data: nil, operatorUsers: nil) { (channel, error) in
            if error != nil {
                let vc = UIAlertController(title: "Failed", message: error?.domain, preferredStyle: UIAlertControllerStyle.alert)
                let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.cancel, handler: nil)
                vc.addAction(closeAction)
                DispatchQueue.main.async {
                    self.present(vc, animated: true, completion: nil)
                }
            }else{
                self.openChannel = channel
                self.chatView.configureChattingView(channel: self.openChannel)
                self.enterOpenChannel(channelUrl: (channel?.channelUrl)!)
            }
        }
    }
    
    func enterOpenChannel(channelUrl: String){
        SBDOpenChannel.getWithUrl(channelUrl) { (channel, error) in
            if error != nil {
                NSLog("Get Open Channel Error: %@", error!)
                return
            }
            
            channel?.enter(completionHandler: { (error) in
                if error != nil {
                    NSLog("Enter Open Channel Error: %@", error!)
                    return
                }
            })
        }
    }
    
    @IBAction func startBtnClicked(_ sender: Any) {
        startBtn.setTitle("Connecting", for: UIControlState.normal)
        startBtn.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        startBtn.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControlEvents.touchUpInside)
        bambuserView.startBroadcasting()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}

extension BroadcastVC: BambuserViewDelegate{
    
    func broadcastStarted() {
        startBtn.setTitle("Stop", for: UIControlState.normal)
        startBtn.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        startBtn.addTarget(bambuserView, action: #selector(bambuserView.stopBroadcasting), for: UIControlEvents.touchUpInside)
    }
    
    func broadcastStopped() {
        startBtn.setTitle("Broadcast", for: UIControlState.normal)
        startBtn.removeTarget(nil, action: nil, for: UIControlEvents.touchUpInside)
        startBtn.addTarget(self, action: #selector(BroadcastVC.startBtnClicked(_:)), for: UIControlEvents.touchUpInside)
    }
    
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        if sender == self.openChannel {
            
            DispatchQueue.main.async {
                UIView.setAnimationsEnabled(false)
                self.chatView.messages.append(message)
                self.chatView.chattingTableView.reloadData()
                UIView.setAnimationsEnabled(true)
                DispatchQueue.main.async {
                    self.chatView.scrollToBottom(force: false)
                }
            }
        }
        
    }
}
