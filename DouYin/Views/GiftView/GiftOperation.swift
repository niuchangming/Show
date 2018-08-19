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
    
    private var backing_executing : Bool
    override var isExecuting : Bool {
        get { return backing_executing }
        set {
            willChangeValue(forKey: "isExecuting")
            backing_executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var backing_finished : Bool
    override var isFinished : Bool {
        get { return backing_finished }
        set {
            willChangeValue(forKey: "isFinished")
            backing_finished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override init() {
        backing_executing = false
        backing_finished = false
        super.init()
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
            self.isFinished = true
            return
        }
        
        self.isExecuting = true
        print("当前队列-- \(String(describing: self.giftSend?.id))")
        OperationQueue.main.addOperation {
            self.backView?.addSubview(self.giftShowView!)
            self.giftShowView?.showGiftShowViewWithGift(giftSend: self.giftSend!, completeBlock: { (finished: Bool, giftKey: String) in
                self.isFinished = finished
                self.isExecuting = false
                self.opFinishedBlock?(finished, giftKey)
            })
        }
    }

}






















