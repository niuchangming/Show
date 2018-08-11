//
//  ChatInputBar.swift
//  DouYin
//
//  Created by Niu Changming on 21/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import SendBirdSDK

protocol ChatInputBarDelegate: class {
    func sendMessage()
}

class ChatInputBar: ReusableViewFromXib {
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var messageInputTv: UITextView!
    var delegate: ChatInputBarDelegate?
    
    @IBAction func sendBtnClicked(_ sender: UIButton){
        self.delegate?.sendMessage()
    }

    func sendMessage(channel: SBDOpenChannel!, completed: @escaping(_ userMessage: SBDUserMessage, _ error: SBDError?) -> () ) {
        if self.messageInputTv.text.count > 0 {
            let message = self.messageInputTv.text
            self.messageInputTv.text = ""
            
            self.sendBtn.isEnabled = false
            channel.sendUserMessage(message, data: "", customType: "", targetLanguages: [], completionHandler: { (userMessage, error) in
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(150), execute: {
                    completed(userMessage!, error!)
                })
                self.sendBtn.isEnabled = true
            })
        }
    }
}
