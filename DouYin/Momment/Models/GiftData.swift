//
//  Gift.swift
//  DouYin
//
//  Created by Niu Changming on 14/7/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import HandyJSON

class GiftData: HandyJSON {
    var data = [Gift]()
    
    required init() {}
    
    func getData(message:@escaping (String) -> ()) {
        ConnectionManager.shareManager.request(method: .post, url: String(format: "%@gift/getGifts", Constants.HOST), parames: nil, succeed: { (responseJson) in
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            if errorCode == 1 {
                let model = GiftData.deserialize(from: responseJson as? NSDictionary)
                self.data = (model?.data)!
                message("Success")
            }else{
                message("Fail")
            }
        }) { (error) in
            message("Fail")
        }
    }
}


class Gift: HandyJSON{
    var id: String = ""
    var name: String = ""
    var filename: String = ""
    var price: Double = 0
    var score: String = ""
    var category: String = ""
    var sort: String = ""
    var costType: String = ""
    var weight: String = ""
    var giftid: String = ""
    var image: String = ""
    var animImage: String = ""
    var isSelected: Bool = false

    required init() {}
}

class GiftSend: HandyJSON{
    var id: String = ""
    var icon: String = ""
    var icon_gif: String = ""
    var name: String = ""
    var username: String = ""
    var defaultCount: Int = 0
    var sendCount: Int = 0
    
    required init() {}
}


