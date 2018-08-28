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
    @IBOutlet weak var messageInputTv: UITextView!{
        didSet{
            messageInputTv.clipsToBounds = true
            messageInputTv.layer.cornerRadius = Constants.Dimension.CORNER_SIZE
        }
    }
    var delegate: ChatInputBarDelegate?
    
    @IBAction func sendBtnClicked(_ sender: UIButton){
        self.delegate?.sendMessage()
    }
    
    func sendMessage(channel: SBDOpenChannel!, completed: @escaping(_ userMessage: SBDUserMessage, _ error: SBDError?) -> () ) {
        if self.messageInputTv.text.count > 0 {
            let message = self.messageInputTv.text
            self.messageInputTv.text = ""
            
            self.sendBtn.isEnabled = false
            channel.sendUserMessage(message, data: "", customType: ChatType.text.rawValue, targetLanguages: [], completionHandler: { (userMessage, error) in
                
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .milliseconds(150), execute: {
                    completed(userMessage!, error)
                })
                self.sendBtn.isEnabled = true
            })
        }
    }
    
    func sendComment(momentId: String, commentId: String, completed: @escaping(_ status: Status, _ error: String) -> () ) {
        if self.messageInputTv.text.count > 0 {
            let message = self.messageInputTv.text
            self.messageInputTv.text = ""
            self.sendBtn.isEnabled = false
            
            let commentAPI = String(format: "%@comments/comment", Constants.HOST)
            
            let params = ["body": message, "token": AuthUtils.share.apiToken(), "resourceId": momentId, "commentId": commentId] as [String : AnyObject]
        
            ConnectionManager.shareManager.request(method: .post, url: commentAPI, parames: params, succeed: { (responseJson) in
                let response = responseJson as! NSDictionary
                let errorCode = response["errorCode"] as! Int
                let message = response["message"] as! String
                if errorCode == 1 {
                    completed(.success, message)
                }else{
                    completed(.failure, message)
                }
                self.sendBtn.isEnabled = true
            }) { (error) in
                completed(.failure, (error?.localizedDescription)!)
                self.sendBtn.isEnabled = true
            }
        }
    }
}

enum ChatType: String {
    case text = "text"
    case gift = "gift"

    static func iterateEnum() -> AnyIterator<ChatType> {
        var i = 0
        return AnyIterator {
            let next = withUnsafeBytes(of: &i) { $0.load(as: ChatType.self) }
            if next.hashValue != i { return nil }
            i += 1
            return next
        }
    }
}












