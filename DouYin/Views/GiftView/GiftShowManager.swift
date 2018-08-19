//
//  GiftShowManager.swift
//  DouYin
//
//  Created by Niu Changming on 16/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit

typealias completeBlock = (_ finished: Bool) -> Void
typealias showGifImageBlock = (_ giftSend: GiftSend) -> Void

class GiftShowManager: NSObject {
    let giftMaxNum: Int = 99
    var curentGiftKeys = NSMutableArray()
    var showGifImageBlock: showGifImageBlock?
    var finishedBlock: completeBlock?
    
    lazy var giftQueue1: OperationQueue = {
        var queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    lazy var giftQueue2: OperationQueue = {
        var queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    lazy var operationCache: NSCache<NSString, GiftOperation> = {
        let cache = NSCache<NSString, GiftOperation>()
        return cache
    }()
    
    lazy var giftShowView1: GiftShowView = {
        let giftShowView = Bundle.main.loadNibNamed("GiftShowView", owner: nil, options: nil)?[0] as! GiftShowView
        giftShowView.showViewKeyBlock = { [unowned self] (giftSend: GiftSend) -> Void in
                self.curentGiftKeys.add(giftSend.id)
                self.showGifImageBlock?(giftSend)
            }
        return giftShowView
    }()
    
    lazy var giftShowView2: GiftShowView = {
        let giftShowView = Bundle.main.loadNibNamed("GiftShowView", owner: nil, options: nil)?[0] as! GiftShowView
        
        giftShowView.frame = CGRect(x: giftShowView.frame.origin.x, y: giftShowView.frame.origin.y - giftShowView.frame.size.height - Constants.Dimension.MARGIN_LARGE * 2, width: giftShowView.frame.size.width, height: giftShowView.frame.size.height)
        giftShowView.showViewKeyBlock = { [unowned self] (giftSend: GiftSend) -> Void in
            self.curentGiftKeys.add(giftSend.id)
            self.showGifImageBlock?(giftSend)
        }
        return giftShowView
    }()
    

    private static var sharedGiftShowManager: GiftShowManager = {
        let giftShowManager = GiftShowManager()
        return giftShowManager
    }()
    
    class func shared() -> GiftShowManager {
        return sharedGiftShowManager
    }
    
    func showGiftViewWithBackBiew(backView: UIView, giftSend: GiftSend, completeBlock: completeBlock){
        self.showGiftViewWithBackView(backView: backView, giftSend: giftSend, completeBlock: completeBlock, showGifImageBlock: {_ in })
    }
    
    func showGiftViewWithBackView(backView: UIView, giftSend: GiftSend, completeBlock: completeBlock, showGifImageBlock: @escaping showGifImageBlock)  {
        self.showGifImageBlock = showGifImageBlock
      
        if(self.curentGiftKeys.count > 0 && self.curentGiftKeys.contains(giftSend.id)){
            if (self.operationCache.object(forKey: giftSend.id as NSString) != nil) {
                let op: GiftOperation = self.operationCache.object(forKey: giftSend.id as NSString)!
                if (op.giftShowView?.currentGiftCount)! >= self.giftMaxNum{
                    self.operationCache.removeObject(forKey: giftSend.id as NSString)
                    self.curentGiftKeys.remove(giftSend.id)
                }else{
                    op.giftShowView?.giftCount = 1
                }
            }else{
                var queue: OperationQueue?
                var showView: GiftShowView?
                
                print("if--------> 1: \(self.giftQueue1.operations.count), 2: \(self.giftQueue2.operations.count)")
                if(self.giftQueue1.operations.count <= self.giftQueue2.operations.count){
                    queue = self.giftQueue1
                    showView = self.giftShowView1
                }else{
                    queue = self.giftQueue2
                    showView = self.giftShowView2
                }
                
                let operation: GiftOperation = GiftOperation.addOperationWithView(giftShowView: showView!, backView: backView, giftSend: giftSend, completeBlock: { (finished: Bool, giftKey: String) in
                    self.finishedBlock?(finished)
                    self.operationCache.removeObject(forKey: giftKey as NSString)
                    self.curentGiftKeys.remove(giftKey)
                })
                operation.giftSend?.defaultCount += giftSend.sendCount;
                self.operationCache.setObject(operation, forKey: giftSend.id as NSString)
                queue?.addOperation(operation)
            }
        }else{
            if (self.operationCache.object(forKey: giftSend.id as NSString) != nil) {
                let op: GiftOperation = self.operationCache.object(forKey: giftSend.id as NSString)!
                
                if((op.giftSend?.defaultCount)! >= self.giftMaxNum){
                    self.operationCache.removeObject(forKey: giftSend.id as NSString)
                    self.curentGiftKeys.remove(giftSend.id)
                }else{
                    op.giftSend?.defaultCount += giftSend.sendCount
                }
            }else{
                let queue: OperationQueue?
                let showView: GiftShowView?
                
                print("else--------> 1: \(self.giftQueue1.operations.count), 2: \(self.giftQueue2.operations.count)")
                
                
                if(self.giftQueue1.operations.count <= self.giftQueue2.operations.count){
                    queue = self.giftQueue1
                    showView = self.giftShowView1
                }else{
                    queue = self.giftQueue2
                    showView = self.giftShowView2
                }
                
                let operation: GiftOperation = GiftOperation.addOperationWithView(giftShowView: showView!, backView: backView, giftSend: giftSend, completeBlock: { (finished: Bool, giftKey: String) in
                    self.finishedBlock?(finished)
                    if(self.giftShowView1.finishGift?.id == self.giftShowView2.finishGift?.id){
                        return;
                    }
                    self.operationCache.removeObject(forKey: giftKey as NSString)
                    self.curentGiftKeys.remove(giftKey)
                })
                operation.giftSend?.defaultCount += giftSend.sendCount
                self.operationCache.setObject(operation, forKey: giftSend.id as NSString)
                queue?.addOperation(operation)
                
            }
        
        }
    }


}
