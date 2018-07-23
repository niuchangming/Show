//
//  ChatInputBar.swift
//  DouYin
//
//  Created by Niu Changming on 21/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

protocol ChatInputBarDelegate: class {
    func sendMessage(message: String)
}

class ChatInputBar: ReusableViewFromXib {
    
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var messageInputTv: UITextView!
    var delegate: ChatInputBarDelegate?
    
    @IBAction func sendBtnClicked(_ sender: UIButton){
        self.delegate?.sendMessage(message: messageInputTv.text)
    }

}
