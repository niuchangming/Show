//
//  OutgoingUserMessageCell.swift
//  DouYin
//
//  Created by Niu Changming on 20/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import SendBirdSDK

class OutgoingUserMessageCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageDisplayNameLabel: UILabel!
    @IBOutlet weak var messageContainerView: UIView!
    
    private var message: SBDUserMessage!
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    static func cellReuseIdentifier() -> String {
        return String(describing: self)
    }
    
    func setModel(message: SBDUserMessage, channel: SBDBaseChannel) {
        self.message = message
        self.messageDisplayNameLabel.text = ":我说"
        self.messageDisplayNameLabel.shadowColor = UIColor.black
        self.messageDisplayNameLabel.shadowOffset = CGSize(width: 1, height: 1);
        
        self.messageLabel.text = message.message
        self.messageLabel.shadowColor = UIColor.black
        self.messageLabel.shadowOffset = CGSize(width: 1, height: 1);
        self.messageLabel.numberOfLines = 0
    
        self.layoutIfNeeded()
    }
    
}
