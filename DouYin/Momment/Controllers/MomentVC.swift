//
//  MomentVC.swift
//  DouYin
//
//  Created by Niu Changming on 7/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CoreData

class MomentVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let momentData = MomentData()
    var tmpObject: AnyObject?
    let cellID = "MomentCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var refreshCtrl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor(hexString: Constants.ColorScheme.blackColor)
        refreshControl.addTarget(self, action:
            #selector(LiveListVC.handleRefresh(_:)),
                                 for: UIControlEvents.valueChanged)
        refreshControl.tintColor = UIColor.red
        
        return refreshControl
    }()
    
    lazy var chatInputBar: ChatInputBar = {
        let chatInputBar = ChatInputBar(frame: CGRect(x: 0, y: self.view.frame.size.height, width: self.view.frame.size.width, height: 48))
        chatInputBar.delegate = self
        self.view.addSubview(chatInputBar)
        return chatInputBar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "MomentCell", bundle: nil), forCellReuseIdentifier: cellID)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 80
        self.tableView.tableFooterView = UIView()
        self.tableView .addSubview(self.refreshCtrl)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl?) {
        self.momentData.isFinished = false
        self.momentData.data.removeAll()
        self.tableView.reloadData()
        
        loadData()
        
        guard let refreshBar = refreshControl else { return }
        refreshBar.endRefreshing()
    }
    
    func loadData(){
        momentData.getData { (status) in
            if status == .success {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared.enable = false
        
        if momentData.data.count == 0 {
            loadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(MomentVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MomentVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return momentData.data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! MomentCell
        let moment: Moment = momentData.data[indexPath.row]

        cell.updateUI(moment: moment)

        return cell
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        guard let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        let keyboardHeight: CGFloat = keyboardFrame.cgRectValue.height
        let extraSpace: CGFloat = Constants.Dimension.HOME_INDICATOR_HEIGHT + 1
        let animationTime: TimeInterval = userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as! TimeInterval
        
        self.chatInputBar.messageInputTv.contentSize = CGSize(width: self.chatInputBar.messageInputTv.frame.size.width, height: self.chatInputBar.messageInputTv.frame.size.height)
        
        UIView.animate(withDuration: animationTime, animations: { () -> Void in
            self.chatInputBar.transform = CGAffineTransform(translationX: 0, y: -(keyboardHeight-extraSpace))
        })
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let animationTime: TimeInterval = userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as! TimeInterval
        
        UIView.animate(withDuration: animationTime, animations: { () -> Void in
            self.chatInputBar.transform = CGAffineTransform.identity
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        IQKeyboardManager.shared.enable = true
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DBUtils.share.saveContext()
    }

}

extension MomentVC: ChatInputBarDelegate{
    func send() {
        guard let o = self.tmpObject else { return }
        
        if o.isKind(of: Moment.self) {
            sendCommentForMoment(moment: o as! Moment)
        }else{
            replyComment(comment: o as! Comment)
        }
    }
    
    func sendCommentForMoment(moment: Moment){
        self.chatInputBar.commentResource(resource: moment) { (moment, error) in

            guard let m = moment else { return }
            
            var row = -1
            for i in 0..<self.momentData.data.count {
                if self.momentData.data[i].resourceId == m.resourceId {
                    row = i
                    break
                }
            }
            
            if row >= 0{
                let indexPath = IndexPath(item: row, section: 0)
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
            
            self.chatInputBar.messageInputTv.resignFirstResponder()
        }
    }
    
    func replyComment(comment: Comment){
        self.chatInputBar.replyComment(comment: comment) { (status, error) in
            if (status == .failure) {
                print("Reply Comment Failed: \(error)")
            }
        }
    }
}
