//
//  LiveCollectionCellBottom.swift
//  NDYingKe_swift4
//
//  Created by 李家奇_南湖国旅 on 2017/9/6.
//  Copyright © 2017年 NorthDogLi. All rights reserved.
//

import UIKit

class LiveCollectionCellBottom: UIView {

    enum LivingBottomViewBtnClickType {
        case hotMessageType
        case hot_e_mailClickType
        case hot_giftClickType
        case hot_shareClickType
        case hot_gobackClickType
    }

    public var bottomViewBtnClickBlock: ((LivingBottomViewBtnClickType) -> Void)?

    class func instanceFromNib() -> LiveCollectionCellBottom {
        return Bundle.main.loadNibNamed("LiveCollectionCellBottom", owner: nil, options: nil)?[0] as! LiveCollectionCellBottom
    }
    
    @IBAction func hotMessage(_ sender: UIButton) {
        if (self.bottomViewBtnClickBlock != nil) {
            self.bottomViewBtnClickBlock?(LivingBottomViewBtnClickType.hotMessageType)
        }
    }
    
    @IBAction func hot_giftClick(_ sender: UIButton) {
        if (self.bottomViewBtnClickBlock != nil) {
            self.bottomViewBtnClickBlock?(LivingBottomViewBtnClickType.hot_giftClickType)
        }
    }
    
    @IBAction func hot_shareClick(_ sender: UIButton) {
        if (self.bottomViewBtnClickBlock != nil) {
            self.bottomViewBtnClickBlock?(LivingBottomViewBtnClickType.hot_shareClickType)
        }
    }
    
    @IBAction func hot_gobackClick(_ sender: UIButton) {
        if (self.bottomViewBtnClickBlock != nil) {
            self.bottomViewBtnClickBlock?(LivingBottomViewBtnClickType.hot_gobackClickType)
        }
    }

}
