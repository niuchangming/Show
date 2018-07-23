//
//  AdminMessageCell.swift
//  DouYin
//
//  Created by Niu Changming on 21/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import SendBirdSDK

class AdminMessageCell: UITableViewCell {

    @IBOutlet weak var adminIndicatorContainer: UIView!
    @IBOutlet weak var messageLbl: UILabel!
    
    private var message: SBDAdminMessage!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.adminIndicatorContainer.layer.cornerRadius = self.adminIndicatorContainer.frame.size.height / 2
        self.adminIndicatorContainer.layer.masksToBounds = true
    }
    
    static func nib() -> UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    static func cellReuseIdentifier() -> String {
        return String(describing: self)
    }
    
    func setModel(message: SBDAdminMessage) {
        self.message = message
        self.messageLbl.text = message.message
        self.messageLbl.numberOfLines = 0
        self.messageLbl.sizeToFit()
        
        self.layoutIfNeeded()
    }
    
}
