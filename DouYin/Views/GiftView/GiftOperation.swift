//
//  GiftOperation.swift
//  DouYin
//
//  Created by Niu Changming on 17/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

typealias completeOpBlock = (_ finished: Bool, _ giftKey: String) -> Void

class GiftOperation: Operation {
    var opFinishedBlock: completeOpBlock?
    var giftShowView: GiftShowView?
    var backView: UIView?
    var giftSend: GiftSend?
    
    public var _isExecuting: Bool = false {
        didSet {
            self.willChangeValue(forKey: "isFinished")
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    public var _isFinished: Bool = false {
        didSet {
            self.willChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isExecuting")
        }
    }

    static func addOperationWithView(giftShowView: GiftShowView, backView: UIView, giftSend: GiftSend, completeBlock: @escaping completeOpBlock) -> GiftOperation{
        
        let op: GiftOperation = GiftOperation()
        op.giftShowView = giftShowView
        op.giftSend = giftSend
        op.backView = backView
        op.opFinishedBlock = completeBlock
        
        return op
    }
    
    override func start() {
        if(self.isCancelled){
            _isFinished = true
            return
        }
        
        _isExecuting = true
        
        OperationQueue.main.addOperation {
            self.backView?.addSubview(self.giftShowView!)
            self.giftShowView?.showGiftShowViewWithGift(giftSend: self.giftSend!, completeBlock: { (finished: Bool, giftKey: String) in
                self._isFinished = finished
                self.opFinishedBlock?(finished, giftKey)
            })
        }
    }
    
    override func cancel() {
        guard !isFinished else { return }
        super.cancel()
        
        if isExecuting {
            _isExecuting = false
        }
        if !isFinished {
            _isFinished = true
        }
    }
    
}






















