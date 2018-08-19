//
//  ChatView.swift
//  DouYin
//
//  Created by Niu Changming on 20/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import SendBirdSDK

protocol ChatViewDelegate: class {
    func loadMoreMessage(view: UIView)
    func hideKeyboardWhenFastScrolling(view: UIView)
}

class ChatView: ReusableViewFromXib, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var unreadContainerView: UIView!{
        didSet{
            unreadContainerView.isHidden = true
        }
    }
    @IBOutlet weak var unreadBtn: UIButton!{
        didSet{
            unreadBtn.isHidden = true
        }
    }
    
    @IBOutlet weak var chattingTableView: UITableView!
    var incomingUserMessageCell: IncomingUserMessageCell?
    var outgoingUserMessageCell: OutgoingUserMessageCell?
    var adminMessageCell: AdminMessageCell?
    var messages: [SBDBaseMessage] = []
    var resendableMessages: [String:SBDBaseMessage] = [:]
    var channel: SBDBaseChannel?
    
    var initialLoading: Bool = true
    var stopMeasuringVelocity: Bool = true
    var lastMessageHeight: CGFloat = 0
    var scrollLock: Bool = false
    var lastOffset: CGPoint = CGPoint(x: 0, y: 0)
    var lastOffsetCapture: TimeInterval = 0
    var isScrollingFast: Bool = false
    var delegate: ChatViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        self.chattingTableView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0)
    }
    
    func configureChattingView(channel: SBDBaseChannel?) {
        self.channel = channel
        
        self.initialLoading = true
        self.lastMessageHeight = 0
        self.scrollLock = false
        self.stopMeasuringVelocity = false
        
        self.chattingTableView.register(IncomingUserMessageCell.nib(), forCellReuseIdentifier: IncomingUserMessageCell.cellReuseIdentifier())
        self.chattingTableView.register(OutgoingUserMessageCell.nib(), forCellReuseIdentifier: OutgoingUserMessageCell.cellReuseIdentifier())
        self.chattingTableView.register(AdminMessageCell.nib(), forCellReuseIdentifier: AdminMessageCell.cellReuseIdentifier())
        
        self.initSizingCell()
    }
    
    func initSizingCell() {
        self.incomingUserMessageCell = IncomingUserMessageCell.nib().instantiate(withOwner: self, options: nil)[0] as? IncomingUserMessageCell
        self.incomingUserMessageCell?.isHidden = true
        self.addSubview(self.incomingUserMessageCell!)
        
        self.outgoingUserMessageCell = OutgoingUserMessageCell.nib().instantiate(withOwner: self, options: nil)[0] as? OutgoingUserMessageCell
        self.outgoingUserMessageCell?.isHidden = true
        self.addSubview(self.outgoingUserMessageCell!)
        
        self.adminMessageCell = AdminMessageCell.nib().instantiate(withOwner: self, options: nil)[0] as? AdminMessageCell
        self.adminMessageCell?.isHidden = true
        self.addSubview(self.adminMessageCell!)
    }
    
    func isScrollToBottom() -> Bool {
        let bufferHeight: CGFloat = 100
        
        if self.chattingTableView.contentOffset.y >= (self.chattingTableView.contentSize.height - self.chattingTableView.frame.size.height - bufferHeight) {
            return true
        }else{
            showUnreadBar()
            return false
        }
    }
    
    func scrollToBottom(force: Bool) {
        if self.messages.count == 0 {
            return
        }
        
        if self.scrollLock == true && force == false {
            return
        }
        
        hideUnreadBar()
        self.chattingTableView.scrollToRow(at: IndexPath.init(row: self.messages.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
    }
    
    func scrollToPosition(position: Int) {
        if self.messages.count == 0 {
            return
        }
        
        self.chattingTableView.scrollToRow(at: IndexPath.init(row: position, section: 0), at: UITableViewScrollPosition.top, animated: false)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.stopMeasuringVelocity = false
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.stopMeasuringVelocity = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.chattingTableView {
            if self.stopMeasuringVelocity == false {
                let currentOffset = scrollView.contentOffset
                let currentTime = NSDate.timeIntervalSinceReferenceDate
                
                let timeDiff = currentTime - self.lastOffsetCapture
                if timeDiff > 0.1 {
                    let distance = currentOffset.y - self.lastOffset.y
                    let scrollSpeedNotAbs = distance * 10 / 1000
                    let scrollSpeed = fabs(scrollSpeedNotAbs)
                    if scrollSpeed > 0.5 {
                        self.isScrollingFast = true
                    }
                    else {
                        self.isScrollingFast = false
                    }
                    
                    self.lastOffset = currentOffset
                    self.lastOffsetCapture = currentTime
                }
                
                if self.isScrollingFast {
                    if self.delegate != nil {
                        self.delegate?.hideKeyboardWhenFastScrolling(view: self)
                    }
                }
            }
            
            if scrollView.contentOffset.y + scrollView.frame.size.height + self.lastMessageHeight < scrollView.contentSize.height {
                self.scrollLock = true
            }
            else {
                self.scrollLock = false
            }
            
            if scrollView.contentOffset.y == 0 {
                if self.messages.count > 0 && self.initialLoading == false {
                    if self.delegate != nil {
                        self.delegate?.loadMoreMessage(view: self)
                    }
                }
            }
        }
    }
    
    @IBAction func unreadBtnClick(_ sender: Any) {
        self.scrollToBottom(force: true)
    }
    
    func hideUnreadBar(){
        self.unreadContainerView.isHidden = true
        self.unreadBtn.isHidden = true
    }
    
    func showUnreadBar(){
        self.unreadContainerView.isHidden = false
        self.unreadBtn.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell?
        
        let msg = self.messages[indexPath.row]
        
        if msg is SBDUserMessage {
            let userMessage = msg as! SBDUserMessage
            let sender = userMessage.sender
            
            if sender?.userId == SBDMain.getCurrentUser()?.userId {
                cell = tableView.dequeueReusableCell(withIdentifier: OutgoingUserMessageCell.cellReuseIdentifier())
                (cell as! OutgoingUserMessageCell).setModel(message: userMessage, channel: self.channel!)
            }else {
                cell = tableView.dequeueReusableCell(withIdentifier: IncomingUserMessageCell.cellReuseIdentifier())
                (cell as! IncomingUserMessageCell).setModel(message: userMessage)
            }
        }else if msg is SBDAdminMessage {
            let adminMessage = msg as! SBDAdminMessage
            
            cell = tableView.dequeueReusableCell(withIdentifier: AdminMessageCell.cellReuseIdentifier())
            (cell as! AdminMessageCell).setModel(message: adminMessage)
        }
        return cell!
    }

}
