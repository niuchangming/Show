//
//  LiveData.swift
//  DouYin
//
//  Created by Niu Changming on 14/8/18.
//  Copyright © 2018 Niu Changming. All rights reserved.
//

import UIKit
import HandyJSON

class LiveData: HandyJSON {
    var data = [Live]()
    var requiredTime = Date()
    var pageIndex: Int = 0
    var pageSize: Int = 20
    var isFinished: Bool = false
    
    required init() {}
    
    func getData(completed :@escaping (Status) -> ()) {
        
        if isFinished {
            return
        }
        
        ConnectionManager.shareManager.request(method: .post, url: String(format: "%@broadcast/getlist", Constants.HOST), parames: ["expires": NSNumber.init(value: requiredTime.toMillis()), "pageIndex": NSNumber.init(value: pageIndex), "pageSize": NSNumber.init(value: pageSize)], succeed: { (responseJson) in
    
            let response = responseJson as! NSDictionary
            let errorCode = response["errorCode"] as! Int
            if errorCode == 1 {
                let model = LiveData.deserialize(from: responseJson as? NSDictionary)
                
                if (model?.data.count)! < 20 {
                    self.data = self.data + (model?.data)!
                    self.isFinished = true
                }else{
                    self.data = self.data + (model?.data)!
                    self.pageIndex = self.pageIndex + 1
                }
                completed(.success)
            }else{
                completed(.failure)
            }
        }) { (error) in
            completed(.failure)
        }
    }
}

class Live: HandyJSON{
    var userCode: String = ""
    var preview: String = ""
    var resourceUri: String = ""
    var tag: [String]?
    var id : String = ""
    var author: String = ""
    var gender: String = ""
    var nickname: String = ""
    var description: String = ""
    var interests: [String]?
    var channelId: String = ""
    var lon: Double = 0
    var lat: Double = 0
    var userLikeCount: Int = 0
    var ranking: Int = 0
    var commentCount: Int = 0
    var followingCount: Int = 0
    var faouriteCount: Int = 0
    var audienceCount: Int = 0
    var coinAmount: Int = 0
    var avatar: Photo?
    var coverImage: Photo?
    
    required init() {}
}

class Photo: HandyJSON{
    var small: String = ""
    var medium: String = ""
    var origin: String = ""
    
    required init() {}
}



