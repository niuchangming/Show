//
//  LiveVC.swift
//  DouYin
//
//  Created by Niu Changming on 26/6/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class LiveVC: UIViewController {

    var live :Live?
    var currentIndex : Int = 0
    let cellID: String = "LiveCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(hexString: Constants.ColorScheme.blackColor)
        self.collectionView.reloadData()
        
        enterRoom()
        IQKeyboardManager.shared.enable = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(LiveVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LiveVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    lazy var touchView: UIView = {
        let touchView = UIView()
        touchView.backgroundColor = UIColor.clear
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard (_:)))
        touchView.addGestureRecognizer(tapGesture)
        touchView.backgroundColor = UIColor.clear
        return touchView
    }()
    
    lazy var collectionView: UICollectionView = {
        let collection = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: LiveCVFlowLayout.init())
        if #available(iOS 11.0, *) {
            collection.contentInsetAdjustmentBehavior = .never
        }
        collection.register(LiveCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collection.delegate = self
        collection.dataSource = self
        collection.allowsSelection = false
        collection.backgroundColor = UIColor.clear
        self.view.addSubview(collection)
        return collection
    }()
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        guard let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardHeight: CGFloat = keyboardFrame.cgRectValue.height
        
        let indexPath = IndexPath(item: 0, section: 0)
        let liveCell = self.collectionView.cellForItem(at: indexPath) as! LiveCollectionViewCell
        let animationTime: TimeInterval = userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as! TimeInterval
        
        touchView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - keyboardHeight - liveCell.chatInputBar.frame.size.height)
        self.view.addSubview(touchView)
        
        liveCell.chatInputBar.messageInputTv.contentSize = CGSize(width: liveCell.chatInputBar.messageInputTv.frame.size.width, height: liveCell.chatInputBar.messageInputTv.frame.size.height)
        
        UIView.animate(withDuration: animationTime, animations: { () -> Void in
            liveCell.chatInputBar.transform = CGAffineTransform(translationX: 0, y: -liveCell.chatInputBar.frame.size.height)
            liveCell.contentView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
        })
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let animationTime: TimeInterval = userInfo.value(forKey: UIKeyboardAnimationDurationUserInfoKey) as! TimeInterval

        self.touchView.removeFromSuperview()
        UIView.animate(withDuration: animationTime, animations: { () -> Void in
            let indexPath = IndexPath(item: 0, section: 0)
            let liveCell = self.collectionView.cellForItem(at: indexPath) as! LiveCollectionViewCell
            liveCell.chatInputBar.transform = CGAffineTransform.identity
            liveCell.contentView.transform = CGAffineTransform.identity
        })
    }
    
    @objc func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func enterRoom() {
        countRoomViewer(apiFunc: "castroom/enterroom")
    }
    
    func exitRoom(){
        countRoomViewer(apiFunc: "castroom/exitroom")
    }
    
    func countRoomViewer(apiFunc: String){
        ConnectionManager.shareManager.request(method: .post, url: String(format: "%@%@", Constants.HOST, apiFunc), parames: ["broadcastId": live?.id as AnyObject, "userCode": AuthUtils.share.userCode() as AnyObject], succeed: { (responseJson) in
        }) { (error) in
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        exitRoom()
        IQKeyboardManager.shared.enable = true
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

extension LiveVC : UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let liveCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? LiveCollectionViewCell
        liveCell?.liveData = self.live!
        liveCell?.enterOpenChannel(channelUrl: (self.live?.channelId)!)
        return liveCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        CFRunLoopWakeUp(CFRunLoopGetCurrent());
    }
    
}









